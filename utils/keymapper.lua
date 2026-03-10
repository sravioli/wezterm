---@module 'utils.keymapper'

local str = require "utils.fn.str" ---@class Fn.String

local sgsub, ssub, smatch, sformat = string.gsub, string.sub, string.match, string.format
local tconcat = table.concat
local _hint_entries_cache = nil
local _modes_cache_key = nil
local _modes_cache = nil

---@class KeyMeta
---@field i    string  icon glyph (e.g. "󰆏")
---@field txt  string  label text (e.g. "COPY")
---@field bg   string  background colour
---@field pad? number  optional padding override
---@field name? string key-table name (injected by `tables()`)

---@class KeyTableDef
---@field meta KeyMeta
---@field keys table[]

---@alias KeyTableDefFn fun(theme: table): KeyTableDef

local wt = require "wezterm" ---@class Wezterm

---@class Keymapper
local M = {
  ---@package
  aliases = {
    -- Vim-style aliases mapped to WezTerm key names
    CR = "Enter",
    BS = "Backspace",
    ESC = "Escape",
    Bar = "|",
    -- Arrow keys
    Up = "UpArrow",
    Down = "DownArrow",
    Left = "LeftArrow",
    Right = "RightArrow",
    -- Numpad
    k0 = "Numpad0",
    k1 = "Numpad1",
    k2 = "Numpad2",
    k3 = "Numpad3",
    k4 = "Numpad4",
    k5 = "Numpad5",
    k6 = "Numpad6",
    k7 = "Numpad7",
    k8 = "Numpad8",
    k9 = "Numpad9",
    lt = "<",
    gt = ">",
    PageUp = "PageUp",
    PageDown = "PageDown",
    F1 = "F1",
    F2 = "F2",
    F3 = "F3",
    F4 = "F4",
    F5 = "F5",
    F6 = "F6",
    F7 = "F7",
    F8 = "F8",
    F9 = "F9",
    F10 = "F10",
    F11 = "F11",
    F12 = "F12",
  },

  ---@package
  modifiers = {
    C = "CTRL",
    S = "SHIFT",
    A = "ALT",
    M = "ALT",
    W = "SUPER",
  },

  ---@private raw definitions stored by tables(), resolved by get_modes(theme)
  ---@type table<string, KeyTableDef|KeyTableDefFn>
  _defs = {},
}

---@package
M._log = require("utils.logger"):new "Utils.Keymapper"

---@package
M.__check = function(lhs, rhs, tbl)
  if not lhs then
    M._log:error("cannot map %s without lhs!", rhs)
    return false
  elseif not rhs then
    M._log:error("cannot map %s to a nil action!", lhs)
    return false
  elseif not tbl then
    M._log:error "cannot add keymaps! No table given"
    return false
  end
  return true
end

---@package
M.__has_leader = function(lhs, mods)
  if smatch(lhs, "^<[Ll][Ee][Aa][Dd][Ee][Rr]>") then
    lhs = sgsub(lhs, "^<[Ll][Ee][Aa][Dd][Ee][Rr]>", "")
    mods[#mods + 1] = "LEADER"
  end
  return lhs
end

---@param lhs string Keymap string to validate (e.g., "<C-a>").
---@return boolean valid True if the keymap is syntactically valid.
---@return string|nil error Error message if invalid, nil otherwise.
M.validate = function(lhs)
  if not lhs or type(lhs) ~= "string" then
    return false, "keymap must be a non-empty string"
  end
  if #lhs == 1 then
    return true
  end

  local test_lhs = lhs
  if smatch(test_lhs, "^<[Ll][Ee][Aa][Dd][Ee][Rr]>") then
    test_lhs = sgsub(test_lhs, "^<[Ll][Ee][Aa][Dd][Ee][Rr]>", "")
  end
  if not test_lhs:match "%b<>" then
    return true
  end

  local normalized = sgsub(test_lhs, "(%b<>)", function(s)
    return ssub(s, 2, -2)
  end)
  local keys = str.split(normalized, "%-")
  if #keys == 1 then
    return true
  end

  local k = keys[#keys]
  if M.modifiers[k] then
    return false, "keymap cannot end with modifier!"
  end
  for i = 1, #keys - 1 do
    if not M.modifiers[keys[i]] then
      return false, sformat("unknown modifier: %s", keys[i])
    end
  end
  return true
end

M.map = function(lhs, rhs, tbl)
  if not M.__check(lhs, rhs, tbl) then
    return
  end

  local function __map(key, mods)
    local mods_str = tconcat(mods or {}, "|")
    tbl[#tbl + 1] = {
      key = key,
      mods = mods_str ~= "" and mods_str or nil,
      action = rhs,
    }
  end

  local mods = {}
  if #lhs == 1 then
    return __map(lhs, mods)
  end

  local aliases, modifiers = M.aliases, M.modifiers
  lhs = M.__has_leader(lhs, mods)
  if not smatch(lhs, "%b<>") then
    return __map(lhs, mods)
  end

  lhs = sgsub(lhs, "(%b<>)", function(s)
    return ssub(s, 2, -2)
  end)
  local keys = str.split(lhs, "%-")
  if #keys == 1 then
    return __map(aliases[keys[1]] or keys[1], mods)
  end

  local nkeys = #keys
  local k = keys[nkeys]
  if modifiers[k] then
    return M._log:error "keymap cannot end with modifier!"
  end
  k = aliases[k] or k

  -- Loop up to nkeys-1 so we never mutate the (possibly cached) keys table.
  for i = 1, nkeys - 1 do
    mods[#mods + 1] = modifiers[keys[i]]
  end

  return __map(k, mods)
end

M.map_batch = function(mappings, tbl)
  if not mappings then
    M._log:error "cannot batch map: no mappings provided"
    return
  end
  if not tbl then
    M._log:error "cannot batch map: no table provided"
    return
  end

  local ok, fail = 0, 0
  for idx, mapping in ipairs(mappings) do
    if type(mapping) == "table" and #mapping >= 2 then
      local before = #tbl
      M.map(mapping[1], mapping[2], tbl)
      if #tbl > before and mapping[3] then
        tbl[#tbl].desc = mapping[3]
      end
      ok = ok + 1
    else
      M._log:error(
        "invalid mapping format at index %d: expected {lhs, rhs[, desc]}, got %s",
        idx,
        type(mapping)
      )
      fail = fail + 1
    end
  end

  M._log:debug("batch map complete: %d succeeded, %d failed", ok, fail)
end

M.table = function(mappings)
  local key_table = {}
  if not mappings then
    M._log:error "cannot create key table: no mappings provided"
    return key_table
  end
  M.map_batch(mappings, key_table)
  return key_table
end

---Resolve a raw definition (plain table or function) against `theme`.
---@param  name  string
---@param  def   KeyTableDef|KeyTableDefFn
---@param  theme table
---@return KeyTableDef|nil
local function resolve_def(name, def, theme)
  if type(def) == "function" then
    return def(theme)
  end
  if type(def) == "table" then
    return def
  end
  M._log:error("key table '%s' must be a table or function, got %s", name, type(def))
  return nil
end

---@param config table WezTerm configuration object to update.
---@param mappings table[] Array of {lhs, rhs[, desc]} mappings.
M.maps = function(config, mappings)
  config.keys = config.keys or {}
  M.map_batch(mappings, config.keys)
end

local function proxy_theme()
  local proxy
  proxy = setmetatable({}, {
    __index = function()
      return proxy
    end,
  })
  return proxy
end

local function normalize_lhs(lhs)
  if type(lhs) ~= "string" or lhs == "" then
    return nil
  end

  local tmp = {}
  M.map(lhs, true, tmp)
  if #tmp == 0 then
    return nil
  end

  return M.__entry_lhs(tmp[1])
end

local function normalize_set(values)
  local set = {}
  for _, lhs in ipairs(values or {}) do
    local norm = normalize_lhs(lhs)
    if norm then
      set[norm] = true
    end
  end
  return set
end

local function parse_spec(spec)
  if type(spec) ~= "table" then
    return nil
  end

  if spec.rhs ~= nil then
    return spec.rhs, spec.desc
  end

  local rhs = spec[1]
  if rhs == nil then
    return nil
  end
  return rhs, spec[2]
end

local function apply_wez_entries(entries, spec)
  local out = {}
  for i = 1, #(entries or {}) do
    out[#out + 1] = entries[i]
  end

  local disabled = normalize_set(spec and spec.disable)
  if next(disabled) then
    local filtered = {}
    for i = 1, #out do
      local entry = out[i]
      local lhs = M.__entry_lhs(entry)
      if not disabled[lhs] then
        filtered[#filtered + 1] = entry
      end
    end
    out = filtered
  end

  local by_lhs = {}
  for i = 1, #out do
    by_lhs[M.__entry_lhs(out[i])] = i
  end

  for lhs, value in pairs(spec and spec.override or {}) do
    local normalized = normalize_lhs(lhs)
    local rhs, desc = parse_spec(value)
    if normalized and rhs ~= nil then
      local idx = by_lhs[normalized]
      if idx then
        out[idx].action = rhs
        if desc ~= nil then
          out[idx].desc = desc
        end
      else
        M.map(lhs, rhs, out)
        if desc ~= nil then
          out[#out].desc = desc
        end
        by_lhs[normalized] = #out
      end
    end
  end

  for _, mapping in ipairs(spec and spec.add or {}) do
    if type(mapping) == "table" and #mapping >= 2 then
      local lhs, rhs, desc = mapping[1], mapping[2], mapping[3]
      M.map(lhs, rhs, out)
      if #out > 0 and desc ~= nil then
        out[#out].desc = desc
      end
    end
  end

  return out
end

local function apply_raw_entries(entries, spec)
  local out = {}
  for i = 1, #(entries or {}) do
    local entry = entries[i]
    if type(entry) == "table" then
      out[#out + 1] = { entry[1], entry[2], entry[3] }
    end
  end

  local disabled = normalize_set(spec and spec.disable)
  if next(disabled) then
    local filtered = {}
    for i = 1, #out do
      local entry = out[i]
      local lhs = normalize_lhs(entry[1])
      if not lhs or not disabled[lhs] then
        filtered[#filtered + 1] = entry
      end
    end
    out = filtered
  end

  local by_lhs = {}
  for i = 1, #out do
    local lhs = normalize_lhs(out[i][1])
    if lhs then
      by_lhs[lhs] = i
    end
  end

  for lhs, value in pairs(spec and spec.override or {}) do
    local normalized = normalize_lhs(lhs)
    local rhs, desc = parse_spec(value)
    if normalized and rhs ~= nil then
      local idx = by_lhs[normalized]
      if idx then
        out[idx][1] = lhs
        out[idx][2] = rhs
        if desc ~= nil then
          out[idx][3] = desc
        end
      else
        out[#out + 1] = { lhs, rhs, desc }
        by_lhs[normalized] = #out
      end
    end
  end

  for _, mapping in ipairs(spec and spec.add or {}) do
    if type(mapping) == "table" and #mapping >= 2 then
      out[#out + 1] = { mapping[1], mapping[2], mapping[3] }
    end
  end

  return out
end

---Apply user mapping overrides to both emitted config tables and keymapper defs.
---@param config table WezTerm configuration table.
---@param overrides table User overrides from `overrides.mappings`.
M.apply_overrides = function(config, overrides)
  if type(overrides) ~= "table" then
    return
  end

  local enabled = overrides.enabled or {}

  if enabled.keys == false then
    config.keys = {}
  else
    config.keys = apply_wez_entries(config.keys or {}, overrides.keys or {})
  end

  if enabled.key_tables == false then
    config.key_tables = {}
    M._defs = {}
  else
    config.key_tables = config.key_tables or {}
    local table_specs = overrides.key_tables or {}

    for name, spec in pairs(table_specs) do
      if type(spec) == "table" then
        if spec.enabled == false then
          config.key_tables[name] = nil
          M._defs[name] = nil
        else
          local existing = config.key_tables[name] or {}
          config.key_tables[name] = apply_wez_entries(existing, spec)

          local def = M._defs[name]
          if def then
            M._defs[name] = function(theme)
              local resolved = resolve_def(name, def, theme)
              if not resolved then
                return nil
              end

              local next_resolved = {
                meta = resolved.meta,
                keys = apply_raw_entries(resolved.keys or {}, spec),
              }
              if next_resolved.meta then
                next_resolved.meta.name = name
              end
              return next_resolved
            end
          end
        end
      end
    end
  end

  _hint_entries_cache = nil
  _modes_cache_key = nil
  _modes_cache = nil
end

M.tables = function(config, defs)
  if not defs then
    M._log:error "cannot register key tables: no definitions provided"
    return
  end

  M._defs = defs
  _hint_entries_cache = nil

  -- Nil-safe proxy: any field access returns the proxy itself so expressions
  -- like `theme.brights[3]` in a function-form definition never error when
  -- called without a real theme (we only need the `keys` arrays here).
  local proxy = proxy_theme()

  config.key_tables = config.key_tables or {}

  for name, def in pairs(defs) do
    local resolved = resolve_def(name, def, proxy)
    if resolved then
      if resolved.meta then
        resolved.meta.name = name
      end
      if resolved.keys then
        config.key_tables[name] = M.table(resolved.keys)
      else
        M._log:error("key table '%s' is missing a 'keys' field", name)
      end
    end
  end
end

--- Build a cheap, stable identity string from the theme table.
--- Uses foreground + background + ansi[5] which are unique per colour scheme
--- and are always plain strings, avoiding reference-equality pitfalls.
---@param theme table
---@return string
local function theme_cache_key(theme)
  return tostring(theme.foreground or "")
    .. "|" .. tostring(theme.background or "")
    .. "|" .. tostring(theme.ansi and theme.ansi[5] or "")
end

M.get_modes = function(theme)
  local key = theme_cache_key(theme)
  if key == _modes_cache_key and _modes_cache then
    return _modes_cache
  end
  local modes = {}
  for name, def in pairs(M._defs or {}) do
    local resolved = resolve_def(name, def, theme)
    if resolved then
      if resolved.meta then
        modes[name] = resolved.meta
      else
        M._log:warn("key table '%s' has no 'meta' field; skipped in get_modes()", name)
      end
    end
  end
  _modes_cache_key = key
  _modes_cache = modes
  return modes
end

--- Lazily build and cache the WezTerm-key → vim-key reverse lookup.
local function get_rev_aliases()
  if not M._rev_aliases then
    local rev = {}
    for vim_key, wez_key in pairs(M.aliases) do
      rev[wez_key] = vim_key
    end
    M._rev_aliases = rev
  end
  return M._rev_aliases
end

--- Split a `"LEADER|CTRL|SHIFT"` mods string into a leader flag and short parts.
---@param  mods_str string
---@return boolean  has_leader
---@return string[] mod_parts  e.g. `{"C","S"}`
local function parse_mods(mods_str)
  local rev_mods = { CTRL = "C", SHIFT = "S", ALT = "A", SUPER = "W" }
  local has_leader, parts = false, {}
  for mod in mods_str:gmatch "[^|]+" do
    if mod == "LEADER" then
      has_leader = true
    else
      parts[#parts + 1] = rev_mods[mod] or mod
    end
  end
  return has_leader, parts
end

--- Reconstruct a vim-style lhs from its components.
local function format_lhs(display_key, mod_parts, has_leader)
  local lhs
  if #mod_parts > 0 then
    lhs = "<" .. tconcat(mod_parts, "-") .. "-" .. display_key .. ">"
  elseif #display_key > 1 then
    lhs = "<" .. display_key .. ">"
  else
    lhs = display_key
  end
  if has_leader then
    lhs = "<leader>" .. lhs
  end
  return lhs
end

---@package
---Reverse-map a stored WezTerm key entry back to a compact vim-style label.
---@param  entry table
---@return string
M.__entry_lhs = function(entry)
  local display_key = get_rev_aliases()[entry.key] or entry.key
  local has_leader, mod_parts = parse_mods(entry.mods or "")
  return format_lhs(display_key, mod_parts, has_leader)
end

---Return the `wezterm.GLOBAL` key scoped to a specific window + pane + table.
---@package
M.__hint_var = function(window_id, pane_id, name)
  return "hint_page_w" .. window_id .. "_p" .. pane_id .. "_" .. (name or "__keys__")
end

--- Collect entries that carry a non-empty `desc` as raw `{lhs, desc}` pairs.
--- Keeping them raw (not pre-rendered) lets both `hint()` and `hint_layout()`
--- share this step while formatting the content differently.
---@param  entries table[]
---@return {lhs:string, desc:string}[]
local function collect_raw(entries)
  local raw = {}
  for _, entry in ipairs(entries) do
    if entry.desc and entry.desc ~= "" then
      raw[#raw + 1] = { lhs = M.__entry_lhs(entry), desc = entry.desc }
    end
  end
  return raw
end

--- Pack raw `{lhs, desc}` items into pages that each fit within `budget` columns.
--- Separator `" / "` overhead is accounted for between items on the same page.
---@param  raw    {lhs:string, desc:string}[]
---@param  budget number
---@return {lhs:string, desc:string}[][]  pages
local function pack_pages(raw, budget)
  local sep_w = str.column_width " / "
  if #raw == 0 then
    return {}
  end

  local pages, page, used = {}, {}, 0
  for _, item in ipairs(raw) do
    local iw = str.column_width(item.lhs .. " " .. item.desc)
    if #page > 0 and used + sep_w + iw > budget then
      pages[#pages + 1] = page
      page, used = { item }, iw
    else
      if #page > 0 then
        used = used + sep_w
      end
      page[#page + 1] = item
      used = used + iw
    end
  end
  if #page > 0 then
    pages[#pages + 1] = page
  end
  return pages
end

--- Two-pass pagination: first determine total page count (at full `width`), then
--- repack at `width − indicator_width` so the `[N/M]` indicator always fits.
--- Reads and writes the current page index via `utils.fn.cache`.
---
---@param  entries  table[]
---@param  width    number
---@param  window   table   WezTerm window object
---@param  name     string? key-table name
---@return {lhs:string, desc:string}[]|nil  items   nil when there are no described entries
---@return string                            indicator  e.g. `" [2/4]"` or `""`
---@return integer                           ind_w      column width of the indicator field
local function current_page(entries, width, window, name)
  local cache = require "utils.fn.cache"
  local raw = collect_raw(entries)

  -- First pass: full-width probe to discover total page count.
  local probe = pack_pages(raw, width)
  local total = #probe
  if total == 0 then
    return nil, "", 0
  end
  if total == 1 then
    return probe[1], "", 0
  end

  -- Reserve space for the widest possible indicator, e.g. " [4/4]".
  local max_ind = sformat(" [%d/%d]", total, total)
  local ind_w = str.column_width(max_ind)

  -- Second pass: repack with the indicator reservation in place.
  local pages = pack_pages(raw, width - ind_w)
  total = #pages

  -- Read / clamp / persist the page index via the shared cache.
  local var_key = M.__hint_var(window:window_id(), window:active_pane():pane_id(), name)
  local stored = cache.get(var_key)
  local page = (type(stored) == "number") and stored or 1
  page = math.max(1, math.min(page, total))
  cache.memoize(var_key, page)

  -- Build the right-padded indicator so the total field width is stable.
  local indicator = sformat(" [%d/%d]", page, total)
  local pad = ind_w - str.column_width(indicator)
  if pad > 0 then
    indicator = indicator .. string.rep(" ", pad)
  end

  return pages[page], indicator, ind_w
end

--- Resolve the entries table for `name` from `config`.
---@param config table
---@param name   string?
---@return table[]
local function resolve_entries(config, name)
  local function has_descriptions(entries)
    for _, entry in ipairs(entries or {}) do
      if entry.desc and entry.desc ~= "" then
        return true
      end
    end
    return false
  end

  local function resolve_entries_from_defs(table_name)
    if type(table_name) ~= "string" or table_name == "" then
      return nil
    end

    _hint_entries_cache = _hint_entries_cache or {}
    if _hint_entries_cache[table_name] then
      return _hint_entries_cache[table_name]
    end

    local def = M._defs and M._defs[table_name]
    if not def then
      return nil
    end

    local proxy = proxy_theme()

    local resolved = resolve_def(table_name, def, proxy)
    if not resolved or not resolved.keys then
      return nil
    end

    local rebuilt = M.table(resolved.keys)
    _hint_entries_cache[table_name] = rebuilt
    return rebuilt
  end

  if not name then
    return config.keys or {}
  end

  local entries = config.key_tables and config.key_tables[name]
  if entries and has_descriptions(entries) then
    return entries
  end

  local fallback_entries = resolve_entries_from_defs(name)
  if fallback_entries then
    return fallback_entries
  end

  if not entries then
    M._log:warn("hint: key table '%s' not found", name)
  end
  return entries or {}
end

---Build a fixed-width paginated hint string (plain text, no colour).
---Prefer `hint_layout()` for status-bar use where colour is available.
---
---@param config  table       WezTerm config
---@param name    string|nil  key-table name, nil for `config.keys`
---@param width   number      desired output width in columns
---@param window  table       WezTerm window object
---@return string             exactly `width` columns
M.hint = function(config, name, width, window)
  local entries = resolve_entries(config, name)
  local items, indicator, ind_w = current_page(entries, width, window, name)

  if not items then
    return string.rep(" ", width)
  end

  local sep = " / "
  local sep_w = str.column_width(sep)
  local budget = width - ind_w
  local parts = {}
  local used = 0

  for _, item in ipairs(items) do
    local s = item.lhs .. " " .. item.desc
    local sw = str.column_width(s)
    local need = sw + (#parts > 0 and sep_w or 0)
    if used + need > budget then
      break
    end
    if #parts > 0 then
      used = used + sep_w
    end
    parts[#parts + 1] = s
    used = used + sw
  end

  local body = tconcat(parts, sep)
  local bw = str.column_width(body)
  if bw < budget then
    body = string.rep(" ", budget - bw) .. body
  end
  return body .. indicator
end

---Build a fixed-width paginated hint as a **Layout instance**.
---
---Visual style matches the legacy modal-prompt style:
---  * `<` and `>` brackets: `theme.foreground`, bold
---  * Key name between brackets: `opts.mode_bg`, normal weight
---  * Plain (non-bracketed) key: `opts.mode_bg`, bold
---  * Space + description: `theme.foreground`, italic
---  * Separator `" / "`: `theme.brights[1]`, not italic
---  * Padding and indicator: `theme.foreground`, plain
---
---Returns a `Layout` instance.  The renderer's `resolve_layout` detects it via
---`type(layout.format) == "function"` and calls `:format()` automatically, so
---the caller never needs to touch `wezterm.format()` directly.
---
---@usage
---~~~lua
----- Inside the `keys` module creator in opts/statusbar.lua:
---layout = function(ctx)
---  return keymapper.hint_layout(config, active_mode, budget.right_available(), window, {
---    theme   = ctx.theme,
---    mode_bg = mode.bg,
---  })
---end,
---~~~
---
---@param config  table       WezTerm config
---@param name    string|nil  key-table name, nil for `config.keys`
---@param width   number      desired output width in columns
---@param window  table       WezTerm window object
---@param opts    table       `{ theme: table, mode_bg: string }`
---@return Layout             Layout instance (call `:format()` to get the string)
M.hint_layout = function(config, name, width, window, opts)
  local Layout = require "utils.layout"
  local theme = opts.theme
  local mode_bg = tostring(opts.mode_bg)
  local bg = tostring(theme.tab_bar.background)
  local fg = tostring(theme.foreground)
  -- brights[1] is typically a dim/muted colour; fall back to fg if absent.
  local dim_fg = theme.brights and tostring(theme.brights[1]) or fg

  -- atomic = true so each :append() resets text attributes automatically,
  -- which means we never need to emit a manual "None" / ResetAttributes entry.
  local layout = Layout:new("HintBar", true)
  local entries = resolve_entries(config, name)
  local items, indicator, ind_w = current_page(entries, width, window, name)

  -- ── Empty state ──────────────────────────────────────────────────────────
  if not items then
    layout:append(bg, fg, string.rep(" ", width))
    return layout
  end

  -- ── Fit items to budget ───────────────────────────────────────────────────
  local sep_str = " / "
  local sep_w = str.column_width(sep_str)
  local budget = width - ind_w
  local used = 0
  local selected = {}

  for i, item in ipairs(items) do
    local item_w = str.column_width(item.lhs) + 1 + str.column_width(item.desc)
    local need = item_w + (i > 1 and sep_w or 0)
    if used + need > budget then
      break
    end

    selected[#selected + 1] = item
    if i > 1 then
      used = used + sep_w
    end
    used = used + item_w
  end

  -- Right-align body within available budget so short hints sit close to the
  -- right edge and page indicator.
  if used < budget then
    layout:append(bg, fg, string.rep(" ", budget - used))
  end

  ---Append a single lhs token with the correct bracket styling.
  ---Brackets `<`/`>` use `fg`+bold; the inner key uses `mode_bg`+normal.
  ---A plain (non-bracketed) key uses `mode_bg`+bold.
  local function append_lhs(lhs)
    if lhs:sub(1, 1) == "<" and lhs:sub(-1) == ">" then
      layout:append(bg, fg, "<", "Bold")
      layout:append(bg, mode_bg, lhs:sub(2, -2), "Normal")
      layout:append(bg, fg, ">", "Bold")
    else
      layout:append(bg, mode_bg, lhs, "Bold")
    end
  end

  -- ── Render selected items ────────────────────────────────────────────────
  for i, item in ipairs(selected) do
    if i > 1 then
      layout:append(bg, dim_fg, sep_str, "Normal")
    end

    append_lhs(item.lhs)
    layout:append(bg, fg, " " .. item.desc, "Italic")
  end

  -- ── Pagination indicator ──────────────────────────────────────────────
  if indicator ~= "" then
    layout:append(bg, fg, indicator, "Normal")
  end

  return layout
end

---Return a `wezterm.action_callback` that advances or retreats the hint page.
---
---@param name      string|nil  key-table name, nil for `config.keys`
---@param direction number      `1` = forward, `-1` = backward
---@return table                `wezterm.action_callback`

M.hint_action = function(name, direction)
  return wt.action_callback(function(window, pane)
    local cache = require "utils.fn.cache"
    local active_pane = window:active_pane()
    local pane_id = active_pane and active_pane:pane_id() or pane:pane_id()
    local active_name = window:active_key_table() or name
    local var_key = M.__hint_var(window:window_id(), pane_id, active_name)
    local current = cache.get(var_key)
    local page = (type(current) == "number") and current or 1

    -- Advance; current_page() will clamp to [1, total] on the next render.
    page = math.max(1, page + direction)

    cache.memoize(var_key, page)

    -- Force update-status to re-fire so the hint repaints immediately.
    window:set_right_status ""
  end)
end

return M

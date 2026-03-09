-- ---@module 'utils.keymapper'
--
-- local str = require "utils.fn.str" ---@class Fn.String
--
-- local sgsub, ssub, smatch, sformat = string.gsub, string.sub, string.match, string.format
-- local tconcat = table.concat
--
-- ---@class Keymapper
-- local M = {
--   ---@package
--   aliases = {
--     -- Vim-style aliases mapped to WezTerm key names
--     CR = "Enter",
--     BS = "Backspace",
--     ESC = "Escape",
--     Bar = "|",
--     -- Arrow keys
--     Up = "UpArrow",
--     Down = "DownArrow",
--     Left = "LeftArrow",
--     Right = "RightArrow",
--     -- Numpad
--     k0 = "Numpad0",
--     k1 = "Numpad1",
--     k2 = "Numpad2",
--     k3 = "Numpad3",
--     k4 = "Numpad4",
--     k5 = "Numpad5",
--     k6 = "Numpad6",
--     k7 = "Numpad7",
--     k8 = "Numpad8",
--     k9 = "Numpad9",
--     lt = "<",
--     gt = ">",
--     PageUp = "PageUp",
--     PageDown = "PageDown",
--     F1 = "F1",
--     F2 = "F2",
--     F3 = "F3",
--     F4 = "F4",
--     F5 = "F5",
--     F6 = "F6",
--     F7 = "F7",
--     F8 = "F8",
--     F9 = "F9",
--     F10 = "F10",
--     F11 = "F11",
--     F12 = "F12",
--   },
--
--   ---@package
--   modifiers = {
--     C = "CTRL",
--     S = "SHIFT",
--     A = "ALT",
--     M = "ALT",
--     W = "SUPER",
--   },
--
--   ---@private raw definitions stored by tables(), resolved by get_modes(theme)
--   ---@type table<string, Keymapper.TableDef|Keymapper.TableDefFn>
--   _defs = {},
-- }
--
-- -- ──────────────────────────────────────────────────────────────────────────────
-- -- Internal helpers
-- -- ──────────────────────────────────────────────────────────────────────────────
--
-- ---@package Class logger
-- M._log = require("utils.logger"):new "Utils.Keymapper"
--
-- ---Nil-check given parameters before mapping.
-- ---
-- ---@package
-- ---@param lhs string? Left-hand side key sequence.
-- ---@param rhs (string|table)? Right-hand side action or sequence.
-- ---@param tbl table? Destination table.
-- ---@return boolean valid True if parameters are valid.
-- M.__check = function(lhs, rhs, tbl)
--   if not lhs then
--     M._log:error("cannot map %s without lhs!", rhs)
--     return false
--   elseif not rhs then
--     M._log:error("cannot map %s to a nil action!", lhs)
--     return false
--   elseif not tbl then
--     M._log:error "cannot add keymaps! No table given"
--     return false
--   end
--   return true
-- end
--
-- ---Strip leading `<leader>` prefix and append `"LEADER"` to modifiers.
-- ---
-- ---@package
-- ---@param lhs string Left-hand side key sequence.
-- ---@param mods table Modifiers table.
-- ---@return string lhs Stripped key sequence.
-- M.__has_leader = function(lhs, mods)
--   if smatch(lhs, "^<[Ll][Ee][Aa][Dd][Ee][Rr]>") then
--     lhs = sgsub(lhs, "^<[Ll][Ee][Aa][Dd][Ee][Rr]>", "")
--     mods[#mods + 1] = "LEADER"
--   end
--   return lhs
-- end
--
-- ---Validate vim-style keymap string without mapping it.
-- ---
-- ---@param lhs string Left-hand side key sequence.
-- ---@return boolean valid True if keymap is valid.
-- ---@return string? error Error message if invalid.
-- M.validate = function(lhs)
--   if not lhs or type(lhs) ~= "string" then
--     return false, "keymap must be a non-empty string"
--   end
--   if #lhs == 1 then
--     return true
--   end
--
--   local test_lhs = lhs
--   if smatch(test_lhs, "^<[Ll][Ee][Aa][Dd][Ee][Rr]>") then
--     test_lhs = sgsub(test_lhs, "^<[Ll][Ee][Aa][Dd][Ee][Rr]>", "")
--   end
--   if not test_lhs:match "%b<>" then
--     return true
--   end
--
--   local normalized = sgsub(test_lhs, "(%b<>)", function(s)
--     return ssub(s, 2, -2)
--   end)
--   local keys = str.split(normalized, "%-")
--   if #keys == 1 then
--     return true
--   end
--
--   local k = keys[#keys]
--   if M.modifiers[k] then
--     return false, "keymap cannot end with modifier!"
--   end
--   for i = 1, #keys - 1 do
--     if not M.modifiers[keys[i]] then
--       return false, sformat("unknown modifier: %s", keys[i])
--     end
--   end
--   return true
-- end
--
-- ---Translate vim-style keymap and insert it into table in WezTerm format.
-- ---
-- ---@param lhs string Left-hand side key sequence.
-- ---@param rhs string|table Right-hand side action.
-- ---@param tbl table Destination table.
-- M.map = function(lhs, rhs, tbl)
--   if not M.__check(lhs, rhs, tbl) then
--     return
--   end
--
--   local function __map(key, mods)
--     local mods_str = tconcat(mods or {}, "|")
--     tbl[#tbl + 1] = {
--       key = key,
--       mods = mods_str ~= "" and mods_str or nil,
--       action = rhs,
--     }
--   end
--
--   local mods = {}
--   if #lhs == 1 then
--     return __map(lhs, mods)
--   end
--
--   local aliases, modifiers = M.aliases, M.modifiers
--   lhs = M.__has_leader(lhs, mods)
--   if not smatch(lhs, "%b<>") then
--     return __map(lhs, mods)
--   end
--
--   lhs = sgsub(lhs, "(%b<>)", function(s)
--     return ssub(s, 2, -2)
--   end)
--   local keys = str.split(lhs, "%-")
--   if #keys == 1 then
--     return __map(aliases[keys[1]] or keys[1], mods)
--   end
--
--   local k = keys[#keys]
--   if modifiers[k] then
--     return M._log:error "keymap cannot end with modifier!"
--   else
--     keys[#keys] = nil
--   end
--   k = aliases[k] or k
--
--   for i = 1, #keys do
--     mods[#mods + 1] = modifiers[keys[i]]
--   end
--
--   return __map(k, mods)
-- end
--
-- ---Map multiple mappings pairs into destination table.
-- ---
-- ---@param mappings table[] Array of {lhs, rhs, desc?} mapping definitions.
-- ---@param tbl table Destination table.
-- M.map_batch = function(mappings, tbl)
--   if not mappings then
--     M._log:error "cannot batch map: no mappings provided"
--     return
--   end
--   if not tbl then
--     M._log:error "cannot batch map: no table provided"
--     return
--   end
--
--   local ok, fail = 0, 0
--   for idx, mapping in ipairs(mappings) do
--     if type(mapping) == "table" and #mapping >= 2 then
--       local before = #tbl
--       M.map(mapping[1], mapping[2], tbl)
--       if #tbl > before and mapping[3] then
--         tbl[#tbl].desc = mapping[3]
--       end
--       ok = ok + 1
--     else
--       M._log:error(
--         "invalid mapping format at index %d: expected {lhs, rhs[, desc]}, got %s",
--         idx,
--         type(mapping)
--       )
--       fail = fail + 1
--     end
--   end
--
--   M._log:debug("batch map complete: %d succeeded, %d failed", ok, fail)
-- end
--
-- ---Build standalone WezTerm key-table from mapping pairs.
-- ---
-- ---@param mappings table[] Array of {lhs, rhs, desc?} mapping definitions.
-- ---@return table key_table Constructed key table.
-- M.table = function(mappings)
--   local key_table = {}
--   if not mappings then
--     M._log:error "cannot create key table: no mappings provided"
--     return key_table
--   end
--   M.map_batch(mappings, key_table)
--   return key_table
-- end
--
-- --- Resolve a raw definition (plain table or function) against `theme`.
-- --- Returns the resolved table, or `nil` with an error logged when the type
-- --- is invalid.
-- ---
-- ---@param  name string
-- ---@param  def  Keymapper.TableDef|Keymapper.TableDefFn
-- ---@param  theme table
-- ---@return Keymapper.TableDef|nil
-- local function resolve_def(name, def, theme)
--   if type(def) == "function" then
--     return def(theme)
--   end
--   if type(def) == "table" then
--     return def
--   end
--   M._log:error("key table '%s' must be a table or function, got %s", name, type(def))
--   return nil
-- end
--
-- ---Append batch of keymaps to configuration keys.
-- ---
-- ---@param config table WezTerm config object.
-- ---@param mappings table[] Array of {lhs, rhs, desc?} mapping definitions.
-- M.maps = function(config, mappings)
--   config.keys = config.keys or {}
--   M.map_batch(mappings, config.keys)
-- end
--
-- ---Register named key tables into configuration and store raw definitions.
-- ---
-- ---@param config table WezTerm config object.
-- ---@param defs table<string, Keymapper.TableDef|Keymapper.TableDefFn> Definitions to register.
-- M.tables = function(config, defs)
--   if not defs then
--     M._log:error "cannot register key tables: no definitions provided"
--     return
--   end
--
--   M._defs = defs
--
--   -- A deeply-indexable nil-safe proxy for calling function-form definitions
--   -- without a real theme.  Any field access returns the proxy itself, so
--   -- expressions like `theme.brights[3]` never raise an error.
--   local proxy
--   proxy = setmetatable({}, {
--     __index = function()
--       return proxy
--     end,
--   })
--
--   config.key_tables = config.key_tables or {}
--
--   for name, def in pairs(defs) do
--     local resolved = resolve_def(name, def, proxy)
--
--     if resolved then
--       resolved.meta.name = name
--       if resolved.keys then
--         config.key_tables[name] = M.table(resolved.keys)
--       else
--         M._log:error("key table '%s' is missing a 'keys' field", name)
--       end
--     end
--   end
-- end
--
-- ---Resolve and return display metadata for all registered key tables.
-- ---
-- ---@param theme table Resolved WezTerm colour scheme.
-- ---@return table<string, Keymapper.Meta> modes Display metadata per key table.
-- M.get_modes = function(theme)
--   local modes = {}
--
--   for name, def in pairs(M._defs or {}) do
--     local resolved = resolve_def(name, def, theme)
--
--     if resolved then
--       if resolved.meta then
--         modes[name] = resolved.meta
--       else
--         M._log:warn("key table '%s' has no 'meta' field; skipped in get_modes()", name)
--       end
--     end
--   end
--
--   return modes
-- end
--
-- -- ──────────────────────────────────────────────────────────────────────────────
-- -- Public – status-bar hint string (with pagination)
-- -- ──────────────────────────────────────────────────────────────────────────────
--
-- --- Lazily build and cache the reverse alias lookup (WezTerm key → vim key).
-- ---@return table<string, string>
-- local function get_rev_aliases()
--   if not M._rev_aliases then
--     local rev = {}
--     for vim_key, wez_key in pairs(M.aliases) do
--       rev[wez_key] = vim_key
--     end
--     M._rev_aliases = rev
--   end
--   return M._rev_aliases
-- end
--
-- --- Split a raw mods string (e.g. `"LEADER|CTRL"`) into a leader flag and an
-- --- ordered array of single-character modifier abbreviations.
-- ---@param  mods_str string   value of `entry.mods`, may be empty
-- ---@return boolean  has_leader
-- ---@return string[] mod_parts  e.g. `{ "C", "S" }`
-- local function parse_mods(mods_str)
--   local rev_mods = { CTRL = "C", SHIFT = "S", ALT = "A", SUPER = "W" }
--   local has_leader = false
--   local parts = {}
--   for mod in mods_str:gmatch "[^|]+" do
--     if mod == "LEADER" then
--       has_leader = true
--     else
--       parts[#parts + 1] = rev_mods[mod] or mod
--     end
--   end
--   return has_leader, parts
-- end
--
-- --- Format the final vim-style lhs string from its components.
-- ---@param  display_key string
-- ---@param  mod_parts   string[]
-- ---@param  has_leader  boolean
-- ---@return string
-- local function format_lhs(display_key, mod_parts, has_leader)
--   local lhs
--   if #mod_parts > 0 then
--     lhs = "<" .. tconcat(mod_parts, "-") .. "-" .. display_key .. ">"
--   elseif #display_key > 1 then
--     lhs = "<" .. display_key .. ">"
--   else
--     lhs = display_key
--   end
--   if has_leader then
--     lhs = "<leader>" .. lhs
--   end
--   return lhs
-- end
--
-- ---Reverse-map stored WezTerm key entry back to compact vim-style label.
-- ---
-- ---@package
-- ---@param entry table WezTerm-format key entry.
-- ---@return string lhs Compact string representation.
-- M.__entry_lhs = function(entry)
--   local display_key = get_rev_aliases()[entry.key] or entry.key
--   local has_leader, mod_parts = parse_mods(entry.mods or "")
--   return format_lhs(display_key, mod_parts, has_leader)
-- end
--
-- ---Return global key used to persist page index for hints.
-- ---
-- ---@package
-- ---@param window_id number Window ID.
-- ---@param pane_id number Pane ID.
-- ---@param name string? Key-table name.
-- ---@return string var_key Global variable key.
-- M.__hint_var = function(window_id, pane_id, name)
--   return "hint_page_w" .. window_id .. "_p" .. pane_id .. "_" .. (name or "__keys__")
-- end
--
-- --- Collect all entries that carry a `desc` field into pre-rendered strings.
-- ---@param  entries table[]
-- ---@return string[]
-- local function collect_hint_items(entries)
--   local items = {}
--   for _, entry in ipairs(entries) do
--     if entry.desc then
--       items[#items + 1] = M.__entry_lhs(entry) .. " " .. entry.desc
--     end
--   end
--   return items
-- end
--
-- --- Append `item` to `page_items`, accounting for the separator width.
-- --- Returns the updated `used` column count.
-- ---@param  page_items string[]
-- ---@param  used       number
-- ---@param  item       string
-- ---@param  iw         number   pre-measured item width
-- ---@param  sep_w      number
-- ---@return number updated_used
-- local function page_append(page_items, used, item, iw, sep_w)
--   if #page_items > 0 then
--     used = used + sep_w
--   end
--   page_items[#page_items + 1] = item
--   return used + iw
-- end
--
-- ---Pack described entries into pages fitting within width budget.
-- ---
-- ---@package
-- ---@param entries table[] Array of key entries.
-- ---@param budget number Maximum column width.
-- ---@return table pages Array of pages containing pre-rendered strings.
-- M.__hint_pages = function(entries, budget)
--   local wt = require "wezterm"
--   local sep_w = str.column_width " / "
--
--   local items = collect_hint_items(entries)
--   if #items == 0 then
--     return {}
--   end
--
--   local pages = {}
--   local page_items = {}
--   local used = 0
--
--   for _, item in ipairs(items) do
--     local iw = str.column_width(item)
--     if #page_items > 0 and used + sep_w + iw > budget then
--       pages[#pages + 1] = page_items
--       page_items, used = { item }, iw
--     else
--       used = page_append(page_items, used, item, iw, sep_w)
--     end
--   end
--
--   if #page_items > 0 then
--     pages[#pages + 1] = page_items
--   end
--   return pages
-- end
--
-- ---Render single page padded or truncated to exact width.
-- ---
-- ---@package
-- ---@param page_items string[] Items on the page.
-- ---@param indicator string Pagination indicator string.
-- ---@param width number Target column width.
-- ---@return string rendered Rendered hint string.
-- M.__hint_render = function(page_items, indicator, width)
--   local wt = require "wezterm"
--   local body = tconcat(page_items, " / ")
--
--   local body_w = str.column_width(body)
--   local body_budget = width - str.column_width(indicator)
--
--   if body_w < body_budget then
--     body = body .. string.rep(" ", body_budget - body_w)
--   elseif body_w > body_budget then
--     local cut = body
--     while str.column_width(cut) > body_budget and #cut > 0 do
--       cut = cut:sub(1, -2)
--     end
--     body = cut
--   end
--
--   return body .. indicator
-- end
--
-- ---Build fixed-width, paginated hint string from named key table.
-- ---
-- ---@param config table WezTerm config object.
-- ---@param name string|nil Key table name.
-- ---@param width number Maximum column width.
-- ---@param window table WezTerm window object.
-- ---@return string hint Rendered hint string.
-- M.hint = function(config, name, width, window)
--   local wt = require "wezterm"
--
--   local entries
--   if name then
--     entries = config.key_tables and config.key_tables[name]
--     if not entries then
--       M._log:warn("hint: key table '%s' not found", name)
--       entries = {}
--     end
--   else
--     entries = config.keys or {}
--   end
--
--   local probe_pages = M.__hint_pages(entries, width)
--   local total = #probe_pages
--
--   if total == 0 then
--     return string.rep(" ", width)
--   end
--   if total == 1 then
--     return M.__hint_render(probe_pages[1], "", width)
--   end
--
--   local max_indicator = sformat(" [%d/%d]", total, total)
--   local ind_w = str.column_width(max_indicator)
--
--   local pages = M.__hint_pages(entries, width - ind_w)
--   total = #pages
--
--   local var_key = M.__hint_var(window:window_id(), window:active_pane():pane_id(), name)
--   local stored = wt.GLOBAL.__cache[var_key]
--   local page = (type(stored) == "number") and stored or 1
--
--   page = math.max(1, math.min(page, total))
--   wt.GLOBAL.__cache[var_key] = page
--
--   local indicator = sformat(" [%d/%d]", page, total)
--   local pad_needed = ind_w - str.column_width(indicator)
--   if pad_needed > 0 then
--     indicator = indicator .. string.rep(" ", pad_needed)
--   end
--
--   return M.__hint_render(pages[page], indicator, width)
-- end
--
-- ---Create callback action to advance or retreat hint page.
-- ---
-- ---@param name string|nil Key table name.
-- ---@param direction number Direction step (1 for forward, -1 for backward).
-- ---@return table action WezTerm action callback.
-- M.hint_action = function(name, direction)
--   local wt = require "wezterm"
--
--   return wt.action_callback(function(window, pane)
--     local var_key = M.__hint_var(window:window_id(), pane:pane_id(), name)
--     local current = wt.GLOBAL[var_key]
--     local page = (type(current) == "number") and current or 1
--
--     page = math.max(1, page + direction)
--
--     wt.GLOBAL[var_key] = page
--     window:set_right_status ""
--   end)
-- end
--
-- return M

---@module 'utils.keymapper'

local str = require "utils.fn.str" ---@class Fn.String

local sgsub, ssub, smatch, sformat = string.gsub, string.sub, string.match, string.format
local tconcat = table.concat

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

-- ──────────────────────────────────────────────────────────────────────────────
-- Internal helpers
-- ──────────────────────────────────────────────────────────────────────────────

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

-- ──────────────────────────────────────────────────────────────────────────────
-- Public – validation and mapping
-- ──────────────────────────────────────────────────────────────────────────────

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

  local k = keys[#keys]
  if modifiers[k] then
    return M._log:error "keymap cannot end with modifier!"
  else
    keys[#keys] = nil
  end
  k = aliases[k] or k

  for i = 1, #keys do
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

-- ──────────────────────────────────────────────────────────────────────────────
-- Internal – definition resolution
-- ──────────────────────────────────────────────────────────────────────────────

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

-- ──────────────────────────────────────────────────────────────────────────────
-- Public – top-level config helpers
-- ──────────────────────────────────────────────────────────────────────────────

M.maps = function(config, mappings)
  config.keys = config.keys or {}
  M.map_batch(mappings, config.keys)
end

M.tables = function(config, defs)
  if not defs then
    M._log:error "cannot register key tables: no definitions provided"
    return
  end

  M._defs = defs

  -- Nil-safe proxy: any field access returns the proxy itself so expressions
  -- like `theme.brights[3]` in a function-form definition never error when
  -- called without a real theme (we only need the `keys` arrays here).
  local proxy
  proxy = setmetatable({}, {
    __index = function()
      return proxy
    end,
  })

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

M.get_modes = function(theme)
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
  return modes
end

-- ──────────────────────────────────────────────────────────────────────────────
-- Internal – lhs reverse-translation helpers
-- ──────────────────────────────────────────────────────────────────────────────

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

-- ──────────────────────────────────────────────────────────────────────────────
-- Internal – pagination helpers
-- ──────────────────────────────────────────────────────────────────────────────

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
  local wt = require "wezterm"
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
  local wt = require "wezterm"
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
  if not name then
    return config.keys or {}
  end
  local entries = config.key_tables and config.key_tables[name]
  if not entries then
    M._log:warn("hint: key table '%s' not found", name)
    return {}
  end
  return entries
end

-- ──────────────────────────────────────────────────────────────────────────────
-- Public – hint string (plain)
-- ──────────────────────────────────────────────────────────────────────────────

---Build a fixed-width paginated hint string (plain text, no colour).
---Prefer `hint_layout()` for status-bar use where colour is available.
---
---@param config  table       WezTerm config
---@param name    string|nil  key-table name, nil for `config.keys`
---@param width   number      desired output width in columns
---@param window  table       WezTerm window object
---@return string             exactly `width` columns
M.hint = function(config, name, width, window)
  local wt = require "wezterm"
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
    body = body .. string.rep(" ", budget - bw)
  end
  return body .. indicator
end

-- ──────────────────────────────────────────────────────────────────────────────
-- Public – hint layout (coloured wezterm format items)
-- ──────────────────────────────────────────────────────────────────────────────

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
---  return keymapper.hint_layout(config, active_mode, tab_bar.right_available(), window, {
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
  local wt = require "wezterm"
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

  -- ── Iterate items ────────────────────────────────────────────────────────
  local sep_str = " / "
  local sep_w = str.column_width(sep_str)
  local budget = width - ind_w
  local used = 0

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

  for i, item in ipairs(items) do
    local item_w = str.column_width(item.lhs) + 1 + str.column_width(item.desc)
    local need = item_w + (i > 1 and sep_w or 0)
    if used + need > budget then
      break
    end

    -- ── Separator ──────────────────────────────────────────────────────
    if i > 1 then
      layout:append(bg, dim_fg, sep_str, "Normal")
      used = used + sep_w
    end

    -- ── Key ────────────────────────────────────────────────────────────
    append_lhs(item.lhs)
    used = used + str.column_width(item.lhs)

    -- ── Description ────────────────────────────────────────────────────
    layout:append(bg, fg, " " .. item.desc, "Italic")
    used = used + 1 + str.column_width(item.desc)
  end

  -- ── Trailing padding ─────────────────────────────────────────────────
  if used < budget then
    layout:append(bg, fg, string.rep(" ", budget - used))
  end

  -- ── Pagination indicator ──────────────────────────────────────────────
  if indicator ~= "" then
    layout:append(bg, fg, indicator, "Normal")
  end

  return layout
end

-- ──────────────────────────────────────────────────────────────────────────────
-- Public – hint scroll action
-- ──────────────────────────────────────────────────────────────────────────────

---Return a `wezterm.action_callback` that advances or retreats the hint page.
---
---@param name      string|nil  key-table name, nil for `config.keys`
---@param direction number      `1` = forward, `-1` = backward
---@return table                `wezterm.action_callback`
M.hint_action = function(name, direction)
  local wt = require "wezterm"

  return wt.action_callback(function(window, pane)
    local cache = require "utils.fn.cache"
    local var_key = M.__hint_var(window:window_id(), pane:pane_id(), name)
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

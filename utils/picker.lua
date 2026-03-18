---@module 'utils.picker'

-- selene: allow(incorrect_standard_library_use)
local tunpack = unpack or table.unpack

local Logger = require "utils.logger" ---@class Logger
local cache = require "utils.fn.cache" ---@class Fn.Cache
local fs = require "utils.fn.fs" ---@class Fn.FileSystem
local tbl = require "utils.fn.tbl" ---@class Fn.Table
local Opts = require("opts").utils.picker ---@class Opts.Utils.Picker

local wt = require "wezterm" ---@class Wezterm

local ioopen = io.open

--~ {{{1 Persistence internals

local _persist_log = Logger.new "Picker.Persist"
local _has_serde = wt.serde ~= nil
local _has_bg_task = type(wt.background_task) == "function"
if not _has_serde then
  _persist_log:warn "wezterm.serde not available, picker persistence disabled"
end
local _store = cache.ensure_global_tbl("__picker_store", { loaded = false, data = {} })

---Resolve the JSON file path for picker state.
---@return string path Absolute path to the persistence file.
local function _resolve_path()
  return Opts.persistence.path or fs.join_path(wt.config_dir, "picker-state.json")
end

---Load picker state from JSON file into the global store.
---
---Reads from disk only once per WezTerm process. Subsequent config reloads
---reuse the `wt.GLOBAL` cache.
local function _load_store()
  if _store.loaded then
    return
  end

  _store.loaded = true

  if not _has_serde then
    return
  end

  local path = _resolve_path()
  local fh, open_err = ioopen(path, "r")
  if not fh then
    if open_err and not open_err:find "No such file" then
      _persist_log:warn("unable to read %s: %s", path, open_err)
    end
    return
  end

  local content = fh:read "*a"
  fh:close()

  if not content or content == "" then
    return
  end

  local ok, decoded = pcall(wt.serde.json_decode, content)
  if not ok then
    _persist_log:warn("invalid JSON in %s: %s", path, decoded)
    return
  end

  if type(decoded) == "table" then
    cache.clear_global(_store.data)
    cache.sync_to_global(_store.data, decoded)
  end
end

---Synchronous file write (fallback when `background_task` is unavailable).
---@param path string     Absolute path to the JSON file.
---@param encoded string  JSON-encoded string to write.
local function _write_file(path, encoded)
  local fh, open_err = ioopen(path, "w")
  if not fh then
    _persist_log:warn("unable to write %s: %s", path, open_err)
    return
  end
  fh:write(encoded)
  fh:close()
end

---Write the current store to disk as JSON.
---
---Uses `wezterm.background_task()` when available so the file I/O does not
---block the UI callback.  Falls back to a synchronous write otherwise.
local function _write_store()
  if not _has_serde then
    return
  end

  local path = _resolve_path()
  local encoded = wt.serde.json_encode(_store.data)

  if _has_bg_task then
    wt.background_task(function()
      _write_file(path, encoded)
    end)
  else
    _write_file(path, encoded)
  end
end

--~ }}}

---Convert filepath to Lua require path.
---
---@param path string File system path.
---@return string require_path Lua module path.
local function path_to_module(path)
  return (path:sub(#wt.config_dir + 2):gsub("%.lua$", ""):gsub(fs.path_separator, "."))
end

---Normalize item to the `choices` format.
---
---@param item string|number|table Item to normalize.
---@return table normalized_item Normalized choice table with `id` field.
local function normalize(item)
  return type(item) == "table" and item or { id = item }
end

---Determine whether the item is an array.
---
---@param item Picker.Choice[]|Picker.Choice Item to check.
---@return boolean result Item is an array (has numerical index 1).
local function is_array(item)
  return type(item) == "table" and item[1] ~= nil
end

---@class Picker
local M = {}

-- ── Persistence API ───────────────────────────────────────────────────────────

---Save a picker selection to the persistence store.
---
---@param picker_name string  Picker name (e.g. `"colorschemes"`).
---@param entry table         `{ id = string, module = string }` — choice id and require path.
function M.store_save(picker_name, entry)
  _load_store()
  _store.data[picker_name] = _store.data[picker_name] or {}
  cache.clear_global(_store.data[picker_name])
  cache.sync_to_global(_store.data[picker_name], entry)
  _write_store()
end

---Retrieve the persisted entry for a picker.
---
---@param picker_name string Picker name.
---@return table|nil entry   `{ id, module }` or nil.
function M.store_get(picker_name)
  _load_store()
  return _store.data[picker_name]
end

---Clear persisted entry for one picker, or all pickers.
---
---@param picker_name? string Picker name. If nil, clears everything.
function M.store_clear(picker_name)
  _load_store()
  if picker_name then
    _store.data[picker_name] = nil
  else
    cache.clear_global(_store.data)
  end
  _write_store()
end

---Restore persisted picker selections into a config table.
---
---Intended for use with `Config:add()` at startup.  For each persisted entry,
---loads the module and calls its `pick()` to build the config fragment.
---
---@return table config Config table with restored picker selections.
function M.restore()
  if not Opts.persistence.enabled or not _has_serde then
    return {}
  end

  _load_store()

  local restored = {}

  for picker_name, entry in pairs(_store.data) do
    if entry.module and entry.id then
      local ok, mod = pcall(require, entry.module)
      if ok and mod and mod.pick then
        _persist_log:info("restoring %s = %s", picker_name, entry.id)
        mod.pick(restored, { choice = { id = entry.id } })
      else
        _persist_log:warn(
          "skipping %s: module '%s' unavailable",
          picker_name,
          entry.module
        )
      end
    end
  end

  return restored
end

---Create new picker instance.
---
---Initializes the picker with configuration. Choice modules are loaded lazily
---when `:pick()` is called.
---
---@param opts Picker.Config Picker configuration.
---@return Picker picker Newly created picker instance.
function M.new(opts)
  local self = setmetatable({}, { __index = M })
  local pick_opt = function(value, default)
    return value ~= nil and value or default
  end

  self.title = opts.title or Opts.defaults.title
  self._name = opts.name
  self._choices = {}
  self._initialized = false
  self._dir = nil
  self._event_registered = false
  self._log = Logger.new("Picker > " .. self.title, Opts.log.enabled)
  self._build_choices = function(internal_choices, comp, ctx)
    local choices = self.format_choices(internal_choices, ctx)
    table.sort(choices, comp)
    return choices
  end

  self.choices = {}
  self.sort_by = opts.sort_by or Opts.defaults.sort_by
  self.fuzzy = pick_opt(opts.fuzzy, Opts.defaults.fuzzy)
  self.alphabet = pick_opt(opts.alphabet, Opts.defaults.alphabet)
  self.description = pick_opt(opts.description, Opts.defaults.description)
  self.fuzzy_description =
    pick_opt(opts.fuzzy_description, Opts.defaults.fuzzy_description)

  self.persist = pick_opt(opts.persist, Opts.persistence.enabled)

  self.comp = opts.comp or Opts.defaults.comp(self.sort_by)
  self.format_choices = opts.format_choices or Opts.defaults.format_choices
  self.format_description = opts.format_description or Opts.defaults.format_description

  -- Store directory path for lazy loading
  local assets_path = fs.join_path(wt.config_dir, tunpack(Opts.assets_path_segments))
  self._dir = fs.join_path(assets_path, opts.name)

  return self
end

---Initialize picker by loading all choice modules.
---
---Only runs once, then sets `_initialized` flag.
function M:_initialize()
  if self._initialized then
    return
  end

  self._log:info "initializing..."
  local paths = wt.read_dir(self._dir)
  ---@cast paths -string, +string[]
  if not paths or tbl.is_empty(paths) then
    self._log:error("Unable to read list files in %s. Is the path correct?", self._dir)
    self._initialized = true
    return
  end

  for _, path in pairs(paths) do
    self:register(path_to_module(path))
  end

  self._initialized = true
end

---Register module by requiring it and filling the `_choices` table.
---
---@param name string Lua require path to the module.
function M:register(name)
  ---@class Picker.Module
  local module = require(name)
  local result = module.get()

  if is_array(result) then
    for i = 1, #result do
      local item = normalize(result[i])
      self._choices[item.id] = {
        module = module,
        module_path = name,
        choice = { id = item.id, label = item.label },
      }
      self._log:debug("registered item: %s", self._choices[item.id])
    end
  else
    result = normalize(result)
    self._choices[result.id] = {
      module = module,
      module_path = name,
      choice = { id = result.id, label = result.label },
    }
    self._log:debug("registered item: %s", self._choices[result.id])
  end
end

---Activate the selected module's `pick` function.
---
---@param Overrides Config Configuration overrides table to modify.
---@param opts Picker.CallbackOpts Options including selected choice ID and context.
function M:select(Overrides, opts)
  local choice = self._choices[opts.choice.id]
  if not choice then
    return self._log:error("%s is not defined for %s", opts.choice.id, self.title)
  end

  choice.module.pick(Overrides, opts)

  if self.persist then
    local id_lower = opts.choice.id:lower()
    local label_lower = (opts.choice.label or ""):lower()
    local is_reset = id_lower == "reset" or label_lower == "reset"

    if is_reset and Opts.persistence.reset_behavior == "clear" then
      M.store_clear(self._name)
    else
      M.store_save(self._name, { id = opts.choice.id, module = choice.module_path })
    end
  end
end

---Invoke the picker UI action.
---
---Registers a named event handler for this picker and returns a stable
---`EmitEvent` action.  Using `EmitEvent` instead of a raw `action_callback`
---ensures the action survives config-override cycles and can be stored
---reliably inside key tables.
---
---Lazily initializes choices on the first invocation of the event handler.
function M:pick()
  local event_name = "picker:" .. self._name

  if not self._event_registered then
    wt.on(event_name, function(window, pane)
      -- Lazy initialization: register all choices when picker is first used
      self:_initialize()

      local ctx = { window = window, pane = pane } ---@type Picker.BuildContext
      window:perform_action(
        wt.action.InputSelector {
          action = wt.action_callback(function(inner_window, _, id, label)
            if not id and not label then
              self._log:error "cancelled by user"
            else
              ---@type Picker.CallbackOpts
              local callback_opts =
                { window = window, pane = pane, choice = { id = id, label = label } }
              self._log:info("applying %s", id)

              local Overrides = inner_window:get_config_overrides() or {}
              self:select(Overrides, callback_opts)
              window:set_config_overrides(Overrides)
            end
          end),
          title = self.title,
          choices = self._build_choices(self._choices, self.comp, ctx),
          fuzzy = self.fuzzy,
          description = self.format_description(
            self.description,
            self.fuzzy,
            Opts.defaults.icons
          ),
          fuzzy_description = self.format_description(
            self.fuzzy_description,
            self.fuzzy,
            Opts.defaults.icons
          ),
          alphabet = self.alphabet,
        },
        pane
      )
    end)
    self._event_registered = true
  end

  return wt.action.EmitEvent(event_name)
end

return M

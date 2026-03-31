---@module 'utils.picker'

-- selene: allow(incorrect_standard_library_use)
local tunpack = unpack or table.unpack

local Logger = require "plugs.log" ---@class Logger
local Opts = require("opts").utils.picker ---@class Opts.Utils.Picker

local warp = require "plugs.warp" ---@class Warp.Api
local wt = require "wezterm" ---@class Wezterm
local fs = warp.filesystem ---@class Warp.FileSystem
local path = warp.path ---@class Warp.Path
local tbl = warp.table ---@class Warp.Table
local memo = require "plugs.memo" ---@class memo.API

--~ {{{1 Persistence internals

local _persist_log = Logger.new "Picker.Persist"
local _has_serde = wt.serde ~= nil
local _has_bg_task = type(wt.background_task) == "function"
if not _has_serde then
  _persist_log:warn "wezterm.serde not available, picker persistence disabled"
end

---Resolve the default persistence path outside `config_dir` so that writes
---do not trigger a WezTerm configuration reload.
---  Windows:     %LOCALAPPDATA%\wezterm\picker-state.json
---  Linux/macOS: $XDG_STATE_HOME/wezterm/picker-state.json  (~/.local/state/wezterm/)
---@return string
local function _default_state_path()
  local ogetenv = os.getenv
  local dir
  if fs.is_win then
    dir = ogetenv "LOCALAPPDATA" or ogetenv "APPDATA"
    if dir then
      dir = path.concat(dir, "wezterm")
    end
  else
    local xdg = ogetenv "XDG_STATE_HOME"
    if xdg then
      dir = path.concat(xdg, "wezterm")
    else
      local home = ogetenv "HOME"
      if home then
        dir = path.concat(home, ".local", "state", "wezterm")
      end
    end
  end
  dir = dir or wt.config_dir
  return path.concat(dir, "picker-state.json")
end

---@type memo.state.Store
local _store = memo.state.new {
  path = Opts.persistence.path or _default_state_path(),
  auto_load = true,
  auto_save = true,
  async = _has_bg_task,
}

--~ }}}

---Convert filepath to Lua require path.
---
---@param path string File system path.
---@return string require_path Lua module path.
local function path_to_module(path)
  return (path:sub(#wt.config_dir + 2):gsub("%.lua$", ""):gsub(path.separator, "."))
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
  _store:set(picker_name, entry)
end

---Retrieve the persisted entry for a picker.
---
---@param picker_name string Picker name.
---@return table|nil entry   `{ id, module }` or nil.
function M.store_get(picker_name)
  return _store:get(picker_name)
end

---Clear persisted entry for one picker, or all pickers.
---
---@param picker_name? string Picker name. If nil, clears everything.
function M.store_clear(picker_name)
  if picker_name then
    _store:delete(picker_name)
  else
    _store:clear()
  end
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

  local restored = {}

  for picker_name, entry in pairs(_store:restore()) do
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
  local assets_path = path.concat(wt.config_dir, tunpack(Opts.assets_path_segments))
  self._dir = path.concat(assets_path, opts.name)

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
  if not paths or tbl.isempty(paths) then
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

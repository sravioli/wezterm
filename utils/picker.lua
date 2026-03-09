---@module 'utils.picker'

-- selene: allow(incorrect_standard_library_use)
local tunpack = unpack or table.unpack

local Logger = require "utils.logger" ---@class Logger
local fs = require "utils.fn.fs" ---@class Fn.FileSystem
local tbl = require "utils.fn.tbl" ---@class Fn.Table
local Opts = require("opts").utils.picker ---@class Opts.Utils.Picker

local wt = require "wezterm" ---@class Wezterm

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

---Create new picker instance.
---
---Initializes the picker with configuration. Choice modules are loaded lazily
---when `:pick()` is called.
---
---@param opts Picker.Config Picker configuration.
---@return Picker picker Newly created picker instance.
function M.new(opts)
  local self = setmetatable({}, { __index = M })
  self.title = opts.title or Opts.defaults.title
  self._choices = {}
  self._initialized = false
  self._dir = nil
  self._log = Logger:new("Picker > " .. self.title, Opts.log.enabled, Opts.log.sinks)
  self._build_choices = function(internal_choices, comp, ctx)
    local choices = self.format_choices(internal_choices, ctx)
    table.sort(choices, comp)
    return choices
  end

  self.choices = {}
  self.sort_by = opts.sort_by or Opts.defaults.sort_by
  self.fuzzy = opts.fuzzy or Opts.defaults.fuzzy
  self.alphabet = opts.alphabet or Opts.defaults.alphabet
  self.description = opts.description or Opts.defaults.description
  self.fuzzy_description = opts.fuzzy_description or Opts.defaults.fuzzy_description

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
      self._choices[item.id] =
        { module = module, choice = { id = item.id, label = item.label } }
      self._log:debug("registered item: %s", self._choices[item.id])
    end
  else
    result = normalize(result)
    self._choices[result.id] =
      { module = module, choice = { id = result.id, label = result.label } }
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
end

---Invoke the picker UI action.
---
---Present choices to the user using `wezterm.InputSelector` and execute selected action.
---Lazily initializes choices on first call.
function M:pick()
  return wt.action_callback(function(window, pane)
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
end

return M

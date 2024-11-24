---@module "utils.class.picker"
---@author sravioli
---@license GNU-GPLv3

---@diagnostic disable: undefined-field

local Utils = require "utils"
local fs, Logger = Utils.fn.fs, Utils.class.logger

local wt = require "wezterm"
local config_dir = wt.config_dir

-- {{{1 Meta

--~ {{{2 wt.Window

---@class wt.Window
---@field active_key_table               function
---@field active_pane                    function
---@field active_tab                     function
---@field active_workspace               function
---@field composition_status             function
---@field copy_to_clipboard              function
---@field current_event                  function
---@field effective_config               function
---@field focus                          function
---@field get_appearance                 function
---@field get_config_overrides           function
---@field get_dimensions                 function
---@field get_selection_escapes_for_pane function
---@field get_selection_text_for_pane    function
---@field is_focused                     function
---@field keyboard_modifiers             function
---@field leader_is_active               function
---@field maximize                       function
---@field mux_window                     function
---@field perform_action                 function
---@field restore                        function
---@field set_config_overrides           function
---@field set_inner_size                 function
---@field set_left_status                function
---@field set_position                   function
---@field set_right_status               function
---@field toast_notification             function
---@field toggle_fullscreen              function
---@field window_id                      function

--~ }}}

--~ {{{2 wt.Pane

---@class wt.Pane
---@field activate                    function
---@field get_current_working_dir     function
---@field get_cursor_position         function
---@field get_dimensions              function
---@field get_domain_name             function
---@field get_foreground_process_info function
---@field get_foreground_process_name function
---@field get_lines_as_escapes        function
---@field get_lines_as_text           function
---@field get_logical_lines_as_text   function
---@field get_metadata                function
---@field get_semantic_zone_at        function
---@field get_semantic_zones          function
---@field get_text_from_region        function
---@field get_text_from_semantic_zone function
---@field get_title                   function
---@field get_tty_name                function
---@field get_user_vars               function
---@field has_unseen_output           function
---@field inject_output               function
---@field is_alt_screen_active        function
---@field move_to_new_tab             function
---@field move_to_new_window          function
---@field mux_pane                    function
---@field pane_id                     function
---@field paste                       function
---@field send_paste                  function
---@field send_text                   function
---@field split                       function
---@field tab                         function
---@field window                      function

--~ }}}

--~ {{{2 Utils.Class.Picker

---@alias Module PickList
---@alias Choice { id: string, label: string|table }
---@alias Choice.private { module: Module, value: Choice }

---@class Utils.Class.Picker
---@field subdir             string  name of the picker module
---@field title              string  defaults to `"Pick a value"`
---@field choices?           Choice[] defaults to `{}`
---@field __choices?         Choice.private[] defaults to `{}`
---@field fuzzy?             boolean defaults to `false`
---@field alphabet?          string  defaults to `"1234567890abcdefghilmnopqrstuvwxyz"`
---@field description?       string  defaults to `"Select an item."`
---@field fuzzy_description? string  defaults to `"Fuzzy matching: "`
---@field comp?              fun(a, b): boolean function to sort choices
---@field build?             fun(__choices: Choice.private[], comp: function, opts: { window: wt.Window, pane: wt.Pane }): Choice[]
---@field new?               fun(opts: Utils.Class.Picker): Utils.Class.Picker
---@field private log?       Utils.Class.Logger

--~ }}}

--~ {{{2 PickList.Opts

---@alias PickList.Opts { window: wt.Window, pane: wt.Pane, id: string|nil, label: string|nil }
---@alias PickList.getReturn string|{ id: string|nil, label: string|table|nil }

---@class PickList
---@field get      fun(): PickList.getReturn
---@field activate fun(Config: table, opts: PickList.Opts): nil

--~ }}}

-- }}}

-- {{{1 Helper functions

local h = {}

---Normalize an item to the `choices` format
---@param item string|number
---@return table normalized_item
function h.normalize(item)
  return type(item) == "table" and item or { id = item }
end

---Determines whether the given item is an array or not.
---@param item PickList.getReturn
---@return boolean result whether or not the item is an array
function h.is_array(item)
  return type(item) == "table" and item[1] ~= nil
end

---Build the choices table
---@param items table
---@param comp? fun(a, b): boolean
---@return Choice[] choices
function h.build(items, comp)
  local choices = {}
  for _, item in pairs(items) do
    choices[#choices + 1] = { id = item.value.id, label = item.value.label }
  end

  table.sort(choices, comp or function(a, b)
    return a.id < b.id
  end)

  return choices
end

---Converts a file path to a lua require path
---@param path string
---@return string require_path
function h.path_to_module(path)
  return (path:sub(#config_dir + 2):gsub("%.lua$", ""):gsub(fs.path_separator, "."))
end

-- }}}

---@class Utils.Class.Picker
local M = {}

---Creates a new picker object
---@param opts Utils.Class.Picker
---@return Utils.Class.Picker Picker
function M.new(opts)
  local self = setmetatable({}, { __index = M })
  self.title = opts.title or "Pick a value"
  self.choices = {}
  self.__choices = {}
  self.log = Logger:new("Picker > " .. self.title)

  self.comp = opts.comp
  self.build = opts.build or h.build

  self.fuzzy = opts.fuzzy or false
  self.alphabet = opts.alphabet or "1234567890abcdefghilmnopqrstuvwxyz"
  self.description = opts.description or "Select an item."
  self.fuzzy_description = opts.fuzzy_description or "Fuzzy matching: "

  local dir = fs.pathconcat(config_dir, "picker", "assets", opts.subdir)
  local paths = fs.ls_dir(dir)
  if not paths then
    self.log:error("Cannot read files from %s", dir)
    return {}
  end
  for i = 1, #paths do
    self:register(h.path_to_module(paths[i]))
  end

  return self
end

---Registers the module by requiring it and filling the `__choices` table
---@param name string the lua require path to the module
function M:register(name)
  ---@class PickList
  local module = require(name)
  local result = module.get()

  if h.is_array(result) then
    for i = 1, #result do
      local item = h.normalize(result[i])
      self.__choices[item.id] =
        { module = module, value = { id = item.id, label = item.label } }
      self.log:debug("registered item: %s", self.__choices[item.id])
    end
  else
    ---@cast result string
    result = h.normalize(result)
    self.__choices[result.id] =
      { module = module, value = { id = result.id, label = result.label } }
    self.log:debug("registered item: %s", self.__choices[result.id])
  end
end

---Activates the selected module
---@param Overrides table config overrides
---@param opts PickList.Opts
---@return nil
function M:select(Overrides, opts)
  local choice = self.__choices[opts.id]
  if not choice then
    return self.log:error("%s is not defined for %s", opts.id, self.title)
  end

  choice.module.activate(Overrides, opts)
end

---Invoke the picker.
---@return nil
function M:pick()
  return wt.action_callback(function(window, pane)
    local opts = { window = window, pane = pane }
    window:perform_action(
      wt.action.InputSelector {
        action = wt.action_callback(function(inner_window, _, id, label)
          if not id and not label then
            self.log:error "cancelled by user"
          else
            local callback_opts = { window = window, pane = pane, id = id, label = label }
            self.log:info("applying %s", id)
            local Overrides = inner_window:get_config_overrides() or {}
            self:select(Overrides, callback_opts)
            window:set_config_overrides(Overrides)
          end
        end),
        title = self.title,
        choices = self.build(self.__choices, self.comp, opts),
        fuzzy = self.fuzzy,
        description = self.description,
        fuzzy_description = self.fuzzy_description,
        alphabet = self.alphabet,
      },
      pane
    )
  end)
end

return M

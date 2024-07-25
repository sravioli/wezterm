---@module "picker.generic"
---@author sravioli
---@license GNU-GPLv3

local wt = require "wezterm"

---@class InputSelector
---@field title              string
---@field choices            table
---@field action             fun(window, pane, id: any|nil, label: any|nil):any
---@field fuzzy?             boolean
---@field alphabet?          string
---@field description?       string
---@field fuzzy_description? string
local M = {}

function M:init()
  local Picker = {}

  setmetatable(Picker, { __index = self })
  return self
end

function M:pick()
  ---@diagnostic disable-next-line: undefined-field
  return wt.action.InputSelector {
    title = self.title,
    choices = self.choices,
    ---@diagnostic disable-next-line: undefined-field
    action = wt.action_callback(self.action),
    fuzzy = self.fuzzy or false,
    alphabet = self.alphabet or "1234567890abcdefghilmnopqrstuvwxyz",
    description = self.description
      or "Select an item and press Enter = accept, Esc = cancel, / = filter",
  }
end

--[[=[
---@module "utils.class.picker"
---@author sravioli
---@license GNU-GPLv3

local H = {}

local Utils = require "utils"

local wt = require "wezterm"
local log_info, log_error = wt.log_info, wt.log_error

-- {{{1 Meta

---@alias Picker Utils.Class.Picker
---@alias Picker.List Utils.Class.Picker.List

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

--~ {{{2 Utils.Class.Picker.List

---@class Utils.Class.Picker.List
---@field get fun(): string|table
---@field activate fun(Overrides: table, callback_opts: { window: wt.Window, pane: wt.Pane, id: string|nil, label: string|nil }): nil

--~ }}}

--~ }}}

---@class Utils.Class.Picker
---@field title              string defaults to `"Pick a value"`
---@field choices            table defaults to `{}`
---@field private __choices          table defaults to `{}`
---@field action             fun(window: wt.Window, pane: wt.Pane, id: string|nil, label: table|string|nil)
---@field fuzzy?             boolean defaults to `false`
---@field alphabet?          string defaults to `"1234567890abcdefghilmnopqrstuvwxyz"`
---@field description?       string defaults to `"Select an item."`
---@field fuzzy_description? string defaults to `"Fuzzy matching: "`
local M = {}

---Initializes a new Picker
---@param opts Picker
---@return Picker Picker
function M:new(opts)
  local Picker = {
    title = opts.title or "Pick a value",
    choices = opts.choices or {},
    ---@diagnostic disable-next-line: undefined-field
    action = opts.action or wt.action.Nop,
    fuzzy = opts.fuzzy or false,
    alphabet = opts.alphabet or "1234567890abcdefghilmnopqrstuvwxyz",
    description = opts.description or "Select an item.",
    fuzzy_description = opts.fuzzy_description or "Fuzzy matching: ",
  }

  setmetatable(self, { __index = Picker })
  return self
end

function M:register(name)
  ---@class Picker.List
  local module = require(name)
  local result = module.get()

  if H.is_array(result) then
    for i = 1, #result do
      local item = H.normalize_item(result[i])
      self.__choices[item.label] = { module = module, value = item.value }
    end
  else
    local item = H.normalize_item(result)
    self.__choices[result.label] = { module = module, value = item.value }
  end
end

function M:select(Overrides, callback_opts)
  local opts = self.__choices[callback_opts.id]
  if opts then
    opts.module.activate(Overrides, callback_opts)
  else
    log_error(("'%s' is not defined for %s"):format(callback_opts.id, self.title))
  end
end

function M:pick()
  return wt.action_callback(function(window, pane)
    window:perform_action(
      wt.action.InputSelector {
        action = wt.action_callback(function(inner_window, _inner_pane, id, label)
          if not id and not label then
            log_error("Cancelled " .. self.title .. " by user")
          else
            log_info("Applying " .. id .. " from " .. self.title)
            local Overrides = inner_window:get_config_overrides()
            M:select(Overrides, { window = window, pane = pane, id = id, label = label })
            window:set_config_overrides(Overrides)
          end
        end),
        title = self.title,
        choices = self.choices,
        fuzzy = self.fuzzy,
        description = self.description,
        fuzzy_description = self.fuzzy_description,
        alphabet = self.alphabet,
      },
      pane
    )
  end)
end

M.items_to_choices = function(items)
  local choices = {}
  for item_name, _ in pairs(items) do
    table.insert(choices, { label = item_name })
  end
  table.sort(choices, function(a, b)
    return a.label < b.label
  end)
  return choices
end

M.is_array = function(item)
  return type(item) == "table" and item[1] ~= nil
end

M.normalize = function(item)
  return type(item) == "table" and item or { label = item }
end

return M

--]]

return M

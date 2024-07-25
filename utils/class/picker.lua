---@module "utils.class.picker"
---@author sravioli
---@license GNU-GPLv3

local wt = require "wezterm"
local log_info, log_error = wt.log_info, wt.log_error

local Utils = require "utils"
local fs = Utils.fn.fs

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

---@class Utils.Class.Picker
---@field subdir             string path to the module name
---@field title              string defaults to `"Pick a value"`
---@field choices            table defaults to `{}`
---@field __choices?         table defaults to `{}`
---@field fuzzy?             boolean defaults to `false`
---@field alphabet?          string defaults to `"1234567890abcdefghilmnopqrstuvwxyz"`
---@field description?       string defaults to `"Select an item."`
---@field fuzzy_description? string defaults to `"Fuzzy matching: "`

---@alias Picker Utils.Class.Picker

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
---@return { id: string|nil, label: string|table|nil } choices
function h.make_choices(items, comp)
  local choices = {}
  for _, item in pairs(items) do
    log_info { item = item }
    choices[#choices + 1] = { id = item.value.id, label = item.value.label }
  end

  table.sort(choices, comp or function(a, b)
    return a.id < b.id
  end)

  return choices
end

function h.path_to_module(path)
  return path:sub(#wt.config_dir + 2):gsub("%.lua$", ""):gsub(fs.path_separator, ".")
end

-- }}}

---@class Picker
local M = {}

---Creates a new picker object
---@param opts Picker
---@return Picker Picker
function M.new(opts)
  local self = setmetatable({}, { __index = M })
  self.title = opts.title or "Pick a value"
  self.choices = {}
  self.comp = opts.comp
  self.make_choices = opts.make_choices or h.make_choices

  ---@diagnostic disable-next-line: undefined-field
  self.action = opts.action or wt.action.Nop
  self.fuzzy = opts.fuzzy or false
  self.alphabet = opts.alphabet or "1234567890abcdefghilmnopqrstuvwxyz"
  self.description = opts.description or "Select an item."
  self.fuzzy_description = opts.fuzzy_description or "Fuzzy matching: "
  self.__choices = {}

  local dir = fs.pathconcat(wt.config_dir, "pick-lists", opts.subdir)
  local paths = fs.read_dir(dir)
  for i = 1, #paths do
    self:register(h.path_to_module(paths[i]))
  end

  return self
end

function M:register(name)
  local module = require(name)

  ---@class PickList.getReturn
  local result = module.get()

  if h.is_array(result) then
    for i = 1, #result do
      local item = h.normalize(result[i])
      self.__choices[item.id] =
        { module = module, value = { id = item.id, label = item.label } }
    end
  else
    ---@cast result string
    result = h.normalize(result)
    self.__choices[result.id] =
      { module = module, value = { id = result.id, label = result.label } }
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
            local Overrides = inner_window:get_config_overrides() or {}
            self:select(
              Overrides,
              { window = window, pane = pane, id = id, label = label }
            )
            window:set_config_overrides(Overrides)
          end
        end),
        title = self.title,
        choices = self.make_choices(self.__choices, self.comp),
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

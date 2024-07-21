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
    fuzzy_description = self.fuzzy_description or "Fuzzy matching: ",
  }
end

return M

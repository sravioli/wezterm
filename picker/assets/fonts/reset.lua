---@module "picker.assets.fonts.reset"
---@author sravioli, akthe-at
---@license GNU-GPLv3

---@class PickList
local M = {}

M.get = function()
  return { id = "reset", label = "Restore fonts to default" }
end

M.activate = function(Config, _)
  for key, value in pairs(require "config.font") do
    Config[key] = value
  end
end

return M

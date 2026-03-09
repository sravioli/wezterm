---@module "picker.assets.fonts.reset"
---@author sravioli, akthe-at

---@class Picker.Module
local M = {}

M.get = function()
  return { id = "reset", label = "Restore fonts to default" }
end

M.pick = function(Config, _)
  for key, value in pairs(require "config.font") do
    Config[key] = value
  end
end

return M

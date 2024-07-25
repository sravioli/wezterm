---@class Utils.Class
---@field config Utils.Class.Config
---@field layout Utils.Class.Layout
---@field icon   Utils.Class.Icons
---@field picker Utils.Class.Picker
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("utils.class." .. k)
    return t[k]
  end,
})

return M

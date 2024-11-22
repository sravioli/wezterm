---@class Utils.Class
---@field config Utils.Class.Config
---@field icon   Utils.Class.Icons
---@field layout Utils.Class.Layout
---@field logger Utils.Class.Logger
---@field picker Utils.Class.Picker
local M = {}

local mod = ...
setmetatable(M, {
  __index = function(t, k)
    t[k] = require(mod .. "." .. k)
    return t[k]
  end,
})

return M

---@class Utils.Class
---@field config Utils.Class.Config
---@field layout Utils.Class.Layout
---@field icon   Utils.Class.Icons
---@field picker Utils.Class.Picker
---@field logger Utils.Class.Logger
local M = {}

local mod = ...
setmetatable(M, {
  __index = function(t, k)
    t[k] = require(mod .. "." .. k)
    return t[k]
  end,
})

return M

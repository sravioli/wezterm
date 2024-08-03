---@class Utils
---@field fn    Utils.Fn
---@field class Utils.Class
local M = {}

local mod = ...
setmetatable(M, {
  __index = function(t, k)
    t[k] = require(mod .. "." .. k)
    return t[k]
  end,
})

return M

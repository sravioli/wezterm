---@class Utils
---@field class    Utils.Class
---@field devicons Utils.DevIcons
---@field fn       Utils.Fn
---@field gpu      GpuAdapters
---@field perf     Utils.Perf
local M = {}

local mod = ...
setmetatable(M, {
  __index = function(t, k)
    t[k] = require(mod .. "." .. k)
    return t[k]
  end,
})

return M

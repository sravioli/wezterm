---@class Fn
---@field color Fn.Color
local M = {}

setmetatable(M, {
  __index = function(t, k)
    local modname = "utils.fn." .. k
    local ok, mod = pcall(require, modname)
    if not ok then
      return require("plugs.log").new("Fn"):error("Unable to load module %s", modname)
    end

    rawset(t, k, mod)
    return mod
  end,
})

return M

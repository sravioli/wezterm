---@class Fn
---@field g     Fn.Cache
---@field fs    Fn.FileSystem
---@field key   Fn.Keymap
---@field maths Fn.Maths
---@field str   Fn.String
---@field tbl   Fn.Table
local M = {}

setmetatable(M, {
  __index = function(t, k)
    local modname = "utils.fn." .. k
    local ok, mod = pcall(require, modname)
    if not ok then
      return require("utils.logger").new("Fn"):error("Unable to load module %s", modname)
    end

    rawset(t, k, mod)
    return mod
  end,
})

return M

---Utilities
---@class Logger.Sinks
---@field wt     Logger.Sink             wezterm sink
---@field memory Logger.Sinks.MemorySink memory sink
local M = {}

setmetatable(M, {
  __index = function(t, k)
    local modname = "utils.logger.sinks." .. k
    local ok, mod = pcall(require, modname)
    if not ok then
      return require("utils.logger")
        :new("Logger.Sinks")
        :error("Unable to load module %s", modname)
    end

    rawset(t, k, mod)
    return mod
  end,
})

return M

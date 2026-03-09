---@module "utils.logger.levels"

---@class Logger.Levels
---@field levels table<string, integer> Map of level names to integer values.
---@field names  table<integer, string> Map of integer values to level names.
local M = {}

---@enum Logger.Levels.Level
M.levels = { DEBUG = 0, INFO = 1, WARN = 2, ERROR = 3 }

---@type table<integer, string>
M.names = { [0] = "DEBUG", [1] = "INFO", [2] = "WARN", [3] = "ERROR" }

---Normalize log level from string or integer.
---
---If a string is provided (e.g., "info"), it is uppercased and mapped to its integer value.
---
---@param level Logger.Level Level representation to normalize.
---@return integer level Normalized numeric level.
function M.normalize(level)
  if type(level) == "string" then
    return M.levels[level:upper()]
  end
  return level
end

return M

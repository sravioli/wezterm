---@module "utils.class.logger"
---@author sravioli
---@license GNU-GPLv3

local wt = require "wezterm"

---@diagnostic disable-next-line: undefined-field
local G, log_info, log_warn, log_error = wt.GLOBAL, wt.log_info, wt.log_warn, wt.log_error

-- selene: allow(incorrect_standard_library_use)
local unpack = unpack or table.unpack
local inspect = require("utils.external.inspect").inspect
local levels = { DEBUG = 0, INFO = 1, WARN = 2, ERROR = 3 }

-- {{{1 Helpers

local h = {}

---Converts each given vararg to a string
---@param ... any
---@return ... string
h.stringify = function(...)
  local args = { ... }
  for i = 1, #args do
    if type(args[i]) == "userdata" then
      args[i] = tostring(args[i])
    else
      args[i] = inspect(args[i])
    end
  end
  return unpack(args)
end

---Returns the appropriate log level
---@param level string|integer
---@return integer level log level converted to integer
h.get_level = function(level)
  if type(level) == "string" then
    level = levels[level:upper()]
  end
  return level
end
-- }}}

---@class Utils.Class.Logger
---@field identifier string
---@field enabled    boolean
---@field log_level  integer
local M = {}
M.__index = M

---Creates a new class instance
---
---Whether logging is enabled is globally controlled by the `wezterm.GLOBAL.enable_logging`
---variable.  Setting it to `false` (either from the Debug overlay or from the configuration),
---will disable logging; the opposite happens when it is set to `true`.
---
---@param identifier? string indentifier that will be printed in brackets before the msg
---@param enabled?    boolean whether to enable logging or not. defaults to true at warn lvl
---@return Utils.Class.Logger
function M:new(identifier, enabled)
  return setmetatable({
    identifier = identifier or "Logger",
    enabled = G.enable_logging or enabled or true,
    log_level = h.get_level(G.log_level or levels.WARN),
  }, self)
end

---Logs a message with the specified log level
---
---Logs the given string to the Wezterm's debug overlay.  The message can be either a
---simple string or a format string.  The latter must only use `%s` placeholders since the
---function already takes care of stringifing any non-string value.
---
---@param level integer|string log level
---@param message string log message or format string
---@param ... any additional arguments to format into the message
function M:log(level, message, ...)
  if not (G.enable_logging and self.enabled) then
    return
  end

  if h.get_level(level) < self.log_level then
    return
  end

  local msg = ("[%s] %s"):format(self.identifier, message:format(h.stringify(...)))
  if (level == levels.DEBUG) or (level == levels.INFO) then
    log_info(msg)
  elseif level == levels.WARN then
    log_warn(msg)
  elseif level == levels.ERROR then
    log_error(msg)
  else
    self:error("invalid log level: %s", level)
  end
end

---Logs a debug level message to the Wezterm's debug overlay.
---
---Logs the given string to the Wezterm's debug overlay.  The message can be either a
---simple string or a format string.  The latter must only use `%s` placeholders since the
---function already takes care of stringifing any non-string value.
---
---@param message string log message or format string
---@param ... any additional arguments to format into the message
function M:debug(message, ...)
  self:log(levels.DEBUG, "DEBUG: " .. message, ...)
end

---Logs a info level message to the Wezterm's debug overlay.
---
---Logs the given string to the Wezterm's debug overlay.  The message can be either a
---simple string or a format string.  The latter must only use `%s` placeholders since the
---function already takes care of stringifing any non-string value.
---
---@param message string log message or format string
---@param ... any additional arguments to format into the message
function M:info(message, ...)
  self:log(levels.INFO, message, ...)
end

---Logs a warn level message to the Wezterm's debug overlay.
---
---Logs the given string to the Wezterm's debug overlay.  The message can be either a
---simple string or a format string.  The latter must only use `%s` placeholders since the
---function already takes care of stringifing any non-string value.
---
---@param message string log message or format string
---@param ... any additional arguments to format into the message
function M:warn(message, ...)
  self:log(levels.WARN, message, ...)
end

---Logs an error level message to the Wezterm's debug overlay.
---
---Logs the given string to the Wezterm's debug overlay.  The message can be either a
---simple string or a format string.  The latter must only use `%s` placeholders since the
---function already takes care of stringifing any non-string value.
---
---@param message string log message or format string
---@param ... any additional arguments to format into the message
function M:error(message, ...)
  self:log(levels.ERROR, message, ...)
end

return M

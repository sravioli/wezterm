---@module "utils.logger"

---@class Opts.Utils.Logger
local Opts = require("opts").utils.logger

-- selene: allow(incorrect_standard_library_use)
local unpack = unpack or table.unpack
local inspect = require("utils.external.inspect").inspect
local l = require "utils.logger.levels" ---@class Logger.Levels

local default_sink = require "utils.logger.sinks.wt"

---Convert all vararg values into printable strings.
---
---`userdata` values are converted using `tostring`, while all other types are pretty-printed
---using the external `inspect` module. The returned values can be safely passed to
---`string.format`.
---
---@param ... any Values to stringify.
---@return ... Stringified values.
local function prettify_args(...)
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

---@class Logger
---@field tag       string        Printable name prefix included in each log line.
---@field enabled   boolean       Whether this logger instance is currently enabled.
---@field threshold integer       Minimum level required for logs to be emitted.
---@field sinks     Logger.Sink[] List of active sinks.
---
---A lightweight wrapper around WezTerm’s built-in logging facilities.
---
---Logging is globally gated by the `Opts.Logger.enabled` variable. When set to `false`
---(either from configuration or the Debug overlay), **all logger instances are silenced**.
---
---Logging is **enabled** by default.
---@see Opts.Logger to see the default global logger options
local M = {}
M.__index = M

---Create new logger instance.
---
---If `OPTS.sinks.default_enabled` is true, the default sink is prepended to the list.
---
---@param tag?     string        Identifier printed in brackets before message. Defaults to "Logger".
---@param enabled? boolean       Enable logging status. Defaults to global OPTS or true.
---@param sinks?   Logger.Sink[] List of sinks to output to.
---@return Logger
function M:new(tag, enabled, sinks)
  sinks = sinks or {}

  if Opts.sinks.default_enabled then
    table.insert(sinks, 1, default_sink)
  end

  return setmetatable({
    tag = tag or "Logger",
    enabled = Opts.enabled or enabled or true,
    threshold = l.normalize(Opts.threshold or l.levels.WARN),
    sinks = sinks,
  }, self)
end

---Add sink to the sinks table.
---
---@param sink Logger.Sink Function to handle log entry.
function M:add_sink(sink)
  table.insert(self.sinks, sink)
end

---Emit event to all sinks.
---
---@param event Logger.Event Data structure containing log details.
---@private
function M:_emit(event)
  for _, sink in ipairs(self.sinks) do
    sink(event)
  end
end

---Log message with specified log level.
---
---Accepts simple string or format string. Non-string arguments are stringified
---(userdata via `tostring`, others via `inspect`).
---
---@param level   Logger.Level Severity level.
---@param message string       Log message or format string.
---@param ...     any          Additional arguments to format into message.
function M:log(level, message, ...)
  local lvl = l.normalize(level)
  if not (Opts.enabled and self.enabled) or lvl < self.threshold then
    return
  end

  local msg = ("[%s] %s"):format(self.tag, message:format(prettify_args(...)))

  self:_emit {
    level = lvl,
    level_name = l.names[lvl],
    tag = self.tag,
    message = msg,
    raw_message = message,
  }
end

---Log debug level message.
---
---Prepends "DEBUG: " to the message string.
---
---@param message string Log message or format string.
---@param ...     any    Additional arguments to format into message.
function M:debug(message, ...)
  self:log(l.levels.DEBUG, "DEBUG: " .. message, ...)
end

---Log information level message.
---
---@param message string Log message or format string.
---@param ...     any    Additional arguments to format into message.
function M:info(message, ...)
  self:log(l.levels.INFO, message, ...)
end

---Log warning level message.
---
---@param message string Log message or format string.
---@param ...     any    Additional arguments to format into message.
function M:warn(message, ...)
  self:log(l.levels.WARN, message, ...)
end

---Log error level message.
---
---@param message string Log message or format string.
---@param ...     any    Additional arguments to format into message.
function M:error(message, ...)
  self:log(l.levels.ERROR, message, ...)
end

return M

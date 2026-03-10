---@meta utils.Logger
error "cannot require a meta file!"

---@class Logger.Event
---@field public level       integer Log severity level.
---@field public level_name  string  Human-readable name of the log level.
---@field public tag         string  Identifier of the logger instance.
---@field public message     string  Final formatted log message.
---@field public raw_message string  Original message string before formatting.

---@alias Logger.Sink fun(entry: Logger.Event): any|nil

---@alias Logger.Level Logger.Levels.Level|string|integer

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

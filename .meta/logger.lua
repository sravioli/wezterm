---@meta utils.Logger
error "cannot require a meta file!"

---@class Logger.Event
---@field level       integer Log severity level.
---@field level_name  string  Human-readable name of the log level.
---@field tag         string  Identifier of the logger instance.
---@field message     string  Final formatted log message.
---@field raw_message string  Original message string before formatting.

---@alias Logger.Sink fun(entry: Logger.Event): any|nil

---@alias Logger.Level Logger.Levels.Level|string|integer

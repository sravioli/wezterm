---@meta Opts.Utils.Logger
error "cannot require a meta file!"

-- luacheck: push ignore 631 (line is too long)

---@class Opts.Utils.Logger
---@field public enabled?   boolean                 Enable logging utility.
---@field public threshold? string                  Minimum log level to display (e.g., "INFO", "DEBUG", "ERROR").
---@field public sinks?     Opts.Utils.Logger.Sinks Configuration for individual log output sinks.
---
---
---Logger sink configuration options.
---@class Opts.Utils.Logger.Sinks
---@field default_enabled? boolean Enable the default log sink (usually stdout/stderr).

-- luacheck: pop

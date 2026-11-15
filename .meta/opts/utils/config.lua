---@meta Opts.Utils.Config
error "cannot require a meta file!"

-- luacheck: push ignore 631 (line is too long)

---@class Opts.Utils.Config
---@field public log?     Opts.Utils.Config.Log
---@field public builder? Opts.Utils.Config.Builder
---
---
---@class Opts.Utils.Config.Log
---@field public enabled?   boolean Enable logging for the config builder.
---@field public threshold? string  Minimum log level to display.
---@field public sinks?     table   Sink configuration accepted by the logger.
---
---
---@class Opts.Utils.Config.Builder
---@field public enabled?     boolean Whether to use the WezTerm config builder (default: only when `WEZTERM_STRICT=1`).
---@field public strict_mode? boolean Whether to enable strict mode for the config builder.

-- luacheck: pop

---@meta Opts.Utils.Config
error "cannot require a meta file!"

-- luacheck: push ignore 631 (line is too long)

---@class Opts.Utils.Config: Opts.Utils.Base
---@field public builder? Opts.Utils.Config.Builder
---
---
---@class Opts.Utils.Config.Builder
---@field public enabled?     boolean Whether to use the WezTerm config builder.
---@field public strict_mode? boolean Whether to enable strict mode for the config builder.

-- luacheck: pop

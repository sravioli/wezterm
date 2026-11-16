---@meta Opts
error "cannot require a meta file!"

-- luacheck: push ignore 631 (line is too long)

---@class Opts
---@field public utils?     Opts.Utils
---@field public statusbar? Opts.StatusBar
---@field public config?    Opts.Config
---@field public events?    Opts.Events

-- luacheck: pop

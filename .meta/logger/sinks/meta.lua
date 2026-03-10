---@meta utils.Logger.Sinks
error "cannot require a meta file!"

---Lazy-loading registry for logger output sinks.
---
---Sub-modules are loaded on first access via `__index`.
---
---@class Logger.Sinks
---@field public wt     Logger.Sink             WezTerm native logging sink.
---@field public memory Logger.Sinks.MemorySink In-memory log storage sink.

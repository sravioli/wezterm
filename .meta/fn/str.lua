---@meta fn.String
error "cannot require a meta file!"

---@class SplitOpts
---@field public plain?     boolean Treat separator as plain text (no pattern matching).
---@field public trimempty? boolean Trim empty segments from start and end.

---@alias TruncateMode "left" | "right" | "middle"

---@class Fn.String
---@field public width fun(s: string): integer

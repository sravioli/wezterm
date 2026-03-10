---@meta utils.Logger.Levels
error "cannot require a meta file!"

-- luacheck: push ignore 631 (line is too long)

---Named log severity levels and normalisation utility.
---
---@class Logger.Levels
---@field public levels table<string, integer> Map of level names to integer values.
---@field public names  table<integer, string> Map of integer values to level names.

-- luacheck: pop

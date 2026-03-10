---@meta utils.Layout
error "cannot require a meta file!"

-- luacheck: push ignore 631 (line is too long)

---Wrapper for WezTerm's `FormatItem` objects.
---
---Encapsulate the complexity of managing multiple attributes, colors, and text segments
---into a linear list of operations.  Support append/prepend semantics, configurable text
---processing, and optional atomic mode (auto-reset after each operation).
---
---### Example Usage
---~~~lua
---local Layout = require("utils.layout")
---local cell = Layout:new("MyCell", true)
---cell:append("#1a1b26", "#c0caf5", " hello ", "Bold")
---cell:append("#1a1b26", "#bb9af7", " world ", { "Italic", "Single" })
---local formatted = cell:format()
---~~~
---
---@class Layout
---@field public  log     Logger  Logger instance.
---@field public  atomic? boolean Whether to reset text attributes after each operation.
---@field private layout  table   Internal `FormatItem` storage.
---@field private name    string  Layout identifier used for logging.

-- luacheck: pop

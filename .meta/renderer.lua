---@meta utils.Renderer
error "cannot require a meta file!"

-- luacheck: push ignore 631 (line is too long)

---Status bar renderer.
---
---Coordinate the rendering of left and right status bar sections.  Resolve
---module conditions, styles, padding, separators, and text content into
---`FormatItem` arrays consumable by WezTerm.
---
---The render cycle has two phases:
---  1. `init()` → `render_layout(left)` → `commit_left()`
---  2. `render_layout(right)` (budget-aware via `BarBudget`)
---
---@class Renderer
---@field public window        Window         Active WezTerm window object.
---@field public pane          Pane           Active WezTerm pane object.
---@field public theme         table          Resolved colour scheme.
---@field public config        table          WezTerm config object.
---@field public width         Renderer.Width Column budget tracker.
---@field public default_style table          Default style derived from theme foreground/background.

---@class Renderer.Width
---@field public used      integer Columns consumed so far in the current render pass.
---@field public available integer Columns available for the current render pass.

---Degradation mode for cell rendering when the full cell does not fit.
---
---  * `"full"` – icon + text, no truncation.
---  * `"trim"` – icon + truncated text.
---  * `"text"` – text only, no icon.
---  * `"icon"` – icon only, no text.
---@alias CellRenderMode "full"|"trim"|"text"|"icon"

-- luacheck: pop

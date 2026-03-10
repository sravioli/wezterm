---@meta utils.BarBudget
error "cannot require a meta file!"

-- luacheck: push ignore 631 (line is too long)

---Central budget oracle for the tab bar and status bar.
---
---Track three categories of column consumption so that every module can
---query how much space remains without duplicating measurement logic:
---
---  1. **Tab cells** – per-tab rendered widths published by `format-tab-title`.
---  2. **Left status** – columns consumed by the left-status render pass.
---  3. **New-tab button** – 0 or 8 columns reserved when the button is shown.
---
---@class BarBudget
---@field private _widths             table<integer, integer> Zero-based tab index → column width.
---@field private _count              integer                 Current number of tabs.
---@field private _total_cached       integer                 Running sum of all per-tab widths.
---@field private _has_real_data      boolean                 True after the first `record()` call.
---@field private _total_screen_width integer                 True terminal width in columns (set once per cycle by `Renderer.init()`).
---@field private _left_used          integer                 Columns consumed by left-status render pass.
---@field private _new_tab_button     integer                 Columns reserved for the new-tab button (0 or 8).
---@field private _tab_max_width      integer                 `config.tab_max_width` used for cold-start estimation.

-- luacheck: pop

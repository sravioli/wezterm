---@module 'utils.tab-bar'
--- Shared state between the `format-tab-title` and `update-status` events.
---
--- `format-tab-title` is the only place that *actually* renders a tab cell, so
--- it is the authoritative source for rendered column widths.  By publishing
--- those widths here, `update-status` can compute the space that remains for
--- the right-hand status string without duplicating — or approximating — any
--- tab-formatting logic.
---
--- Additionally, the renderer publishes the total screen width and left-status
--- used width here after each render pass so that the `keys` hint module can
--- call `right_available()` without needing access to the renderer's internals.

local str = require "utils.fn.str" ---@class Fn.String

---@class TabBar
local M = {
  -- ── Per-tab widths (set by format-tab-title) ─────────────────────────────
  _widths = {}, ---@type table<integer, integer>  zero-based index → columns
  _count = 0, ---@type integer

  -- ── Layout-wide metrics (set by renderer / update-status) ────────────────

  --- Total screen columns available to the status bar.
  --- Set by `Renderer.init()` on every update-status cycle.
  _screen_width = 0, ---@type integer

  --- Columns consumed by the left-status render pass.
  --- Set by `Renderer.commit_left()` after the left layout is rendered.
  _left_used = 0, ---@type integer

  --- Columns reserved for the new-tab button (0 or 8).
  --- Set by the `keys` module creator from `config.show_new_tab_button_in_tab_bar`.
  _new_tab_button = 0, ---@type integer
}

-- ── Tab-width registry ────────────────────────────────────────────────────────

---Record the rendered column-width for one tab cell.
---@param index    integer  zero-based tab index
---@param rendered string   raw output of `cell:format()` (may contain ANSI codes)
function M.record(index, rendered)
  M._widths[index] = str.column_width(rendered)
end

---Persist the current number of tabs and prune any stale entries left over
---from a layout with more tabs.
---@param count integer
function M.set_count(count)
  for i = count, M._count - 1 do
    M._widths[i] = nil
  end
  M._count = count
end

---Total columns consumed by all tab cells in the last render pass.
---@return integer
function M.total_width()
  local total = 0
  for i = 0, M._count - 1 do
    total = total + (M._widths[i] or 0)
  end
  return total
end

-- ── Layout-wide metric setters (called by renderer / modules) ─────────────────

---Set the total screen width for the current render cycle.
---Called by `Renderer.init()`.
---@param cols integer
function M.set_screen_width(cols)
  M._screen_width = cols
end

---Set the column count consumed by the left-status render pass.
---Called by `Renderer.commit_left()` immediately after rendering the left layout.
---@param cols integer
function M.set_left_used(cols)
  M._left_used = cols
end

---Set the reservation for the new-tab button (0 when hidden, 8 when shown).
---Called by the `keys` module creator, which has access to `config`.
---@param cols integer
function M.set_new_tab_button(cols)
  M._new_tab_button = cols
end

-- ── Derived metric ────────────────────────────────────────────────────────────

---Columns available for the right-status bar in the current render cycle.
---
---  right_available = screen_width - tab_cells - left_status - new_tab_button
---
---This is the value that should be passed as `width` to `keymapper.hint_layout()`
---inside the `keys` module so that the hint fills exactly the remaining space.
---
---@return integer
function M.right_available()
  return math.max(0, M._screen_width - M.total_width() - M._left_used - M._new_tab_button)
end

return M

---@module 'utils.bar-budget'
--- Central budget oracle for the tab bar and status bar.
---
--- Tracks three categories of column consumption so that every module can
--- query how much space remains without duplicating measurement logic:
---
---   1. **Tab cells** - per-tab rendered widths published by `format-tab-title`
---      via `record()` / `set_count()`.
---   2. **Left status** - columns consumed by the left-status render pass,
---      published by `Renderer.commit_left()` via `set_left_used()`.
---   3. **New-tab button** - 0 or 8 columns reserved when the button is shown,
---      published by `Renderer.commit_left()` via `set_new_tab_button()`.
---
--- The total screen width (`_total_screen_width`) is set **once per render
--- cycle** by `Renderer.init()` (the first, un-constrained call).  It is never
--- overwritten by subsequent renderer operations, guaranteeing that
--- `right_available()` always computes from the true terminal width.
---
--- On the very first frame, `format-tab-title` may not have fired yet.
--- `total_width()` detects this (no real per-tab data) and returns a
--- conservative upper-bound estimate using `_tab_max_width` so the right
--- status never overflows.

local warp = require "plugs.warp" ---@class Warp.Api
local str = warp.string ---@class Warp.String

---@class BarBudget
local M = {
  -- ── Per-tab widths (set by format-tab-title) ─────────────────────────────
  _widths = {}, ---@type table<integer, integer>  zero-based index → columns
  _count = 0, ---@type integer
  _total_cached = 0, ---@type integer  running sum of all per-tab widths
  _has_real_data = false, ---@type boolean  true after the first `record()` call

  -- ── Layout-wide metrics ──────────────────────────────────────────────────

  --- True terminal width in columns.
  --- Set **once per cycle** by `Renderer.init()` (without `available_cols`).
  _total_screen_width = 0, ---@type integer

  --- Columns consumed by the left-status render pass.
  --- Set by `Renderer.commit_left()` before the right-status render.
  _left_used = 0, ---@type integer

  --- Columns reserved for the new-tab button (0 or 8).
  --- Set by `Renderer.commit_left()`, which has access to `config`.
  _new_tab_button = 0, ---@type integer

  --- `config.tab_max_width` (default 30).  Used only for the first-frame
  --- cold-start estimate when `format-tab-title` hasn't published real data.
  _tab_max_width = 30, ---@type integer
}

---Record the column-width for one tab cell.
---
---Accepts either a pre-computed numeric width (fastest) or the raw rendered
---string (ANSI codes are stripped automatically).  Prefer passing a number
---when the caller already knows the width from its own layout math.
---
---@param index           integer         zero-based tab index
---@param width_or_rendered integer|string  column count **or** raw `cell:format()` output
function M.record(index, width_or_rendered)
  local new_w
  if type(width_or_rendered) == "number" then
    new_w = width_or_rendered
  else
    new_w = str.width(width_or_rendered)
  end

  local old_w = M._widths[index] or 0
  M._widths[index] = new_w
  M._total_cached = M._total_cached - old_w + new_w
  M._has_real_data = true
end

---Persist the current number of tabs and prune any stale entries left over
---from a layout with more tabs.
---@param count integer
function M.set_count(count)
  if count == M._count then
    return
  end
  for i = count, M._count - 1 do
    local w = M._widths[i] or 0
    M._total_cached = M._total_cached - w
    M._widths[i] = nil
  end
  M._count = count
end

---Total columns consumed by all tab cells in the last render pass.  O(1).
---
---On the **first frame**, before `format-tab-title` has published real widths,
---returns a conservative upper-bound estimate (`_count * _tab_max_width`) so
---the right status never overflows.  Once real data arrives the cached running
---total is returned directly.
---@return integer
function M.total_width()
  if M._count > 0 and not M._has_real_data then
    return M._count * M._tab_max_width
  end
  return M._total_cached
end

---Set the true terminal width for the current render cycle.
---Called **once** by `Renderer.init()` (the first, un-constrained call).
---@param cols integer
function M.set_screen_width(cols)
  M._total_screen_width = cols
end

---Set the column count consumed by the left-status render pass.
---Called by `Renderer.commit_left()` **before** the right-status render.
---@param cols integer
function M.set_left_used(cols)
  M._left_used = cols
end

---Set the reservation for the new-tab button (0 when hidden, 8 when shown).
---Called by `Renderer.commit_left()`, which has access to `config`.
---@param cols integer
function M.set_new_tab_button(cols)
  M._new_tab_button = cols
end

---Set the per-tab max width from config (used for cold-start estimation).
---Called by `Renderer.init()`.  Skips the write when unchanged.
---@param cols integer
function M.set_tab_max_width(cols)
  if cols == M._tab_max_width then
    return
  end
  M._tab_max_width = cols
end

---Columns available for the right-status bar in the current render cycle.
---
---```
---  right_available = total_screen_width
---                  − tab_cells
---                  − left_status
---                  − new_tab_button
---```
---
---All inputs are guaranteed current-cycle when called during the right-status
---render pass (after `Renderer.commit_left()`).
---
---@return integer
function M.right_available()
  return math.max(
    0,
    M._total_screen_width - M.total_width() - M._left_used - M._new_tab_button
  )
end

return M

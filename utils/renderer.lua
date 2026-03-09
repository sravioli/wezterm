---@module 'utils.renderer'

local fn = require "utils.fn" ---@class Fn
local sb = require("utils.layout"):new "StatusBar" ---@class Layout
local str = require "utils.fn.str" ---@class Fn.String
local budget = require "utils.bar-budget" ---@class BarBudget
local wt = require "wezterm" ---@class Wezterm

-- Direct binding to the C function — bypasses the ANSI-strip regex in
-- str.column_width.  Safe here because all inputs at this layer are plain
-- text (icons, separators, padding, resolved node values).  For strings
-- that may contain ANSI codes (e.g. resolve_layout output), use
-- str.column_width instead.
local raw_cw = wt.column_width

local Opts = require("opts").statusbar ---@class Opts.StatusBar
local log = require("utils.logger"):new("StatusBar", true) ---@class Logger

-- selene: allow(incorrect_standard_library_use)
local tunpack = unpack or table.unpack

---@class Renderer
local M = {
  window = nil,
  pane = nil,
  theme = nil,
  config = nil,
  width = { used = 0, available = 0 },
}

-- Reusable Layout cell for assemble_cell (avoids Layout + Logger allocation
-- per cell render).  Cleared via :clear() before each use.
local _cell = sb:new "Cell"

-- Reusable context table for resolve_layout (avoids per-call allocation).
local _layout_ctx = {}

-- ---------------------------------------------------------------------------
-- Width utilities
-- ---------------------------------------------------------------------------

---@param s string
---@return integer
local function visible_width(s)
  if not s or s == "" then
    return 0
  end
  return raw_cw(s)
end

---@param s        string
---@param max_cols integer
---@param ellipsis? string
---@return string
local function truncate(s, max_cols, ellipsis)
  ellipsis = ellipsis or "…"
  if max_cols <= 0 then
    return ""
  end
  if str.column_width(s) <= max_cols then
    return s
  end

  local ew = str.column_width(ellipsis)
  local result, w = {}, 0
  for cp in s:gmatch "[^\128-\191][\128-\191]*" do
    local cpw = str.column_width(cp)
    if w + cpw + ew > max_cols then
      break
    end
    result[#result + 1] = cp
    w = w + cpw
  end
  return table.concat(result) .. ellipsis
end

-- ---------------------------------------------------------------------------
-- Init
-- ---------------------------------------------------------------------------

function M.init(config, window, pane, theme)
  M.config, M.window, M.pane, M.theme = config, window, pane, theme
  M.default_style = { fg = M.theme.foreground, bg = M.theme.background, attributes = nil }

  local pane_dimensions = pane:get_dimensions()
  local win_width = window:get_dimensions().pixel_width
  M.width.available =
    math.floor((win_width * pane_dimensions.cols) / pane_dimensions.pixel_width)
  M.width.used = 0

  -- Publish total screen width **once** per cycle so that
  -- `budget.right_available()` always computes from the true terminal width.
  budget.set_screen_width(M.width.available)

  -- Seed tab_max_width for the cold-start estimator.
  budget.set_tab_max_width(config.tab_max_width or 30)
end

-- ---------------------------------------------------------------------------
-- Width publication helpers
-- ---------------------------------------------------------------------------

---Return the number of columns consumed by the most recent `render_layout` call.
---@return integer
function M.get_used_width()
  return M.width.used
end

---Transition from the left-status render phase to the right-status phase.
---
---This is the **single synchronisation point** between the two halves of the
---status bar.  It performs three things atomically:
---
---  1. Publishes `_left_used` so `budget.right_available()` is accurate.
---  2. Publishes `_new_tab_button` (derived from `config`).
---  3. Recalculates `M.width.available` for the right render pass:
---     `right_budget = total_screen − left_used − tab_cells − new_tab_button`
---  4. Resets `M.width.used` to 0 for the right layout.
---
---```lua
----- update-status handler excerpt:
---Renderer.init(config, window, pane, theme)
---local left = Renderer.render_layout(Opts.layout.left)
---Renderer.commit_left()
---local right = Renderer.render_layout(Opts.layout.right)
---```
function M.commit_left()
  local left_used = M.width.used
  budget.set_left_used(left_used)

  local ntb = (M.config.show_new_tab_button_in_tab_bar and 8 or 0)
  budget.set_new_tab_button(ntb)

  -- Recalculate the budget for the right-status render pass.
  M.width.available = budget.right_available()
  M.width.used = 0
end

-- ---------------------------------------------------------------------------
-- Style / node helpers
-- ---------------------------------------------------------------------------

--- Evaluate mod.cond: supports nil (treat as false), function, or plain value.
---@param mod Opts.StatusBar.Module|Opts.StatusBar.Module.Component
---@return boolean
local function resolve_cond(mod)
  local cond = mod.cond
  if type(cond) == "function" then
    return cond(M.window, M.pane)
  end
  return cond ---@diagnostic disable-line: return-type-mismatch
end

---@param mod Opts.StatusBar.Module|Opts.StatusBar.Module.Component|nil
---@return boolean
M.enabled = function(mod)
  return mod ~= nil and mod.enabled == true and resolve_cond(mod) == true
end

M.has_style = function(mod)
  return mod.style and type(mod.style) == "function"
end

M.style_node = function(node, parent_style)
  local style = parent_style or {}

  if node.invert_bg_fg then
    style = { fg = style.bg, bg = style.fg }
  end

  if not node.style then
    return style
  end

  local typ = type(node.style)
  if typ == "function" then
    return node.style(M.theme, style)
  end
  if typ == "table" then
    return fn.tbl.merge({ behavior = "force", combine = true }, node.style, style)
  end
  return style
end

M.resolve_node = function(node)
  if not node or not node.enabled then
    return ""
  end

  local typ = type(node.value)
  local value = typ == "function" and node.value(M.window, M.pane) or node.value

  if typ == "table" then
    return value
  end
  return fn.str.pad(value, node.padding or 0)
end

M.prepare_node = function(node, parent_style)
  node = node or ""
  return M.resolve_node(node), M.style_node(node, parent_style)
end

M.get_padding = function(padding)
  if type(padding) == "table" then
    return padding.left, padding.right
  end
  return padding, padding
end

M.add_padding = function(cell, padding, style)
  if padding then
    cell:append(nil, nil, string.rep(" ", padding), nil)
  end
end

M.add_separator = function(cell, sep, style)
  if sep then
    cell:append(style.bg, style.fg, sep, style.attributes)
  end
end

-- ---------------------------------------------------------------------------
-- Sep normalisation
-- ---------------------------------------------------------------------------

--- Normalise a raw sep value into `{ left, right }`.
---@param raw any
---@return { left: string|nil, right: string|nil }
local function normalise_sep_value(raw)
  if type(raw) == "function" then
    raw = raw(M.window, M.pane)
  end
  if type(raw) == "table" then
    return { left = raw.left, right = raw.right }
  end
  return { left = raw or nil, right = nil }
end

---@param node Opts.StatusBar.Module.Sep|nil
---@param parent_style table
---@return { left: string|nil, right: string|nil }
---@return table style
M.prepare_sep = function(node, parent_style)
  local style = M.style_node(node or {}, parent_style)
  if not node or not node.enabled then
    return { left = nil, right = nil }, style
  end
  return normalise_sep_value(node.value), style
end

-- ---------------------------------------------------------------------------
-- Flexible cell rendering
-- ---------------------------------------------------------------------------

---@alias CellRenderMode "full"|"trim"|"text"|"icon"
local RENDER_MODES = { "full", "trim", "text", "icon" }

--- Per-mode content resolvers.
--- Each returns `(render_icon, render_text)` or `nil` when the mode is inapplicable/overflows.
---@type table<CellRenderMode, fun(icon:string, text:string, has_icon:boolean, has_text:boolean, avail_cols:integer|nil, overhead:integer): string|nil, string|nil>
local CONTENT_RESOLVERS = {
  full = function(icon, text, _, _)
    return icon, text
  end,

  trim = function(icon, text, _, has_text, avail_cols, overhead)
    if not has_text then
      return icon, ""
    end
    local budget = (avail_cols or math.huge) - overhead - visible_width(icon)
    local trimmed = truncate(text, budget)
    if trimmed == "" then
      return nil
    end
    return icon, trimmed
  end,

  text = function(_, text, has_icon, has_text)
    if not has_icon or not has_text then
      return nil
    end
    return "", text
  end,

  icon = function(icon, _, has_icon, has_text)
    if not has_icon or not has_text then
      return nil
    end
    return icon, ""
  end,
}

--- Gather the raw icon/text strings and their styles for a module.
---@param module Opts.StatusBar.Module
---@param style  table
---@return string icon_val, table icon_style, string text_val, table text_style
local function resolve_module_content(module, style)
  local icon_val, icon_style = "", style
  local text_val, text_style = "", style
  if module.icon then
    icon_val, icon_style = M.prepare_node(module.icon, style)
  end
  if module.text then
    text_val, text_style = M.prepare_node(module.text, style)
  end
  return icon_val, icon_style, text_val, text_style
end

--- Compute the fixed overhead (padding + separators) for a module.
---@param module Opts.StatusBar.Module
---@param sep    { left: string|nil, right: string|nil }
---@return integer pad_left, integer pad_right, integer overhead
local function compute_overhead(module, sep)
  local pad_left, pad_right = M.get_padding(module.padding)
  local overhead = (pad_left or 0)
    + (pad_right or 0)
    + (sep.left and visible_width(sep.left) or 0)
    + (sep.right and visible_width(sep.right) or 0)
  return pad_left, pad_right, overhead
end

--- Assemble a Layout Cell from pre-resolved content.
---
--- Uses the module-level `_cell` instance (cleared on each call) to avoid
--- allocating a new Layout + Logger per cell render.
---@param module       Opts.StatusBar.Module
---@param render_icon  string
---@param render_text  string
---@param icon_style   table
---@param text_style   table
---@param sep          { left: string|nil, right: string|nil }
---@param sep_style    table
---@param pad_left     integer|nil
---@param pad_right    integer|nil
---@param style        table
---@return string
local function assemble_cell(
  module,
  render_icon,
  render_text,
  icon_style,
  text_style,
  sep,
  sep_style,
  pad_left,
  pad_right,
  style
)
  _cell:clear()
  local icon_pos = (module.icon and module.icon.position) or "left"

  M.add_padding(_cell, pad_left, style)
  M.add_separator(_cell, sep.right, sep_style)

  if icon_pos == "right" then
    if render_text ~= "" then
      _cell:append(text_style.bg, text_style.fg, render_text, text_style.attributes)
    end
    if render_icon ~= "" then
      _cell:append(icon_style.bg, icon_style.fg, render_icon, icon_style.attributes)
    end
  else
    if render_icon ~= "" then
      _cell:append(icon_style.bg, icon_style.fg, render_icon, icon_style.attributes)
    end
    if render_text ~= "" then
      _cell:append(text_style.bg, text_style.fg, render_text, text_style.attributes)
    end
  end

  M.add_separator(_cell, sep.left, sep_style)
  M.add_padding(_cell, pad_right, style)

  return _cell:format()
end

-- ---------------------------------------------------------------------------
-- Pre-resolved cell parts
-- ---------------------------------------------------------------------------

--- Pre-compute the mode-invariant parts of a module's cell rendering.
--- Called once per module; the result is passed to `build_cell_from_parts`
--- for each render-mode trial — avoiding redundant style / content / sep
--- resolution per mode.
---@param module Opts.StatusBar.Module
---@return table parts
local function resolve_cell_parts(module)
  local style = M.style_node(module, M.default_style)
  local icon_val, icon_style, text_val, text_style = resolve_module_content(module, style)
  local sep, sep_style = M.prepare_sep(module.sep, style)
  local pad_left, pad_right, overhead = compute_overhead(module, sep)
  return {
    style = style,
    has_icon = module.icon ~= nil,
    has_text = module.text ~= nil,
    icon_val = icon_val,
    icon_style = icon_style,
    text_val = text_val,
    text_style = text_style,
    sep = sep,
    sep_style = sep_style,
    pad_left = pad_left,
    pad_right = pad_right,
    overhead = overhead,
  }
end

--- Build a cell from pre-resolved parts for a specific render mode.
--- Returns `("", -1)` when the mode is inapplicable or exceeds the budget.
---@param module     Opts.StatusBar.Module
---@param parts      table
---@param mode       CellRenderMode
---@param avail_cols integer|nil
---@return string formatted
---@return integer width
local function build_cell_from_parts(module, parts, mode, avail_cols)
  local render_icon, render_text = CONTENT_RESOLVERS[mode](
    parts.icon_val,
    parts.text_val,
    parts.has_icon,
    parts.has_text,
    avail_cols,
    parts.overhead
  )

  if render_icon == nil then
    return "", -1
  end

  local total_w = parts.overhead + visible_width(render_icon) + visible_width(render_text)
  if avail_cols and total_w > avail_cols then
    return "", -1
  end

  local formatted = assemble_cell(
    module,
    render_icon,
    render_text,
    parts.icon_style,
    parts.text_style,
    parts.sep,
    parts.sep_style,
    parts.pad_left,
    parts.pad_right,
    parts.style
  )
  return formatted, total_w
end

-- ---------------------------------------------------------------------------

--- Render only the separator (and padding) for a module, with no icon or text.
--- Used as the last-resort candidate for `can_hide` modules so the colour
--- chain between adjacent cells is preserved even when content is dropped.
---
---@param  module Opts.StatusBar.Module
---@param  parts  table              pre-resolved cell parts
---@return string formatted
---@return integer width   0 when the module has no separator to show
local function build_cell_sep_only(module, parts)
  if not parts.sep.left and not parts.sep.right then
    return "", 0
  end

  local formatted = assemble_cell(
    module,
    "",
    "",
    parts.style,
    parts.style,
    parts.sep,
    parts.sep_style,
    parts.pad_left,
    parts.pad_right,
    parts.style
  )
  return formatted, parts.overhead
end

--- Attempt to build a cell for the given mode within `avail_cols`.
--- Convenience wrapper that resolves parts internally — use
--- `resolve_cell_parts` + `build_cell_from_parts` when calling in a loop.
---@param name       string
---@param module     Opts.StatusBar.Module
---@param mode       CellRenderMode
---@param avail_cols integer|nil
---@return string formatted
---@return integer width
local function build_cell(name, module, mode, avail_cols)
  return build_cell_from_parts(module, resolve_cell_parts(module), mode, avail_cols)
end

--- Walk the fallback chain and return the first mode that fits.
--- Resolves cell parts once and reuses across all mode trials.
---@param name       string
---@param module     Opts.StatusBar.Module
---@param avail_cols integer
---@return string formatted
---@return integer width
local function build_cell_flexible(name, module, avail_cols)
  local parts = resolve_cell_parts(module)
  for _, mode in ipairs(RENDER_MODES) do
    local result, w = build_cell_from_parts(module, parts, mode, avail_cols)
    if w >= 0 then
      log:info(
        "[%s] mode: %-4s  used: %d/%d  cell: %s",
        name,
        mode,
        w,
        avail_cols,
        result
      )
      return result, w
    end
  end

  if module.can_hide then
    log:info("[%s] hidden – no space remaining", name)
    return "", 0
  end

  -- Absolute last resort: force icon-only regardless of budget.
  local result, w = build_cell_from_parts(module, parts, "icon", nil)
  log:info("[%s] forced icon-only  width: %d  cell: %s", name, w, result)
  return result, math.max(w, 0)
end

--- Format a single cell.
--- When `Opts.flexible` and `avail_cols` are both set the fallback chain is
--- applied; otherwise the cell is rendered in "full" mode without a budget check.
---
---@param name       string
---@param module     Opts.StatusBar.Module
---@param avail_cols integer|nil
---@return string formatted
---@return integer width
M.format_cell = function(name, module, avail_cols)
  log:info(
    "[%s] icon: %s\ttext: %s",
    name,
    module.icon and tostring(module.icon.value) or "–",
    module.text and tostring(module.text.value) or "–"
  )

  if not Opts.flexible or not avail_cols then
    local result, w = build_cell(name, module, "full", nil)
    log:info("[%s] cell: %s", name, result)
    return result, w
  end

  return build_cell_flexible(name, module, avail_cols)
end

-- ---------------------------------------------------------------------------
-- Layout rendering
-- ---------------------------------------------------------------------------

--- Resolve a `module.layout` value to a plain string.
---
--- Handles all four forms defined by `Opts.StatusBar.Module.Layout`:
---   • `string`  → returned as-is
---   • `Layout`  → calls `:format()`
---   • `table`   → passed to `wezterm.format()`
---   • `fun(ctx) → string|table|Layout`  → called first, result normalised
---
---@param  layout Opts.StatusBar.Module.Layout
---@return string
local function resolve_layout(layout)
  if type(layout) == "function" then
    _layout_ctx.layout = require "utils.layout"
    _layout_ctx.theme = M.theme
    _layout_ctx.fn = require "utils.fn"
    _layout_ctx.window = M.window
    _layout_ctx.pane = M.pane
    layout = layout(_layout_ctx)
  end

  if type(layout) == "string" then
    return layout
  end

  -- Layout instance: has a callable :format() method.
  if type(layout) == "table" and type(layout.format) == "function" then
    return layout:format()
  end

  -- Raw FormatItem array.
  if type(layout) == "table" then
    return wt.format(layout)
  end

  return ""
end

--- Materialise the cartesian product of a list of candidate lists.
---@param lists {formatted:string, width:integer}[][]
---@return {formatted:string, width:integer}[][]
local function cartesian(lists)
  local result = { {} }
  for _, candidates in ipairs(lists) do
    local next_result = {}
    for _, existing in ipairs(result) do
      for _, candidate in ipairs(candidates) do
        local combo = { tunpack(existing) }
        combo[#combo + 1] = candidate
        next_result[#next_result + 1] = combo
      end
    end
    result = next_result
  end
  return result
end

--- For a group of module names, enumerate every representation of each module,
--- compute the full cartesian product, and return the widest combination whose
--- total width fits within `avail_cols`.
---
---@param  names      string[]
---@param  avail_cols integer
---@return string     formatted
---@return integer    consumed
local function render_group(names, avail_cols)
  local per_module = {} ---@type {formatted:string, width:integer}[][]

  for _, name in ipairs(names) do
    local module = Opts.modules[name]
    if type(module) == "function" then
      module = module(M.window, M.pane, M.theme, M.config)
    end

    if M.enabled(module) then
      local parts = resolve_cell_parts(module)
      local candidates = {}

      for _, mode in ipairs(RENDER_MODES) do
        local result, w = build_cell_from_parts(module, parts, mode, nil)
        if w >= 0 then
          candidates[#candidates + 1] = { formatted = result, width = w }
        end
      end

      if module.can_hide then
        local sep_fmt, sep_w = build_cell_sep_only(module, parts)
        candidates[#candidates + 1] = { formatted = sep_fmt, width = sep_w }
      end

      if #candidates > 0 then
        per_module[#per_module + 1] = candidates
      end
    end
  end

  if #per_module == 0 then
    return "", 0
  end

  local best_formatted = ""
  local best_width = -1

  for _, combo in ipairs(cartesian(per_module)) do
    local total = 0
    for _, item in ipairs(combo) do
      total = total + item.width
    end

    if total <= avail_cols and total > best_width then
      best_width = total
      local pieces = {}
      for _, item in ipairs(combo) do
        pieces[#pieces + 1] = item.formatted
      end
      best_formatted = table.concat(pieces)
    end
  end

  if best_width < 0 then
    log:info("[group] nothing fits in %d cols", avail_cols)
    return "", 0
  end

  log:info("[group] best fit  used: %d/%d", best_width, avail_cols)
  return best_formatted, best_width
end

--- Render one module and append to `components` when it produces output.
---
--- Handles two rendering paths:
---   1. `module.layout`    – arbitrary Layout / string / table / function;
---                           rendered via `resolve_layout` and measured for
---                           the flexible-width budget.
---   2. `module.icon/text` – structured cell rendered by `format_cell` with
---                           the full fallback chain.
---
---@param name       string
---@param module     Opts.StatusBar.Module
---@param components string[]
local function render_module(name, module, components)
  local formatted = ""
  local consumed = 0

  if module.layout then
    formatted = resolve_layout(module.layout)
    consumed = str.column_width(formatted)

    -- Respect the budget: if the resolved layout is too wide and the module
    -- allows hiding, drop it rather than overflowing.
    if Opts.flexible then
      local avail = M.width.available - M.width.used
      if consumed > avail then
        if module.can_hide then
          return
        end
        log:warn("[%s] layout overflows by %d cols (no can_hide)", name, consumed - avail)
      end
    end
  elseif module.icon or module.text then
    local avail = Opts.flexible and (M.width.available - M.width.used) or nil
    formatted, consumed = M.format_cell(name, module, avail)
  end

  if formatted == "" then
    return
  end

  components[#components + 1] = formatted
  if Opts.flexible then
    M.width.used = M.width.used + consumed
  end
end

M.render_layout = function(layout)
  local components = {}

  for i = 1, #layout do
    local entry = layout[i]

    if type(entry) == "table" then
      -- ── Sub-layout group: best-fit cartesian selection ──────────────────
      local avail = Opts.flexible and (M.width.available - M.width.used) or math.huge
      local formatted, consumed = render_group(entry, avail)
      if formatted ~= "" then
        components[#components + 1] = formatted
        if Opts.flexible then
          M.width.used = M.width.used + consumed
        end
      end
    else
      -- ── Single named module: existing path ───────────────────────────────
      local name = entry
      local module = Opts.modules[name]
      log:info("name %s", name)

      if type(module) == "function" then
        module = module(M.window, M.pane, M.theme, M.config)
      end

      if M.enabled(module) then
        render_module(name, module, components)
      end
    end
  end

  return table.concat(components)
end

return M

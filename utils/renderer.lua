---@module 'utils.renderer'

local conditions = require "utils.conditions" ---@class Conditions
local budget = require "utils.bar-budget" ---@class BarBudget
local ribbon = require "plugs.ribbon" ---@class Ribbon.Api
local warp = require "plugs.warp" ---@class Warp.Api
local wt = require "wezterm" ---@class Wezterm
local merge = warp.table.merge
local str = warp.string ---@class Warp.String

-- Direct binding to the Rust function. This bypasses the ANSI-stripping regex in
-- str.width, which is safe here because this layer only measures plain text:
-- icons, separators, padding, and resolved node values. Use str.width for
-- strings that may contain ANSI codes, such as resolve_layout output.
local raw_cw = wt.column_width
local find = string.find

local Opts = require("opts").statusbar ---@class Opts.StatusBar
local log = require("plugs.log").new("StatusBar", true) ---@class Logger

---@class Renderer
local M = {
  window = nil,
  pane = nil,
  theme = nil,
  config = nil,
  width = { used = 0, available = 0 },
}

-- Reusable Ribbon cell for assemble_cell. It avoids one Ribbon allocation per
-- cell render and is cleared with :clear() before each use.
local _cell = ribbon:new "Cell"

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
  local width = (find(s, "\27", 1, true) or find(ellipsis, "\27", 1, true))
      and str.width
    or visible_width
  if width(s) <= max_cols then
    return s
  end

  local ew = width(ellipsis)
  local result, w = {}, 0
  for cp in s:gmatch "[^\128-\191][\128-\191]*" do
    local cpw = width(cp)
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

  -- Publish total screen width once per cycle so that
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
---This is the single synchronization point between the two halves of the
---status bar. It performs four updates atomically:
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

---@param mod Opts.StatusBar.Module|Opts.StatusBar.Module.Component|nil
---@return boolean
M.enabled = function(mod)
  return mod ~= nil
    and mod.enabled == true
    and conditions.predicate(mod.cond, M.window, M.pane) == true
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
    return merge({ behavior = "force", combine = true }, node.style, style)
  end
  return style
end

M.resolve_node = function(node)
  if not node or not node.enabled then
    return ""
  end

  local value = type(node.value) == "function" and node.value(M.window, M.pane)
    or node.value
  local typ = type(value)

  if typ == "table" then
    return value
  end
  return str.pad(value, node.padding or 0)
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

--- Assemble a Ribbon cell from pre-resolved content.
---
--- Uses the module-level `_cell` instance (cleared on each call) to avoid
--- allocating a new Ribbon per cell render.
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
--- for each render-mode trial - avoiding redundant style / content / sep
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
--- Convenience wrapper that resolves parts internally - use
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
--- Resolve cell parts once, then reuse them for every mode trial.
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
      log:debug(
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
    log:debug("[%s] hidden - no space remaining", name)
    return "", 0
  end

  -- Last resort: force icon-only even when it exceeds the budget.
  local result, w = build_cell_from_parts(module, parts, "icon", nil)
  log:debug("[%s] forced icon-only  width: %d  cell: %s", name, w, result)
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
  log:debug(
    "[%s] icon: %s\ttext: %s",
    name,
    module.icon and tostring(module.icon.value) or "-",
    module.text and tostring(module.text.value) or "-"
  )

  if not Opts.flexible or not avail_cols then
    local result, w = build_cell(name, module, "full", nil)
    log:debug("[%s] cell: %s", name, result)
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
---   • `Ribbon`  → calls `:format()`
---   • `table`   → passed to `wezterm.format()`
---   • `fun(ctx) → string|table|Ribbon`  → called first, result normalised
---
---@param  layout Opts.StatusBar.Module.Layout
---@return string
local function resolve_layout(layout)
  if type(layout) == "function" then
    _layout_ctx.layout = ribbon
    _layout_ctx.theme = M.theme
    _layout_ctx.warp = warp
    _layout_ctx.window = M.window
    _layout_ctx.pane = M.pane
    layout = layout(_layout_ctx)
  end

  if type(layout) == "string" then
    return layout
  end

  -- Ribbon instance: has a callable :format() method.
  if type(layout) == "table" and type(layout.format) == "function" then
    return layout:format()
  end

  -- Raw FormatItem array.
  if type(layout) == "table" then
    return wt.format(layout)
  end

  return ""
end

--- For a group of module names, greedily pick the widest representation of
--- each module that fits within the remaining budget (left-to-right).
--- O(n × m) where n = modules and m = render modes, instead of O(m^n).
---
---@param  names      string[]
---@param  avail_cols integer
---@return string     formatted
---@return integer    consumed
local function render_group_greedy(names, avail_cols)
  local remaining = avail_cols
  local components = {}
  local total_used = 0

  for _, name in ipairs(names) do
    local module = Opts.modules[name]
    if type(module) == "function" then
      module = module(M.window, M.pane, M.theme, M.config)
    end

    if M.enabled(module) then
      local parts = resolve_cell_parts(module)
      local best_fmt, best_w = "", -1

      -- Try modes from widest to narrowest; first fit wins.
      for _, mode in ipairs(RENDER_MODES) do
        local result, w = build_cell_from_parts(module, parts, mode, remaining)
        if w >= 0 then
          best_fmt, best_w = result, w
          break
        end
      end

      -- can_hide fallback: separator only
      if best_w < 0 and module.can_hide then
        best_fmt, best_w = build_cell_sep_only(module, parts)
      end

      if best_w >= 0 then
        components[#components + 1] = best_fmt
        remaining = remaining - best_w
        total_used = total_used + best_w
      end
    end
  end

  if #components == 0 then
    log:debug("[group] nothing fits in %d cols", avail_cols)
    return "", 0
  end

  log:debug("[group] greedy fit  used: %d/%d", total_used, avail_cols)
  return table.concat(components), total_used
end

-- ── Group fitting: balanced / exhaustive ─────────────────────────────────────

local DEFAULT_MIN_TEXT = 5
local INFO_EPS = 1e-6
-- A truncated text is worth less than its length suggests (the ellipsis and the
-- cut-off part hide the identity of the value).
local TRIM_PENALTY = 0.25

---@param  t    integer shown text columns (ellipsis included)
---@param  full integer full text columns
---@return number
local function trim_info(t, full)
  return math.max(0, (t - 1) / full - TRIM_PENALTY)
end

---@class GroupCandidate
---@field fmt   string
---@field w     integer  total columns
---@field texty boolean  shows (part of) the text
---@field info  number   fraction of the full text conveyed (0..1)

---@class GroupTrim
---@field base integer  columns used by everything except the text
---@field min  integer  minimum text columns
---@field max  integer  maximum text columns (one less than the full text)
---@field full integer  full text columns

---@class GroupEntry
---@field name     string
---@field module   Opts.StatusBar.Module
---@field parts    table
---@field icon     string
---@field text     string
---@field index    integer
---@field priority number
---@field cands    GroupCandidate[]  fixed-width forms, widest first
---@field trim     GroupTrim|nil     variable-width truncated form
---@field min      GroupCandidate
---@field hidden   GroupCandidate
---@field cur      GroupCandidate
---@field visible  boolean

--- Resolve `text.variants` (shorter alternatives, longest first) to padded strings.
---@param  node Opts.StatusBar.Module.Text|nil
---@return string[]
local function resolve_variants(node)
  local out = {}
  if not node or not node.enabled or type(node.variants) ~= "table" then
    return out
  end
  for _, v in ipairs(node.variants) do
    local s = M.resolve_node { enabled = true, value = v, padding = node.padding }
    if type(s) == "string" and s ~= "" then
      out[#out + 1] = s
    end
  end
  return out
end

---@param  e GroupEntry
---@param  t integer text columns
---@return GroupCandidate
local function build_trim(e, t)
  local text = truncate(e.text, t)
  return {
    icon = e.icon,
    text = text,
    w = e.trim.base + visible_width(text),
    texty = true,
    info = trim_info(t, e.trim.full),
  }
end

--- Resolve every enabled module of a group into its candidate forms: full,
--- shorter `text.variants`, icon-only, a variable-width truncation (unless
--- `text.trim == false`) and hidden.
---@param  names string[]
---@return GroupEntry[]
local function collect_entries(names)
  local entries = {}
  for idx, name in ipairs(names) do
    local module = Opts.modules[name]
    if type(module) == "function" then
      module = module(M.window, M.pane, M.theme, M.config)
    end

    if M.enabled(module) then
      local parts = resolve_cell_parts(module)
      local icon = type(parts.icon_val) == "string" and parts.icon_val or ""
      local text = type(parts.text_val) == "string" and parts.text_val or ""
      local has_icon, has_text = icon ~= "", text ~= ""
      local full_w = visible_width(text)

      local cands = {}
      local function add(i, t, info)
        cands[#cands + 1] = {
          icon = i,
          text = t,
          w = parts.overhead + visible_width(i) + visible_width(t),
          texty = t ~= "",
          info = info,
        }
      end

      if has_text then
        add(icon, text, 1)
        for _, v in ipairs(resolve_variants(module.text)) do
          local vw = visible_width(v)
          if vw < full_w then
            add(icon, v, vw / full_w)
          end
        end
      end
      if has_icon or not has_text then
        add(icon, "", 0)
      end
      table.sort(cands, function(a, b)
        if a.w ~= b.w then
          return a.w > b.w
        end
        return a.info > b.info
      end)

      local trim
      local min_text = module.min_text or DEFAULT_MIN_TEXT
      if has_text and module.text.trim ~= false and full_w - 1 >= min_text then
        trim = {
          base = parts.overhead + visible_width(icon),
          min = min_text,
          max = full_w - 1,
          full = full_w,
        }
      end

      local hidden
      if module.can_hide then
        local sep_only = parts.sep.left ~= nil or parts.sep.right ~= nil
        hidden = {
          fmt = not sep_only and "" or nil,
          sep_only = sep_only,
          w = sep_only and parts.overhead or 0,
          texty = false,
          info = 0,
        }
      else
        hidden = { fmt = "", w = 0, texty = false, info = 0 }
      end

      local entry = {
        name = name,
        module = module,
        parts = parts,
        icon = icon,
        text = text,
        index = idx,
        priority = module.priority or 0,
        cands = cands,
        trim = trim,
        min = cands[#cands],
        hidden = hidden,
        visible = true,
      }
      entry.cur = entry.min
      entry.has_text_candidate = has_text
      entries[#entries + 1] = entry
    end
  end
  return entries
end

---@param  entries GroupEntry[]
---@return integer
local function entries_width(entries)
  local total = 0
  for _, e in ipairs(entries) do
    total = total + e.cur.w
  end
  return total
end

--- Hand leftover columns to visible modules by priority (desc), then layout
--- order. Each module takes its widest form that fits: full, a shorter
--- variant, or a truncation showing at least `min_text` text columns.
---@param  entries  GroupEntry[]
---@param  leftover integer
---@return integer  leftover
local function grow_entries(entries, leftover)
  local order = {}
  for _, e in ipairs(entries) do
    if e.visible then
      order[#order + 1] = e
    end
  end
  table.sort(order, function(a, b)
    if a.priority ~= b.priority then
      return a.priority > b.priority
    end
    return a.index < b.index
  end)

  for _, e in ipairs(order) do
    if leftover <= 0 then
      break
    end
    local limit = e.cur.w + leftover
    local best = e.cur
    for _, c in ipairs(e.cands) do
      if c.w <= limit then
        if c.w > best.w then
          best = c
        end
        break
      end
    end
    if e.trim then
      local t = math.min(e.trim.max, limit - e.trim.base)
      if t >= e.trim.min and e.trim.base + t > best.w then
        best = build_trim(e, t)
      end
    end
    leftover = leftover - (best.w - e.cur.w)
    e.cur = best
  end
  return leftover
end

---@param  entries GroupEntry[]
---@return string
local function join_entries(entries)
  local out = {}
  for _, e in ipairs(entries) do
    local candidate = e.cur
    if candidate.fmt == nil then
      if candidate.sep_only then
        candidate.fmt = build_cell_sep_only(e.module, e.parts)
      else
        candidate.fmt = assemble_cell(
          e.module,
          candidate.icon,
          candidate.text,
          e.parts.icon_style,
          e.parts.text_style,
          e.parts.sep,
          e.parts.sep_style,
          e.parts.pad_left,
          e.parts.pad_right,
          e.parts.style
        )
      end
    end
    if candidate.fmt ~= "" then
      out[#out + 1] = candidate.fmt
    end
  end
  return table.concat(out)
end

--- Shrink every module to its minimum before hiding anything. Modules are
--- hidden only when all minimums still overflow: `can_hide` modules first,
--- then lowest priority, then rightmost. Leftover space is redistributed by
--- priority.
---@param  names      string[]
---@param  avail_cols integer
---@return string     formatted
---@return integer    consumed
local function render_group_balanced(names, avail_cols)
  local entries = collect_entries(names)
  local total = entries_width(entries)
  local hide_order = {}
  for _, entry in ipairs(entries) do
    hide_order[#hide_order + 1] = entry
  end
  table.sort(hide_order, function(a, b)
    local a_hideable, b_hideable = a.module.can_hide == true, b.module.can_hide == true
    if a_hideable ~= b_hideable then
      return a_hideable
    end
    if a.priority ~= b.priority then
      return a.priority < b.priority
    end
    return a.index > b.index
  end)

  for _, victim in ipairs(hide_order) do
    if total <= avail_cols then
      break
    end
    victim.visible = false
    total = total - victim.cur.w + victim.hidden.w
    victim.cur = victim.hidden
    log:debug("[group] hiding %s", victim.name)
  end

  grow_entries(entries, avail_cols - total)
  local used = entries_width(entries)
  log:debug("[group] balanced fit  used: %d/%d", used, avail_cols)
  return join_entries(entries), used
end

--- Compare two ascending-sorted info vectors lexicographically (leximin).
---@param  a number[]
---@param  b number[]
---@return integer  1 when `a` is fairer, -1 when `b` is, 0 when equal
local function leximin_cmp(a, b)
  for k = 1, math.max(#a, #b) do
    local x, y = a[k] or -1, b[k] or -1
    if math.abs(x - y) > INFO_EPS then
      return x > y and 1 or -1
    end
  end
  return 0
end

--- Search every combination of candidate forms and keep the one preserving
--- the most information, compared in order:
---   1. visible modules
---   2. modules showing (part of) their text
---   3. fairness (leximin): the module showing the smallest fraction of its
---      text is compared first, then the next one, and so on - so cells grow
---      together instead of one filling up while another stays short
---   4. total width
--- Truncated forms absorb the leftover columns of each combination one column
--- at a time, always to the one currently showing the least.
---@param  names      string[]
---@param  avail_cols integer
---@return string     formatted
---@return integer    consumed
local function render_group_exhaustive(names, avail_cols)
  local entries = collect_entries(names)
  local n = #entries

  local full_width = 0
  for _, entry in ipairs(entries) do
    full_width = full_width + entry.cands[1].w
  end
  if full_width <= avail_cols then
    for _, entry in ipairs(entries) do
      entry.cur = entry.cands[1]
    end
    local used = entries_width(entries)
    return join_entries(entries), used
  end

  local pick, trims, infos = {}, {}, {}
  local best, best_alloc, best_vec
  local bv, bt, bw = -1, -1, -1
  local alloc, cur, vec = {}, {}, {}
  local upper_vectors = {}
  local suffix_text_candidates = {}
  suffix_text_candidates[n + 1] = 0
  for i = n, 1, -1 do
    suffix_text_candidates[i] = suffix_text_candidates[i + 1]
      + (entries[i].has_text_candidate and 1 or 0)
  end

  local function leaf(width, visible, texty)
    local leftover = avail_cols - width
    for i = #vec, 1, -1 do
      vec[i] = nil
    end
    for _, idx in ipairs(trims) do
      alloc[idx] = entries[idx].trim.min
      cur[idx] = trim_info(alloc[idx], entries[idx].trim.full)
    end
    while leftover > 0 do
      local low
      for _, idx in ipairs(trims) do
        if alloc[idx] < entries[idx].trim.max and (not low or cur[idx] < cur[low]) then
          low = idx
        end
      end
      if not low then
        break
      end
      alloc[low] = alloc[low] + 1
      cur[low] = trim_info(alloc[low], entries[low].trim.full)
      leftover = leftover - 1
    end
    local used = avail_cols - leftover

    for i = 1, n do
      if infos[i] then
        vec[#vec + 1] = infos[i]
      end
    end
    for _, idx in ipairs(trims) do
      vec[#vec + 1] = cur[idx]
    end
    table.sort(vec)

    local better
    if visible ~= bv then
      better = visible > bv
    elseif texty ~= bt then
      better = texty > bt
    else
      local c = leximin_cmp(vec, best_vec)
      better = c > 0 or (c == 0 and used > bw)
    end
    if better then
      bv, bt, bw, best_vec = visible, texty, used, vec
      best, best_alloc, best_vec = {}, {}, {}
      for i = 1, n do
        best[i] = pick[i]
      end
      for _, idx in ipairs(trims) do
        best_alloc[idx] = alloc[idx]
      end
      for i = 1, #vec do
        best_vec[i] = vec[i]
      end
    end
  end

  local function search(i, width, visible, texty)
    if width > avail_cols then
      return
    end
    if best then
      local max_visible = visible + n - i + 1
      if max_visible < bv then
        return
      end
      local max_texty = texty + suffix_text_candidates[i]
      if max_visible == bv and max_texty < bt then
        return
      end
      if max_visible == bv and max_texty == bt then
        local bound = upper_vectors[i]
        if not bound then
          bound = {}
          upper_vectors[i] = bound
        else
          for j = #bound, 1, -1 do
            bound[j] = nil
          end
        end
        for j = 1, i - 1 do
          local selected = pick[j]
          if selected == "trim" then
            local trim = entries[j].trim
            bound[#bound + 1] = trim_info(trim.max, trim.full)
          elseif type(selected) == "table" and selected.texty then
            bound[#bound + 1] = selected.info
          end
        end
        for j = i, n do
          if entries[j].has_text_candidate then
            bound[#bound + 1] = 1
          end
        end
        table.sort(bound)
        local comparison = leximin_cmp(bound, best_vec)
        if comparison < 0 or (comparison == 0 and avail_cols <= bw) then
          return
        end
      end
    end
    if i > n then
      return leaf(width, visible, texty)
    end
    local e = entries[i]
    for _, c in ipairs(e.cands) do
      pick[i], infos[i] = c, c.info
      search(i + 1, width + c.w, visible + 1, texty + (c.texty and 1 or 0))
    end
    if e.trim then
      pick[i], infos[i] = "trim", nil
      trims[#trims + 1] = i
      search(i + 1, width + e.trim.base + e.trim.min, visible + 1, texty + 1)
      trims[#trims] = nil
    end
    pick[i], infos[i] = e.hidden, nil
    search(i + 1, width + e.hidden.w, visible, texty)
    infos[i] = nil
  end

  search(1, 0, 0, 0)

  if not best then
    return render_group_balanced(names, avail_cols)
  end

  for i, e in ipairs(entries) do
    if best[i] == "trim" then
      e.cur, e.visible = build_trim(e, best_alloc[i]), true
    else
      e.cur, e.visible = best[i], best[i] ~= e.hidden
    end
  end
  local used = entries_width(entries)
  log:debug("[group] exhaustive fit  used: %d/%d", used, avail_cols)
  return join_entries(entries), used
end

local GROUP_STRATEGIES = {
  greedy = render_group_greedy,
  balanced = render_group_balanced,
  exhaustive = render_group_exhaustive,
}

---@param  names      string[]
---@param  avail_cols integer
---@return string     formatted
---@return integer    consumed
local function render_group(names, avail_cols)
  local strategy = GROUP_STRATEGIES[Opts.fit or "balanced"] or render_group_balanced
  return strategy(names, avail_cols)
end

--- Render one module and append to `components` when it produces output.
---
--- Handles two rendering paths:
---   1. `module.layout`    - arbitrary Ribbon / string / table / function;
---                           rendered via `resolve_layout` and measured for
---                           the flexible-width budget.
---   2. `module.icon/text` - structured cell rendered by `format_cell` with
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
    consumed = str.width(formatted)

    -- Respect the budget. If the resolved layout is too wide and the module
    -- can be hidden, drop it instead of overflowing.
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
      -- ── Sub-layout group: fitted by `Opts.fit` strategy ─────────────────
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
      log:debug("name %s", name)

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

---@module "events.format-tab-title"

local Icon = require "utils.icons" ---@class Icons
local Layout = require "utils.layout" ---@class Layout
local fs = require "utils.fn.fs" ---@class Fn.FileSystem
local str = require "utils.fn.str" ---@class Fn.String
local budget = require "utils.bar-budget" ---@class BarBudget
local wt = require "wezterm" ---@class Wezterm

local tabseps = Icon.Sep.tb

local SHELLS = { fish = true, bash = true, zsh = true, sh = true, nu = true }

-- Hoisted to module scope — the home directory never changes during a session.
-- Avoids per-tab-per-repaint calls through the (previously broken) cache layer.
local HOME = fs.home()
local HOME_BASENAME = fs.basename(HOME)

local function truncate(text, budget, callback)
  if str.column_width(text) <= budget then
    return text
  end

  return budget <= 1 and "" or callback(text, budget)
end

--- Helper to safely truncate a string with an ellipsis if it exceeds the budget
local function truncate_with_ellipsis(text, budget)
  return wt.truncate_right(text, budget) .. "…"
end

local function parse_title(title)
  local rest_candidate, proc_candidate = title:match "^(.-)%s*%-%s*(%S+)$"
  if proc_candidate and Icon.Progs[proc_candidate] then
    return proc_candidate, rest_candidate
  else
    local proc_candidate2, rest_candidate2 = title:match "^(%S+)%s*%-?%s*(.*)$"
    if proc_candidate2 and Icon.Progs[proc_candidate2] then
      return proc_candidate2, rest_candidate2
    end
  end
end

local function format_shell(process, rest, title_budget)
  local cwd = (rest and rest ~= "") and rest or "~"

  local prefix = (Icon.Progs[process] or "") .. " in "
  local prefix_width = str.column_width(prefix)

  cwd = truncate(cwd, title_budget - prefix_width, fs.shorten_path_to_fit)
  return prefix .. cwd
end

local function format_neovim(pane, title_budget)
  local cwd_url = pane.current_working_dir or pane:get_current_working_dir()
  local cwd = cwd_url and fs.basename(cwd_url.file_path) or ""
  cwd = cwd:gsub(HOME_BASENAME, "󰋜 ")

  local prefix = (Icon.Progs["nvim"] or "") .. " (" .. Icon.Folder .. " "
  local suffix = ")"
  local decoration_width = str.column_width(prefix .. suffix)

  cwd = truncate(cwd, title_budget - decoration_width, truncate_with_ellipsis)
  return prefix .. cwd .. suffix
end

--- Convert a raw pane/tab title into a display string.
---@param pane        table    active pane object
---@param raw_title   string   title from tab or active pane
---@param title_budget integer maximum cells available for the title text alone
---@return string
local function resolve_title(pane, raw_title, title_budget)
  local title = raw_title:gsub("^Copy mode: ", "")
  title = title:gsub("^" .. HOME, "~"):gsub(HOME_BASENAME, "󰋜 ")

  local process, rest = parse_title(title)

  -- Shell special treatment
  if process and SHELLS[process] then
    return format_shell(process, rest, title_budget)
  end

  -- Neovim special treatment
  local proc = (pane.foreground_process_name or pane:get_foreground_process_name() or "")
  if proc:match "nvim$" then
    return format_neovim(pane, title_budget)
  end

  -- Default treatment
  if process then
    title = (Icon.Progs[process] or "") .. " " .. (rest or "")
  end

  return truncate(title, title_budget, truncate_with_ellipsis)
end

-- ---------------------------------------------------------------------------
-- Event
-- ---------------------------------------------------------------------------

wt.on("format-tab-title", function(tab, tabs, _, config, hover, max_width)
  if config.use_fancy_tab_bar or not config.enable_tab_bar then
    return ""
  end

  local theme = config.color_schemes[config.color_scheme]
  local bg = theme.tab_bar.background
  local fg, attributes
  local idx = tab.tab_index

  if tab.is_active then
    fg, attributes = theme.ansi[5], {}
  elseif hover then
    fg, attributes = theme.tab_bar.inactive_tab_hover.bg_color, {}
  else
    fg, attributes = theme.brights[1], {}
  end

  local unseen = false
  for _, p in ipairs(tab.panes) do
    if p.has_unseen_output then
      unseen = true
      break
    end
  end

  local pane = tab.active_pane
  local raw_title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or pane.title
  local tab_idx = (unseen and Icon.Notification or Icon.Nums[idx + 1] or "")
  local left_sep = idx == 0 and tabseps.leftmost or tabseps.left
  local right_sep = Icon.Sep.block .. tabseps.right

  -- ── Calculate exact budget for the title text ────────────────────────────
  -- Measure exactly how much space the separators, spaces, and tab indices take
  local static_decorations = left_sep .. " " .. tab_idx .. " " .. right_sep
  local static_width = str.column_width(static_decorations)

  -- Prevent negative budgets if max_width is extremely squeezed
  local title_budget = math.max(0, max_width - static_width)

  -- Pass the accurate budget to the resolver
  local title = resolve_title(pane, raw_title, title_budget)
  -- ─────────────────────────────────────────────────────────────────────────

  local cell = Layout:new "TabTitle"
  cell:append(bg, fg, left_sep, attributes)
  cell:append(fg, fg, " ", nil)
  cell:append(fg, bg, tab_idx .. " ", attributes)
  cell:append(fg, bg, title, attributes)
  cell:append(bg, fg, right_sep, attributes)

  local rendered = cell:format()

  -- Pass pre-computed width (plain-text parts sum) so `record()` skips the
  -- expensive ANSI-strip + column_width call on the full rendered string.
  budget.record(idx, static_width + str.width(title))
  budget.set_count(#tabs)

  return rendered
end)

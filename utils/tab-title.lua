---@module "utils.tab-title"

-- Tab title rules (Copilot, shells, Neovim) used as mosaic's `tabs.title`
-- hook: `fun(tab, max_cells): string`. mosaic draws the rest of the tab.

local Opts = require("opts").tabtitle ---@class Opts.TabTitle
local sigil = require "plugs.sigil" ---@class Sigil.Api
local warp = require "plugs.warp" ---@class Warp.Api
local fs = warp.filesystem ---@class Warp.FileSystem
local str = warp.string ---@class Warp.String

local Icon = sigil.symbols()

local SHELLS = {
  fish = true,
  bash = true,
  zsh = true,
  sh = true,
  nu = true,
  pwsh = true,
  powershell = true,
  cmd = true,
}

-- Hoisted to module scope - the home directory never changes during a session.
-- Avoids per-tab-per-repaint calls through the (previously broken) cache layer.
local HOME = fs.home
local HOME_BASENAME = fs.basename(HOME)

local function has_process_icon(process)
  return sigil.get(process, { fallback = false }) ~= nil
end

local function process_icon(process)
  return sigil.icon(process, { fallback = false }) or ""
end

local function truncate(text, max_cells, kind)
  if str.fits(text, max_cells) then
    return text
  end
  if max_cells <= 1 then
    return ""
  end

  local mode = Opts.truncate and Opts.truncate[kind] or "right"
  return str.truncate(mode, text, max_cells)
end

local function format_copilot_idle(pane, title_budget)
  local cwd_url = pane.current_working_dir or pane:get_current_working_dir()
  local cwd = (cwd_url and cwd_url.file_path) or "~"
  cwd = cwd:gsub("^" .. HOME, "~"):gsub(HOME_BASENAME, "󰋜 ")

  local icon = process_icon "GitHub Copilot"
  local prefix = icon .. " (" .. Icon.Folder .. " "
  local suffix = ")"
  local decoration_width = str.width(prefix .. suffix)

  cwd = truncate(cwd, title_budget - decoration_width, "copilot_idle")
  return prefix .. cwd .. suffix
end

local function format_copilot_chat(title, title_budget)
  local chat_title =
    title:gsub("^🤖%s*[-:]*%s*", ""):gsub("^GitHub Copilot%s*[-:]*%s*", "")

  if chat_title == "" then
    chat_title = "GitHub Copilot"
  end

  local icon = process_icon "GitHub Copilot"
  local prefix = icon .. " "

  chat_title = truncate(chat_title, title_budget - str.width(prefix), "copilot_chat")
  return prefix .. chat_title
end

local function parse_title(title)
  local rest_candidate, proc_candidate = title:match "^(.-)%s*%-%s*(%S+)$"
  if proc_candidate and has_process_icon(proc_candidate) then
    return proc_candidate, rest_candidate
  else
    local proc_candidate2, rest_candidate2 = title:match "^(%S+)%s*%-?%s*(.*)$"
    if proc_candidate2 and has_process_icon(proc_candidate2) then
      return proc_candidate2, rest_candidate2
    end
  end
end

local function format_shell(process, rest, title_budget)
  local cwd = (rest and rest ~= "") and rest or "~"
  cwd = cwd:gsub("^in%s+", "")
  if cwd == "" then
    cwd = "~"
  end

  local prefix = process_icon(process) .. " in "
  local prefix_width = str.width(prefix)

  cwd = truncate(cwd, title_budget - prefix_width, "shell")
  return prefix .. cwd
end

local function format_neovim(pane, title_budget)
  local cwd_url = pane.current_working_dir or pane:get_current_working_dir()
  local cwd = cwd_url and fs.basename(cwd_url.file_path) or ""
  cwd = cwd:gsub(HOME_BASENAME, "󰋜 ")

  local prefix = process_icon("nvim") .. " (" .. Icon.Folder .. " "
  local suffix = ")"
  local decoration_width = str.width(prefix .. suffix)

  cwd = truncate(cwd, title_budget - decoration_width, "neovim")
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

  -- GitHub Copilot idle pane title.
  if title == "GitHub Copilot" then
    return format_copilot_idle(pane, title_budget)
  end

  -- GitHub Copilot job/session title (usually starts with the robot emoji).
  if title:match "^🤖" or title:match "^GitHub Copilot%s*[-:]" then
    return format_copilot_chat(title, title_budget)
  end

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
    title = process_icon(process) .. " " .. (rest or "")
  end

  return truncate(title, title_budget, "default")
end

---@param  tab       table   TabInformation
---@param  max_cells integer columns available for the title
---@return string
return function(tab, max_cells)
  local pane = tab.active_pane
  local raw_title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or pane.title
  return resolve_title(pane, raw_title, max_cells)
end

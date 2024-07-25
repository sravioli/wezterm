---@diagnostic disable: undefined-field

local wt = require "wezterm"

local Utils = require "utils"

local fs = Utils.fn.fs
local Icon = Utils.class.icon
local tabicons = Icon.Sep.tb

wt.on("format-tab-title", function(tab, _, _, config, hover, max_width)
  if config.use_fancy_tab_bar or not config.enable_tab_bar then
    return
  end

  local theme = config.color_schemes[config.color_scheme]
  local bg = theme.tab_bar.background
  local fg

  local Title = Utils.class.layout:new() ---@class Layout

  local pane, tab_idx = tab.active_pane, tab.tab_index
  local attributes = {}

  ---set colors based on states
  if tab.is_active then
    fg = theme.ansi[5]
    attributes = { "Bold" }
  elseif hover then
    fg = theme.tab_bar.inactive_tab_hover.bg_color
  else
    fg = theme.brights[1]
  end

  ---Check if any pane has unseen output
  local unseen_output = false
  for _, p in ipairs(tab.panes) do
    if p.has_unseen_output then
      unseen_output = true
      break
    end
  end

  local title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title
    or tab.active_pane.title
  local process, other = title:match "^(%S+)%s*%-?%s*%s*(.*)$"

  if Icon.Progs[process] then
    title = Icon.Progs[process] .. " " .. (other or "")
  end

  local proc = pane.foreground_process_name
  if proc:find "nvim" then
    proc = proc:sub(proc:find "nvim")
  end
  local is_truncation_needed = true
  if proc == "nvim" then
    ---full title truncation is not necessary since the dir name will be truncated
    is_truncation_needed = false
    local cwd = fs.basename(pane.current_working_dir.file_path)

    ---instead of truncating the whole title, truncate to length the cwd to ensure that the
    ---right parenthesis always closes.
    if max_width == config.tab_max_width then
      cwd = wt.truncate_right(cwd, max_width - 14) .. "..."
    end

    title = ("%s ( %s)"):format(Icon.Progs[proc], cwd)
  end

  title = title:gsub(fs.basename(fs.home()), "󰋜 ")

  ---truncate the tab title when it overflows the maximum available space, then concatenate
  ---some dots to indicate the occurred truncation
  if is_truncation_needed and max_width == config.tab_max_width then
    title = wt.truncate_right(title, max_width - 8) .. "..."
  end

  ---add the either the leftmost element or the normal left separator. This is done to
  ---esure a bit of space from the left margin.
  Title:push(bg, fg, tab_idx == 0 and tabicons.leftmost or tabicons.left, attributes)

  ---add the tab number. can be substituted by the `has_unseen_output` notification
  Title:push(
    fg,
    bg,
    (unseen_output and Icon.Notification or Icon.Nums[tab_idx + 1] or "") .. " ",
    attributes
  )

  ---the formatted tab title
  Title:push(fg, bg, title, attributes)

  ---the right tab bar separator
  Title:push(bg, fg, Icon.Sep.block .. tabicons.right, attributes)

  return Title
end)

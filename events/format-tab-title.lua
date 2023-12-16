local wez = require "wezterm" ---@class WezTerm
local fun = require "utils.fun" ---@class Fun
local icons = require "utils.icons" ---@class Icons
local tabicons = icons.Separators.TabBar ---@class TabBarIcons

wez.on("format-tab-title", function(tab, _, _, config, hover, max_width)
  if config.use_fancy_tab_bar or not config.enable_tab_bar then
    return
  end

  local theme = require("colors")[fun.get_scheme()]
  local bg = theme.tab_bar.background
  local fg

  local TabTitle = require("utils.layout"):new() ---@class Layout

  local pane, tab_idx = tab.active_pane, tab.tab_index
  local attributes = {}

  ---set colors based on states
  if tab.is_active then
    fg = theme.ansi[5]
    attributes = { "Bold" }
  elseif hover then
    fg = theme.selection_bg
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

  ---get pane title, remove any `.exe` from the title, swap `Administrator` for the desired
  ---icon, swap `pwsh` and `bash` for their icons
  local title = fun
    .basename(pane.title)
    :gsub("%.exe%s?$", "")
    :gsub("^Administrator: %w+", icons.Admin)
    :gsub("pwsh", icons.Pwsh)
    :gsub("bash", icons.Bash)
    :gsub("Copy mode: ", "")

  local proc = pane.foreground_process_name
  if proc:find "nvim" then
    proc = proc:sub(proc:find "nvim")
  end
  local is_truncation_needed = true
  ---HACK: running nvim somehow causes the tab title to become cmd. (don't use cmd
  ---      so it's safe for me)
  if proc == "nvim" or title == "cmd" then
    ---full title truncation is not necessary since the dir name will be truncated
    is_truncation_needed = false
    local cwd = fun.basename(pane.current_working_dir.file_path)

    ---instead of truncating the whole title, truncate to length the cwd to ensure that the
    ---right parenthesis always closes.
    if max_width == config.tab_max_width then
      cwd = wez.truncate_right(cwd, max_width - 14) .. "..."
    end

    title = ("%s ( %s)"):format(icons.Vim, cwd)
  end
  title = title:gsub(fun.basename(fun.home), "󰋜 ")

  ---truncate the tab title when it overflows the maximum available space, then concatenate
  ---some dots to indicate the occurred truncation
  if is_truncation_needed and max_width == config.tab_max_width then
    title = wez.truncate_right(title, max_width - 8) .. "..."
  end

  ---add the either the leftmost element or the normal left separator. This is done to
  ---esure a bit of space from the left margin.
  TabTitle:push(bg, fg, tab_idx == 0 and tabicons.leftmost or tabicons.left, attributes)

  ---add the tab number. can be substituted by the `has_unseen_output` notification
  TabTitle:push(
    fg,
    bg,
    (unseen_output and icons.UnseenNotification or icons.Numbers[tab_idx + 1] or "")
      .. " ",
    attributes
  )

  ---the formatted tab title
  TabTitle:push(fg, bg, title, attributes)

  ---the right tab bar separator
  TabTitle:push(bg, fg, icons.Separators.FullBlock .. tabicons.right, attributes)

  return TabTitle
end)


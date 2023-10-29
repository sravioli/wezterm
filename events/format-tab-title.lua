---@diagnostic disable: undefined-field
-- see: <https://github.com/wez/wezterm/discussions/628#discussioncomment-1874614>

local wez = require "wezterm" ---@class WezTerm
local kanagawa = require "colorschemes.kanagawa-wave"

local M = {}

function M.setup()
  wez.on("format-tab-title", function(tab, _, _, config, hover, max_width)
    local nf = require "utils.nerdfont-icons" ---@class NerdFontIcons
    local fn = require "utils.functions" ---@class UtilityFunctions

    local layout = require("utils.layout"):new() ---@class WezTermLayout
    local separators = nf.Separators.TabBar ---@class TabBarIcons

    local bg = kanagawa.tab_bar.background
    local fg
    local pane, tab_idx = tab.active_pane, tab.tab_index

    ---set colors based on states
    if tab.is_active then
      fg = kanagawa.ansi[6]
    elseif hover then
      fg = kanagawa.selection_bg
    else
      fg = kanagawa.brights[1]
    end

    ---Check if any pane has unseen output
    local is_unseen_output_present = false
    for _, p in ipairs(tab.panes) do
      if p.has_unseen_output then
        is_unseen_output_present = true
        break
      end
    end

    ---get pane title, remove any `.exe` from the title, swap `Administrator` for the
    ---desired icon, swap `pwsh` and `bash` for their icons
    local title = fn.basename(pane.title)
      :gsub("%.exe%s?$", "")
      :gsub("^Administrator: %w+", nf.Admin.fill)
      :gsub("pwsh", nf.Powershell.md)
      :gsub("bash", nf.Bash.seti)

    -- HACK: running Neovim will turn the tab title to "C:\WINDOWS\system32\cmd.exe".
    -- After getting the basename the tab name ends up being "cmd".
    -- This is not the best way to detect when neovim is running but I will never use
    -- `cmd.exe` from WezTerm.
    local is_truncation_needed = true
    if title == "cmd" then
      ---full title truncation is not necessary since the dir name will be truncated
      is_truncation_needed = false
      local cwd, _ = fn.basename(pane.current_working_dir)

      ---instead of truncating the whole title, truncate to length the cwd to ensure
      ---that the right parenthesis always closes.
      if max_width == config.tab_max_width then
        cwd = wez.truncate_right(cwd, max_width - 14) .. "..."
      end
      title = string.format("%s ( %s)", nf.Vim.dev, cwd)
    end

    ---truncate the tab title when it overflows the maximum available space, then
    ---concatenate some dots to indicate the occurred truncation
    -- if is_truncation_needed and max_width == config.tab_max_width then
    if is_truncation_needed and max_width == config.tab_max_width then
      title = wez.truncate_right(title, max_width - 8) .. "..."
    end

    ---add the either the leftmost element or the normal left separator. This is done
    ---to esure a bit of space from the left margin.
    layout:push(bg, fg, tab_idx == 0 and separators.leftmost or separators.left)

    ---add the tab number. can be substituted by the `has_unseen_output` notification
    layout:push(
      fg,
      bg,
      (is_unseen_output_present and nf.UnseenNotification or nf.Numbers[tab_idx + 1])
        .. " "
    )

    ---the formatted tab title
    layout:push(fg, bg, title)

    ---the right tab bar separator
    layout:push(bg, fg, nf.Separators.FullBlock .. separators.right)

    return layout
  end)
end

return M

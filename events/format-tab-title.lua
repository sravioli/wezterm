---@diagnostic disable: undefined-field
-- see: <https://github.com/wez/wezterm/discussions/628#discussioncomment-1874614>

local wez = require "wezterm" ---@class WezTerm
local nf = require "utils.nerdfont-icons" ---@class NerdFontIcons
local fn = require "utils.functions" ---@class UtilityFunctions

local kanagawa = require "colorschemes.kanagawa"

local M = {}

function M.setup()
  wez.on("format-tab-title", function(tab, _, _, _, hover, max_width)
    ---@class WezTermLayout
    local layout = require("utils.layout"):new()

    local bg = kanagawa.background
    local fg
    local pane = tab.active_pane

    ---set colors based on states
    if tab.is_active then
      fg = kanagawa.ansi[6]
    elseif hover then
      fg = kanagawa.selection_bg
    else
      fg = kanagawa.brights[1]
    end

    ---Check if any pane has unseen output
    local has_unseen_output = false
    for _, p in ipairs(tab.panes) do
      if p.has_unseen_output then
        has_unseen_output = true
        break
      end
    end

    ---left SemiCircle
    layout:push(bg, fg, nf.SemiCircle.left)

    ---whether user is admin/sudo
    if fn.is_admin(pane.title) then layout:push(fg, bg, nf.Admin.fill .. " ") end

    ---tab index
    layout:push(fg, bg, nf.Numbers[tab.tab_index + 1])

    ---tab title
    local title = fn.basename(pane.title):gsub("%.exe%s?$", "")
    ---change pwsh and bash for their icons
    title = title:gsub("pwsh", nf.Powershell.md):gsub("bash", nf.Bash.seti)

    -- HACK: running Neovim will turn the tab title to "C:\WINDOWS\system32\cmd.exe".
    -- This is indeed a hack, but I'm never running cmd.exe so it's safe to override
    -- this way.
    if title == "cmd" then
      title = nf.Vim.dev
        .. string.format(" %s%s%s", "( ", fn.basename(pane.current_working_dir), ")")
    end

    ---ensures that the title fits in the available space, and that we have room for
    ---the edges.
    title = wez.truncate_right(title, max_width - 2)

    ---the tab title
    layout:push(fg, bg, title)

    ---alert about unseen output
    if has_unseen_output then layout:push(fg, bg, nf.Circle.small_filled) end

    ---the right SemiCircle
    layout:push(bg, fg, nf.SemiCircle.right)

    return layout
  end)
end

return M

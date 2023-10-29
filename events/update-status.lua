---@diagnostic disable: undefined-field
local wez = require "wezterm" ---@class WezTerm

local kanagawa = require "colorschemes.kanagawa-wave"

local M = {}

function M.setup()
  wez.on("update-status", function(window, pane)
    local nf = require "utils.nerdfont-icons" ---@class NerdFontIcons
    local fn = require "utils.functions" ---@class UtilityFunctions

    local layout = require("utils.layout"):new() ---@class WezTermLayout

    ---colors to use as background for the status bar
    local colors = { "#6e5497", "#876faf", "#a38fc1", "#b0a0ca", "#beb0d3" }

    local battery = wez.battery_info()[1]

    ---Returns the battery icon that should be used in the status.
    ---@return string battery_icon The icon corresponding to the battery charge level.
    function battery:icon()
      return nf.Battery[self.state][tostring(
        fn.toint(fn.mround(self.state_of_charge * 100, 10))
      )]
    end

    local datetime = wez.strftime "%a %b %-d %H:%M"

    local search_git_root_instead = true
    local cwd, hostname = fn.get_cwd_hostname(pane, search_git_root_instead)

    ---push each cell and the cells separator
    for i, cell in ipairs { cwd, hostname, datetime, battery:icon() } do
      local fg = colors[i]
      local bg = i == 1 and kanagawa.tab_bar.background or colors[i - 1]

      ---add each cell separator
      layout:push(bg, fg, nf.Separators.StatusBar.right)

      ---add each cell
      layout:push(colors[i], kanagawa.tab_bar.background, " " .. cell .. " ")
    end

    window:set_right_status(wez.format(layout))
  end)
end

return M

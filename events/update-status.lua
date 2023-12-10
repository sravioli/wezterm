---@diagnostic disable: undefined-field
local wez = require "wezterm" ---@class WezTerm

local colorscheme = require("colorschemes")[require "utils.current-colorscheme"]

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

    local MuxWindow = window:mux_window()
    local Config = MuxWindow:gui_window():effective_config()
    local tab_max_width = Config.tab_max_width
    local new_tab_button_width = Config.show_new_tab_button_in_tab_bar and 5 or 0

    ---estimate the total tab-bar width
    ---
    ---with this information it's possible to dynamically disable each status-bar cell
    ---if the screen width is not sufficient to accommodate both the tab-bar and the
    ---status-bar. In this case, wezterm cuts abruptly the status bar; using this results
    ---in a (imho) more visually pleasing status-bar/tab-bar
    local tab_bar_width = 0
    for _, MuxTab in ipairs(MuxWindow:tabs()) do
      local panes = MuxTab:panes()
      local len = panes[1]:get_title():len()

      ---calculate the effective width for the current tab
      local effective_width = math.min(len, tab_max_width) * 0.95

      tab_bar_width = tab_bar_width + effective_width + new_tab_button_width
    end

    local usable_width, used_width = pane:get_dimensions().cols - tab_bar_width, 0
    ---push each cell and the cells separator
    for i, cell in ipairs { cwd, hostname, datetime, battery:icon() } do
      local fg = colors[i]
      local bg = i == 1 and colorscheme.tab_bar.background or colors[i - 1]

      ---add each cell separator
      layout:push(bg, fg, nf.Separators.StatusBar.right)

      ---don't render cell if tab bar gets too long or if the win width isn't sufficient
      used_width = used_width + string.len(cell)
      cell = used_width >= usable_width and "" or cell

      ---add each cell
      layout:push(colors[i], colorscheme.tab_bar.background, " " .. cell .. " ")
    end

    window:set_right_status(wez.format(layout))
  end)
end

return M


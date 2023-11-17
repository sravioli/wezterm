---@diagnostic disable: undefined-field

local wez = require "wezterm" ---@class WezTerm

local M = {}

function M.setup()
  wez.on("new-tab-button-click", function(window, pane, button, default_action)
    if default_action and button == "Left" then
      window:perform_action(default_action, pane)
    end

    if default_action and button == "Right" then
      window:perform_action(
        wez.action.ShowLauncherArgs {
          title = "  Select/Search:",
          flags = "FUZZY|LAUNCH_MENU_ITEMS|DOMAINS",
        },
        pane
      )
    end
    return false
  end)
end

return M

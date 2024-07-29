---@module "events.new-tab-button-click"
---@author sravioli
---@license GNU-GPLv3

local wt = require "wezterm"

wt.on("new-tab-button-click", function(window, pane, button, default_action)
  if default_action and button == "Left" then
    window:perform_action(default_action, pane)
  end

  if default_action and button == "Right" then
    window:perform_action(
      wt.action.ShowLauncherArgs {
        title = "  Select/Search:",
        flags = "FUZZY|LAUNCH_MENU_ITEMS|DOMAINS",
      },
      pane
    )
  end
  return false
end)

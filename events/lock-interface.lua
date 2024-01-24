local wez = require "wezterm" ---@class WezTerm

wez.on("lock-interface", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.leader then
    -- replace it with an "impossible" leader that will never be pressed
    overrides.leader = { key = "\\", mods = "CTRL|ALT|SUPER" }
    wez.log_warn "[leader] clear"
  else
    -- restore to the main leader
    overrides.leader = nil
    wez.log_warn "[leader] set"
  end
  window:set_config_overrides(overrides)
end)


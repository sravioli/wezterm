local Opts = require("opts").events ---@class Opts.Events

if Opts.augment_command_palette.enabled then
  require "events.augment-command-palette"
end

if Opts.new_tab_button_click.enabled then
  require "events.new-tab-button-click"
end

if Opts.format_window_title.enabled then
  require "events.format-window-title"
end

if Opts.update_status.enabled then
  require "events.update-status"
end

if pcall(require, "overrides.events") then
  require "overrides.events"
end

require "events.format-tab-title"

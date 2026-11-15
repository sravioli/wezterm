---@module "events.augment-command-palette"

local wt = require "wezterm" ---@class Wezterm

local chord = require "plugs.chord" ---@class Chord

wt.on("augment-command-palette", function(_window, _pane)
  local entries = chord.palette_commands()
  for _, entry in ipairs(chord.palette()) do
    entries[#entries + 1] = entry
  end
  return entries
end)

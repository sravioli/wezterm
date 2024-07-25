local wt = require "wezterm"

local Utils = require "utils"
local Picker = Utils.class.picker
local fs = Utils.fn.fs

local FontSizePicker = Picker.new {
  title = "Font size picker",
  subdir = fs.pathconcat "font-sizes",
  fuzzy = true,
  comp = function(a, b)
    local label = "Reset"
    return (a.label == label) or (b.label ~= label and a.label < b.label)
  end,
}

return FontSizePicker

---@module "picker.leading"
---@author akthe-at
---@license GNU-GPLv3

local Picker = require("utils").class.picker

return Picker.new {
  title = "Font leading picker",
  subdir = "leadings",
  fuzzy = false,
  comp = function(a, b)
    local label = "Reset Line Height to Default"
    return (a.label == label) or (b.label ~= label and a.label < b.label)
  end,
}

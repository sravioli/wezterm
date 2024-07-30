---@module "picker.font"
---@author sravioli, akthe-at
---@license GNU-GPLv3

---@diagnostic disable: undefined-field

local Utils = require "utils"
local Picker = Utils.class.picker

return Picker.new {
  title = "Font picker",
  subdir = "fonts",
  fuzzy = true,
  fuzzy_description = "Searching font: ",
  comp = function(a, b)
    return (a.id == "reset") or (b.id ~= "reset" and a.label < b.label)
  end,
}

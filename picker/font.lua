---@module "picker.font"
---@author sravioli, akthe-at
---@license GNU-GPLv3

local Picker = require("utils").class.picker

return Picker.new {
  title = "󰢷  Font picker",
  subdir = "fonts",
  fuzzy = true,
  comp = function(a, b)
    return (a.id == "reset") or (b.id ~= "reset" and a.label < b.label)
  end,
}

---@module "picker.gpu"

local Picker = require "utils.picker" ---@class Picker

return Picker.new {
  title = "󰢷  Gpu picker",
  name = "gpus",
  fuzzy = true,
}

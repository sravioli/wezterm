---@module "plugs.mosaic"
---@author sravioli
---@license GNU-GPLv2

local wt = require "wezterm" ---@class Wezterm

local mosaic = wt.plugin.require "https://github.com/sravioli/mosaic.wz"

mosaic.setup(require("opts").statusbar)

return mosaic

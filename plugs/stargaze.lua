---@module "plugs.stargaze"
---@author sravioli
---@license GNU-GPLv2

local wt = require "wezterm" ---@class Wezterm

local stargaze = wt.plugin.require "https://github.com/sravioli/stargaze.wz"

stargaze.setup { unstar_on_uninstall = true }

return stargaze

---@module "plugs.stargaze"
---@author sravioli
---@license GNU-GPLv2

local wt = require "wezterm" ---@class Wezterm

local stargaze = wt.plugin.require "https://github.com/sravioli/stargaze.wz"

-- dry_run only logs (Ctrl+Shift+L); set it to false to really star.
stargaze.setup { dry_run = true, unstar_on_uninstall = true }

return stargaze

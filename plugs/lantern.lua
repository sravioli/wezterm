---@module "plugs.lantern"
---@author sravioli
---@license GNU-GPLv3

local lantern = require("wezterm").plugin.require "https://github.com/sravioli/lantern.wz"

-- The new-tab button follows the mosaic preset, also on scheme switches.
local function set_tab_button(cfg, theme)
  require("plugs.mosaic").set_new_tab_button(cfg, theme)
end

lantern.setup {
  default_font = require "config.font",
  color = {
    opacity = require("opts").config.color.opacity,
    set_tab_button = set_tab_button,
  },
}

return lantern

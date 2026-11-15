---@module "plugs.harbor"
---@author sravioli
---@license GNU-GPLv3

local wt = require "wezterm" ---@class Wezterm

-- Local checkout until the repository is published; switch to
-- "https://github.com/sravioli/harbor.wz" afterwards.
local harbor = wt.plugin.require "file:///home/srv/source/lua/wezterm-plugins/harbor.wz"

harbor.setup {
  picker = { hint_position = "status" },
  sources = {
    projects = { roots = { "~/source" } },
  },
}

return harbor

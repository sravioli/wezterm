---@module "plugs.harbor"
---@author sravioli
---@license GNU-GPLv3

local wt = require "wezterm" ---@class Wezterm

local harbor = wt.plugin.require "https://github.com/sravioli/harbor.wz"

harbor.setup {
  picker = { hint_position = "status" },
  sources = {
    projects = { roots = { "~/source" } },
  },
}

return harbor

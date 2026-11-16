---@module "plugs.beacon"
---@author sravioli
---@license GNU-GPLv2

local wt = require "wezterm" ---@class Wezterm

local beacon = wt.plugin.require "https://github.com/sravioli/beacon.wz"

-- Watch every plugin installed from GitHub: its clone's tag is the installed
-- version. No toasts; the status bar's beacon.update shows what can update.
-- Plugins keep a plugin.list() snapshot in GLOBAL, which skips a ~20 ms scan.
local plugins = wt.GLOBAL.__bootstrap_plugins or wt.plugin.list()
local first = true
for _, plugin in ipairs(plugins) do
  local repository = tostring(plugin.url):match "^https://github%.com/([^/]+/[^/]+)$"
  if repository then
    repository = repository:gsub("%.git$", "")
    local opts = {
      repository = repository,
      dir = plugin.plugin_dir,
      name = (repository:match "[^/]+$"):gsub("%.wz$", ""),
      notify = false,
    }
    if first then
      first = not beacon.setup(opts)
    else
      beacon.watch(opts)
    end
  end
end

return beacon

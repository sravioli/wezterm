---@module "opts"

---@class Opts
local opts = {
  utils = require "opts.utils",
  config = require "opts.config",
  statusbar = require "opts.statusbar",
  events = require "opts.events",
}

local ok, overrides = pcall(require, "overrides.opts")
if ok then
  opts = require("plugs.warp").table.merge("force", opts, overrides)
end

return opts

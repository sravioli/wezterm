local wt = require "wezterm" ---@class Wezterm
local log = wt.plugin.require "https://github.com/sravioli/log.wz"
log.setup(require "opts.utils.logger")
return log

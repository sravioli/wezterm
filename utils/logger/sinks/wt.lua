---@module "utils.logger.sinks.wt"

local wt = require "wezterm" ---@class Wezterm
local levels = require("utils.logger.levels").levels

---Log events to WezTerm's native logging facility.
---
---Map internal log levels (DEBUG, INFO, WARN, ERROR) to their corresponding
---`wezterm.log_*` functions.
---
---@param event Logger.Event Log event containing level and message.
return function(event)
  if event.level == levels.DEBUG or event.level == levels.INFO then
    wt.log_info(event.message)
  elseif event.level == levels.WARN then
    wt.log_warn(event.message)
  elseif event.level == levels.ERROR then
    wt.log_error(event.message)
  end
end

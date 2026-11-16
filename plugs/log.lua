local log = require("wezterm").plugin.require "https://github.com/sravioli/log.wz"

log.setup {
  enabled = true,
  threshold = "INFO", -- temporarily INFO to see stargaze dry-run; back to "WARN" after
  sinks = { default_enabled = true },
}

return log

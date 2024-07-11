local fun = require "utils.fun" ---@class Fun

return fun.tbl_merge(
  (require "config.gpu"),
  (require "config.appearance"),
  (require "config.font"),
  (require "config.tab-bar"),
  (require "config.general")
)

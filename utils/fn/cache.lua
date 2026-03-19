---@module 'utils.fn.cache'
---
---Thin re-export of `memo.cache` from the memo.wz plugin.
---All call sites that `require "utils.fn.cache"` receive `memo.Cache` directly.

local wt = require "wezterm" ---@class Wezterm
local memo = wt.plugin.require "https://github.com/sravioli/memo.wz" ---@class memo.API

return memo.cache

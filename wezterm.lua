require "events"

---@class Configuration
local config = require("config")
  :add(require "mappings.default")
  :add(require "mappings.modes")
  :init()

local ok, overrides = pcall(require, "overrides.mappings")
if ok then
  require("utils.keymapper").apply_overrides(config, overrides)
end

return config

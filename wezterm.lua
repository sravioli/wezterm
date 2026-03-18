require "events"

local Picker = require "utils.picker" ---@class Picker

---@class Configuration
local config = require("config")
  :add(Picker.restore())
  :add(require "mappings.default")
  :add(require "mappings.modes")
  :init()

local ok, overrides = pcall(require, "overrides.mappings")
if ok then
  require("utils.keymapper").apply_overrides(config, overrides)
end

return config

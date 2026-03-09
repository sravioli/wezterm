---@class Configuration
local Config = require "utils.config"

return Config:add("config.appearance")
  :add("config.font")
  :add("config.tab-bar")
  :add("config.general")
  :add "config.gpu"

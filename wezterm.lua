---@class Config
local Config = require("utils.config"):new()

require "events.update-status"
require "events.format-tab-title"
require "events.new-tab-button-click"

return Config:add(require "config.general")
  :add(require "config.appearance")
  :add(require "config.tab-bar")
  :add(require "config.font")
  :add(require "config.gpu")
  :add(require "mappings.default")
  :add(require "mappings.modes")


---@class Config
local Config = require("utils.config"):new()

require "events.update-status"
require "events.format-tab-title"
require "events.new-tab-button-click"
require "events.lock-interface"
require "events.augment-command-palette"

return Config:add("config"):add "mappings"

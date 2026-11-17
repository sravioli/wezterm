require "events"

require "plugs.beacon"
require "plugs.stargaze"

local chord = require "plugs.chord" ---@class Chord
local lantern = require "plugs.lantern" ---@class Lantern

---@class Configuration
local config = require("config")
  :add(require "mappings.default")
  :add(require("mappings.modes").config)
  :init()

lantern.rekindle(config)
chord.use_harbor_status_hints()
require("plugs.harbor").apply_to_config(config)

local ok, overrides = pcall(require, "overrides.mappings")
if ok then
  chord.apply_overrides(config, overrides)
end

chord.apply(config)

if require("opts").events.update_status.enabled then
  local mosaic = require "plugs.mosaic" ---@class Mosaic.Api
  mosaic.apply_to_config(config)
end

return config

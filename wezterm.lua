require "events"

local chord = require "plugs.chord" ---@class Chord
local lantern = require "plugs.lantern" ---@class Lantern

---@class Configuration
local config = require("config")
  :add(require "mappings.default")
  :add(require("mappings.modes").config)
  :init()

lantern.rekindle(config)
chord.use_harbor_status_hints()

local ok, overrides = pcall(require, "overrides.mappings")
if ok then
  chord.apply_overrides(config, overrides)
end

chord.apply(config)

return config

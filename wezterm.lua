require "events"

---@class Configuration
return require("config")
  :add(require "mappings.default")
  :add(require "mappings.modes")
  :init()

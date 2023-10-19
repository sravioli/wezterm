local Config = require "config.init"

return Config:init()
  :add(require "config.gpu")
  :add(require "config.font")
  :add(require "config.bell")
  :add(require "config.window")
  :add(require "config.cursor")
  :add(require "config.general")
  :add(require "config.appearance")
  :add(require "config.exit-behavior").options
-- :add(require "config.command-palette")

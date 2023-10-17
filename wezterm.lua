local Config = require "config.init"

return Config:init()
  :add(require "config.window")
  :add(require "config.appearance")
  :add(require "config.cursor")
  :add(require "config.command-palette")
  :add(require "config.bell").options

local Config = require "config.init"

require("events.format-tab-title").setup()
require("events.format-window-title").setup()
require("events.update-status").setup()
require("events.new-tab-button-click").setup()

return Config:init()
  :add(require "config.gpu")
  :add(require "config.font")
  :add(require "config.bell")
  :add(require "config.window")
  :add(require "config.cursor")
  :add(require "config.general")
  :add(require "config.appearance")
  :add(require "config.exit-behavior")
  :add(require "keys.tables")
  :add(require "keys.bindings").options

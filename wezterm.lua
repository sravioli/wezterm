local Config = require "config.init"

return Config:init():add(require "config.appearance").options

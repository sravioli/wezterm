local current_config = require "config.font"

local monaspace_features = current_config.monaspace_features

return function(config, _)
  config.font = current_config.font
  config.font_size = current_config.font_size
  config.line_height = current_config.line_height
  config.font_rules = current_config.font_rules
end

local current_config = require "config.font"

local M = {}

M.apply = function(config, _)
  for key, value in pairs(current_config) do
    config[key] = value
  end
end

return M

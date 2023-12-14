---@class Config
local Config = {}

---@class WezTerm
local wez = require "wezterm"

function Config:new()
  self.config = {}
  if wez.config_builder then
    self.config = wez.config_builder()
    self.config:set_strict_mode(true)
  end
  self = setmetatable(self.config, { __index = Config })
  return self
end

---Adds a module to the wezterm configuration
---@param spec string|table table of wezterm configuration options
---@return Config self modified wezterm configuration table
---
---```lua
----- Example usage in wezterm.lua
---local Config = require "config"
---return Config:init():add(require "<module.name>").options
---```
function Config:add(spec)
  if type(spec) == "string" then
    spec = require(spec)
  end
  for key, value in pairs(spec) do
    if self.config[key] ~= nil then
      wez.log_warn("Duplicate found: ", { old = self.config[key], new = spec[key] })
    else
      self.config[key] = value
    end
  end
  return self
end

return Config


---@diagnostic disable: undefined-field

---@class WezTerm
local wez = require "wezterm"

---@class Config
---@field options table[] All the configuration options for wezterm
local Config = {}

---Initializes the wezterm configuration
---@return Config opts The configuration options
function Config:init()
  local opts = {}
  if wez.config_builder then opts = wez.config_builder() end

  self = setmetatable(opts, { __index = Config })
  self.options = {}
  return opts
end

---Adds a module to the wezterm configuration
---@param spec table A table of wezterm configuration options
---@return Config self The modified wezterm configuration table
---
---```lua
----- Example usage in wezterm.lua
---local Config = require "config"
---return Config:init():add(require "<module.name>").options
---```
function Config:add(spec)
  for key, value in pairs(spec) do
    if self.options[key] ~= nil then
      wez.log_warn(
        "Duplicate config option detected: ",
        { old = self.options[key], new = spec[key] }
      )
      goto continue
    end
    self.options[key] = value
    ::continue::
  end
  return self
end

return Config


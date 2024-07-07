---Config module for managing Wezterm configurations.
---This module provides functionality to initialize and modify Wezterm configuration
---settings using a simple API.
---
---@module "utils.config"

---@class Config
local Config = {}

---@class Wezterm
local wt = require "wezterm"

--- Initializes a new Config object.
---Creates a new Wezterm configuration object. If `wez.config_builder` is available,
---it sets the configuration to strict mode.
---
---@return Config self A new instance of the Wezterm configuration.
function Config:new()
  self.config = {}

  if wt.config_builder then
    wt.log_info "Config: config builder is available"
    self.config = wt.config_builder()
    self.config:set_strict_mode(true)
  end

  self = setmetatable(self.config, { __index = Config })
  return self
end

---Adds a module to the Wezterm configuration.
---This function allows you to extend the Wezterm configuration by adding new options
---from a specified module. If a string is provided, it requires the module and merges
---its options. If a table is provided, it merges the table directly into the configuration.
---
---@param spec string|table Module name as a string or a config table.
---@return Config self Modified Config object with the new options.
---
---@usage
----- Example usage in wezterm.lua
---local Config = require "config"
---return Config:new():add(require "<module.name>").options
function Config:add(spec)
  if type(spec) == "string" then
    spec = require(spec)
  end

  for key, value in pairs(spec) do
    if self.config[key] ~= nil then
      wt.log_warn("Config: found dupe: ", { old = self.config[key], new = spec[key] })
    else
      self.config[key] = value
    end
  end

  return self
end

return Config

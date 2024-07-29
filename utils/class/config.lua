---@diagnostic disable: undefined-field

---Config module for managing Wezterm configurations.
---This module provides functionality to initialize and modify Wezterm configuration
---settings using a simple API.
---
---@module "utils.class.config"
---@author sravioli
---@license GNU-GPLv3

---@class Utils.Class.Config
local M = {}

local wt = require "wezterm"
local log_info, log_warn, log_error = wt.log_info, wt.log_warn, wt.log_error

---Initializes a new Config object.
---Creates a new Wezterm configuration object. If `wez.config_builder` is available,
---it sets the configuration to strict mode.
---
---@return Utils.Class.Config self A new instance of the Wezterm configuration.
function M:new()
  self.config = {}

  if wt.config_builder then
    self.config = wt.config_builder()
    self.config:set_strict_mode(true)
    log_info "Config: using config builder"
  else
    log_error "Config: builder unavailable!"
  end

  self = setmetatable(self.config, { __index = M })
  return self
end

---Adds a module to the Wezterm configuration.
---This function allows you to extend the Wezterm configuration by adding new options
---from a specified module. If a string is provided, it requires the module and merges
---its options. If a table is provided, it merges the table directly into the configuration.
---
---@param spec string|table Module name as a string or a config table.
---@return Utils.Class.Config self Modified Config object with the new options.
---
---@usage
----- Example usage in wezterm.lua
---local Config = require "config"
---return Config:new():add(require "<module.name>").options
function M:add(spec)
  if type(spec) == "string" then
    spec = require(spec)
  end

  for key, value in pairs(spec) do
    if self.config[key] == spec[key] then
      log_warn("Config: found dupe: ", { old = self.config[key], new = spec[key] })
    end
    self.config[key] = value
  end

  return self
end

return M

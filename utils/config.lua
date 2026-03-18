---@module "utils.config"

local Opts = require("opts").utils.config ---@class Opts.Utils.Config

---@class Configuration
local M = {
  modules = {},
  log = require("utils.logger").new("Config", Opts.log.enabled),
}
M.__index = M

---Add a module to the load queue
---@param name_or_module string|table|fun(): table
---@return table self
function M:add(name_or_module)
  local spec = name_or_module

  if type(spec) == "string" then
    local ok, result = pcall(require, spec)
    if not ok then
      M.log:error("Could not load module: %s. Stacktrace:\n" .. result, spec)
      return self
    end
    spec = result
  end

  if type(spec) == "function" then
    spec = spec()
  end

  if type(spec) == "table" then
    table.insert(self.modules, spec)
  end

  return self
end

---Merge modules and return the final config
function M:init()
  local final_config = {}

  -- shallow merge
  for i = 1, #self.modules do
    local mod = self.modules[i]
    for k, v in pairs(mod) do
      final_config[k] = v
    end
  end

  local ok, overrides = pcall(require, "overrides.config")
  if ok then
    if overrides.keys ~= nil or overrides.key_tables ~= nil then
      M.log:warn "`overrides.config` cannot define `keys` or `key_tables`; use `overrides.mappings`"
      overrides.keys = nil
      overrides.key_tables = nil
    end

    final_config = require("utils.fn.tbl").merge("force", final_config, overrides)
  end

  local wt = require "wezterm"
  if Opts.builder.enabled then
    if wt.config_builder then
      local builder = wt.config_builder()
      for k, v in pairs(final_config) do
        builder[k] = v
      end

      if Opts.builder.strict_mode then
        pcall(function()
          builder:set_strict_mode(true)
        end)
      end
      return builder
    end
  end

  return final_config
end

return M

---@meta utils.Configuration
error "cannot require a meta file!"

-- luacheck: push ignore 631 (line is too long)

---Collect and merge configuration modules into a final WezTerm config object.
---
---Supports the WezTerm config builder with optional strict mode.
---Configuration overrides are loaded from `overrides.config` when available.
---
---### Example Usage
---~~~lua
---local Config = require("utils.config")
---Config:add("config.appearance")
---      :add("config.font")
---      :add("config.general")
---local config = Config:init()
---~~~
---
---@class Configuration
---@field public modules table[] Ordered list of configuration modules to merge.
---@field public log     Logger  Logger instance for the configuration utility.

-- luacheck: pop

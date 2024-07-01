---@class Config
local Config = {}

Config.front_end = "WebGpu"
Config.webgpu_force_fallback_adapter = false
Config.webgpu_power_preference = "HighPerformance"
Config.webgpu_preferred_adapter = require("utils.gpu_adapter"):pick_best()

return Config

---@class Config
local Config = {}

Config.front_end = "WebGpu"
Config.webgpu_force_fallback_adapter = false
Config.webgpu_power_preference = "HighPerformance"
Config.webgpu_preferred_adapter = {
  backend = "Vulkan",
  device = 8081,
  device_type = "DiscreteGpu",
  driver = "NVIDIA",
  driver_info = "537.58",
  name = "NVIDIA GeForce GTX 1650 with Max-Q Design",
  vendor = 4318,
}

return Config


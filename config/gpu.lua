local wt = require "wezterm" ---@class Wezterm

local Config = {}

Config.front_end = "WebGpu"
Config.webgpu_force_fallback_adapter = false

---Switch to low power mode when battery is low.
---Deferred to a function so `battery_info()` is not called at require time.
Config.webgpu_power_preference = (function()
  local battery = wt.battery_info()[1]
  return (battery and battery.state_of_charge < 0.35) and "LowPower" or "HighPerformance"
end)()

Config.webgpu_preferred_adapter = require("picker.assets.gpus.gpus").pick_best()

return Config

local wt = require "wezterm" ---@class Wezterm

local Config = {}

Config.front_end = "WebGpu"
Config.webgpu_force_fallback_adapter = false

---Switch to low power mode when battery is low.
---Evaluated once per config load.
Config.webgpu_power_preference = (function()
  local battery = wt.battery_info()[1]
  return (battery and battery.state_of_charge < 0.35) and "LowPower" or "HighPerformance"
end)()

return Config

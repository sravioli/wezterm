local Config = {}

Config.front_end = "WebGpu"
Config.webgpu_force_fallback_adapter = false

---Switch to low power mode when battery is low
local battery = require("wezterm").battery_info()[1]
Config.webgpu_power_preference = (battery and battery.state_of_charge < 0.35)
    and "LowPower"
  or "HighPerformance"

Config.webgpu_preferred_adapter = require("picker.assets.gpus.gpus").pick_best()

return Config

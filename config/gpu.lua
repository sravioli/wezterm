local battery_charge = require("wezterm").battery_info()[1].state_of_charge

local Config = {}

Config.front_end = "WebGpu"
Config.webgpu_force_fallback_adapter = false

---switch to low power mode when battery is low
if battery_charge < 0.35 then
  Config.webgpu_power_preference = "LowPower"
else
  Config.webgpu_power_preference = "HighPerformance"
end

Config.webgpu_preferred_adapter = require("utils.gpu_adapter"):pick_best()

return Config

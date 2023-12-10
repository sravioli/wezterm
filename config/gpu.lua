---@class config
local config = {}

---Specifies which render front-end to use. This option used to have more scope in
---earlier versions of wezterm, but today it allows three possible values:
---
---* `OpenGL` - use GPU accelerated rasterization
---* `Software` - use CPU-based rasterization.
---* `WebGpu` - use GPU accelerated rasterization (_Since: Version 20221119-145034-49b9839f_)
---
---_Since: Nightly Builds Only_
---The default is `"WebGpu"`. In earlier versions it was `"OpenGL"`
---
---You may wish (or need!) to select `Software` if there are issues with your
---GPU/OpenGL drivers.
--
---WezTerm will automatically select `Software` if it detects that it is being
---started in a Remote Desktop environment on Windows.
---
---**WebGpu**
---
---_Since: Version 20221119-145034-49b9839f_
---The WebGpu front end allows wezterm to use GPU acceleration provided by a number
---of platform-specific backends:
---
---* Metal (on macOS)
---* Vulkan
---* DirectX 12 (on Windows)
---
---@see config.webgpu_preferred_adapter
---@see config.webgpu_power_preference
---@see config.webgpu_force_fallback_adapter
config.front_end = "WebGpu"

---If set to `true`, forces the use of a fallback software (CPU based) rendering
---backend. The performance will not be as good as using a GPU.
---
---This option is only applicable when you have configured `front_end = "WebGpu"`.
---
---You can have more fine grained control over which GPU is selected using
---`webgpu_preferred_adapter`.
---@see config.webgpu_preferred_adapter
config.webgpu_force_fallback_adapter = false

---Specifies the power preference when selecting a webgpu GPU instance. This option is
---only applicable when you have configured `front_end = "WebGpu"`.
---
---The possible values are:
---* `"LowPower"` - use an integrated GPU
---* `"HighPerformance"` - use a discrete GPU
---
---You can have more fine grained control over which GPU is selected using
---`webgpu_preferred_adapter`.
---@see config.webgpu_preferred_adapter
config.webgpu_power_preference = "HighPerformance"

---Specifies which WebGpu adapter should be used.
---
---This option is only applicable when you have configured `front_end = "WebGpu"`.
---
---You can use the `wezterm.gui.enumerate_gpus()` function to return a list of GPUs.
---
---If you open the Debug Overlay (default: `CTRL + SHIFT + L`) you can interactively
---review the list:
---
---```
---> wezterm.gui.enumerate_gpus()
---[
---    {
---        "backend": "Vulkan",
---        "device": 29730,
---        "device_type": "DiscreteGpu",
---        "driver": "radv",
---        "driver_info": "Mesa 22.3.4",
---        "name": "AMD Radeon Pro W6400 (RADV NAVI24)",
---        "vendor": 4098,
---    },
---    {
---        "backend": "Vulkan",
---        "device": 0,
---        "device_type": "Cpu",
---        "driver": "llvmpipe",
---        "driver_info": "Mesa 22.3.4 (LLVM 15.0.7)",
---        "name": "llvmpipe (LLVM 15.0.7, 256 bits)",
---        "vendor": 65541,
---    },
---    {
---        "backend": "Gl",
---        "device": 0,
---        "device_type": "Other",
---        "name": "AMD Radeon Pro W6400 (navi24, LLVM 15.0.7, DRM 3.49, 6.1.9-200.fc37.x86_64)",
---        "vendor": 4098,
---    },
---]
---```
---
---Based on that list, I might choose to explicitly target the discrete Gpu like this
---(but note that this would be the default selection anyway):
---
---```lua
---config.webgpu_preferred_adapter = {
---  backend = 'Vulkan',
---  device = 29730,
---  device_type = 'DiscreteGpu',
---  driver = 'radv',
---  driver_info = 'Mesa 22.3.4',
---  name = 'AMD Radeon Pro W6400 (RADV NAVI24)',
---  vendor = 4098,
---}
---config.front_end = 'WebGpu'
---```
---
---alternatively, I might use:
---
---```lua
---local wezterm = require 'wezterm'
---local config = {}
---local gpus = wezterm.gui.enumerate_gpus()
---
---config.webgpu_preferred_adapter = gpus[1]
---config.front_end = 'WebGpu'
---return config
---```
---
---If you have a more complex situation you can get a bit more elaborate; this example
---will only enable WebGpu if there is an integrated GPU available with Vulkan drivers:
---
---```lua
---local wezterm = require 'wezterm'
---local config = {}
---
---for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
---  if gpu.backend == 'Vulkan' and gpu.device_type == 'IntegratedGpu' then
---    config.webgpu_preferred_adapter = gpu
---    config.front_end = 'WebGpu'
---    break
---  end
---end
---
---return config
---```
---
---@see config.webgpu_power_preference
---@see config.webgpu_force_fallback_adapter
config.webgpu_preferred_adapter = {
  backend = "Vulkan",
  device = 8081,
  device_type = "DiscreteGpu",
  driver = "NVIDIA",
  driver_info = "537.58",
  name = "NVIDIA GeForce GTX 1650 with Max-Q Design",
  vendor = 4318,
}

return config


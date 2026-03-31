---@module 'picker.assets.gpus.gpus'

local warp = require "plugs.warp" ---@class Warp.Api
local wt = require "wezterm" ---@class Wezterm
local fs = warp.filesystem ---@class Warp.FileSystem

local Logger = require "plugs.log" ---@class Logger

local os_info = fs.platform()

---@alias Gpu.BackEnd    "Vulkan"|"Metal"|"Gl"|"Dx12"
---@alias Gpu.DeviceType "DiscreteGpu"|"IntegratedGpu"|"Cpu"|"Other"
---
---@alias Gpu.AdapterMap table<Gpu.BackEnd, GpuInfo|nil>
---@alias Gpu.VendorMap  table<string, GpuInfo>

---@class Gpu.Adapters
---@field _backends Gpu.BackEnd[]
---@field _preferred_backend Gpu.BackEnd
---@field ENUMERATED_GPUS GpuInfo[]
---@field VendorMap Gpu.VendorMap
local Gpu = {
  VendorMap = {},
  log = Logger.new("GpuAdapters", true),
  ENUMERATED_GPUS = wt.gui.enumerate_gpus(), ---@type GpuInfo[]
  AVAILABLE_BACKENDS = {
    windows = { "Dx12", "Vulkan", "Gl" },
    linux = { "Vulkan", "Gl" },
    mac = { "Metal" },
  },
}

Gpu._backends = Gpu.AVAILABLE_BACKENDS[os_info.os]
Gpu._preferred_backend = Gpu._backends[1]

-- Populate AdapterMaps and VendorMap
for i = 1, #Gpu.ENUMERATED_GPUS do
  local gpu = Gpu.ENUMERATED_GPUS[i]

  -- Device type map
  local device_table = Gpu[gpu.device_type]
  if not device_table then
    device_table = {}
    Gpu[gpu.device_type] = device_table
  end
  device_table[gpu.backend] = gpu

  -- VendorMap for instant lookup
  Gpu.VendorMap[tostring(gpu.vendor)] = gpu
end

---@class Picker.Module
local M = {}

---Return GPU choices formatted for Picker UI.
---@return Picker.Choice[]
M.get = function()
  local choices = {} ---@type Picker.Choice[]
  for i = 1, #Gpu.ENUMERATED_GPUS do
    local gpu = Gpu.ENUMERATED_GPUS[i]
    local label = ("[%s] (%s) %s"):format(gpu.backend, gpu.device_type, gpu.name)
    choices[#choices + 1] = { id = tostring(gpu.vendor), label = label }
  end
  return choices
end

---User selection via Picker.
---@param Config table Configuration overrides
---@param opts Picker.CallbackOpts
M.pick = function(Config, opts)
  local vendor_id = opts.choice.id
  local gpu_info = Gpu.VendorMap[vendor_id]

  if not gpu_info then
    Gpu.log:error("Selected GPU vendor %s not found!", vendor_id)
    return
  end

  Config.webgpu_preferred_adapter = gpu_info
end

---Automatically pick the best available GPU.
---Can be called programmatically without user interaction.
---@return GpuInfo|nil
M.pick_best = function()
  local preferred_order = { "DiscreteGpu", "IntegratedGpu", "Other", "Cpu" }
  local selected_table = nil

  for _, device_type in ipairs(preferred_order) do
    local t = Gpu[device_type]
    if t and next(t) then
      selected_table = t
      break
    end
  end

  if not selected_table then
    Gpu.log:error "No GPU adapters found. Using default adapter."
    return nil
  end

  local gpu_choice = selected_table[Gpu._preferred_backend]
  if not gpu_choice then
    Gpu.log:error(
      "Preferred backend %s not available. Using first available backend.",
      Gpu._preferred_backend
    )
    local first_backend = next(selected_table)
    gpu_choice = selected_table[first_backend]
  end

  return gpu_choice
end

return M

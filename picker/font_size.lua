---@diagnostic disable: undefined-field
local wt = require "wezterm"
local log_info = wt.log_info
local sizes = require "sizes.sizes"

local FontSizePicker = require("picker.generic"):init()

FontSizePicker.title = "Font Size Picker"
FontSizePicker.fuzzy = true
FontSizePicker.choices = {}

local size_options = sizes.init()

-- Create choices
for _, size in ipairs(size_options) do
  local label, value
  if type(size) == "table" then
    label, value = size.label, size.value
  else
    label, value = size, size
  end

  FontSizePicker.choices[#FontSizePicker.choices + 1] = {
    label = label,
    id = tostring(value), -- Convert id to string
  }
end

FontSizePicker.action = function(window, _, id, label)
  if not id and not label then
    return log_info "Font size picking cancelled"
  end

  log_info("Applying font size: ", label)
  local Overrides = window:get_config_overrides() or {}

  if id == "Reset" then
    Overrides.font_size = nil
  else
    -- Convert id back to number if it's not "Reset"
    local value = id ~= "Reset" and tonumber(id) or id
    sizes.activate(Overrides, nil, value)
  end

  window:set_config_overrides(Overrides)
end

return FontSizePicker

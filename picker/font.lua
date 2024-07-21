---@diagnostic disable: undefined-field

local wt = require "wezterm"

local Utils = require "utils"
local fs = Utils.fn.fs

local font_folder_name = "fonts"
local dir = wt.config_dir .. fs.path_separator .. font_folder_name
local files = fs.read_dir(dir)
if not files then
  return wt.log_error("Unable to read files from dir:", dir)
end

local FontPicker = require("picker.generic"):init()
FontPicker.title = "Font Picker"
FontPicker.fuzzy = true
FontPicker.fuzzy_description = "Searching font: "

FontPicker.choices = {}
for i = 1, #files do
  local file = fs.basename(files[i]):gsub("%.lua", "")
  FontPicker.choices[#FontPicker.choices + 1] =
    { label = file, id = font_folder_name .. "." .. file }
end

table.sort(FontPicker.choices, function(a, b)
  return (a.label == "reset") or (b.label ~= "reset" and a.label < b.label)
end)

FontPicker.action = function(window, _, id, label)
  if not id and not label then
    return wt.log_info "Font picking cancelled"
  end
  wt.log_info("Applying font: ", label)

  local Overrides = window:get_config_overrides() or {}
  require(id).apply(Overrides)

  window:set_config_overrides(Overrides)
end

return FontPicker

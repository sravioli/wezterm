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


FontPicker.pick = function()
  return wt.action_callback(function(window, pane)
    local choices = {}
    for k, _ in pairs(FontPicker.choices) do
      table.insert(choices, { label = k })
    end
    table.sort(choices, function(a, b)
      return a.label < b.label
    end)

    window:perform_action(
      wt.action.InputSelector {
        action = wt.action_callback(function(window, _, _, label)
          local overrides = window:get_config_overrides() or {}
          FontPicker.select(overrides, label)
          window:set_config_overrides(overrides)
        end),
        title = FontPicker.title,
        choices = choices,
        fuzzy = FontPicker.fuzzy,
      },
      pane
    )
  end)
end

return FontPicker

---@diagnostic disable: undefined-field

local Utils = require "utils"
local Layout = Utils.class.layout
local color = Utils.fn.color

local wt = require "wezterm"
local log_info, wt_format = wt.log_info, wt.format

local ThemePicker = require("picker.generic"):init()
ThemePicker.title = "Theme Picker"
ThemePicker.description = "Write the number you want to choose or press / to search."
ThemePicker.choices = {}

local fill_choices = function(choices, schemes)
  for scheme, colors in pairs(schemes) do
    if colors.tab_bar then
      local ChoiceLayout = Layout:new() ---@class Layout
      ChoiceLayout:push(colors.background, colors.foreground, scheme)
      choices[#choices + 1] = { label = wt_format(ChoiceLayout), id = scheme }
    end
  end
end

fill_choices(ThemePicker.choices, color.get_schemes())

ThemePicker.action = function(window, _, id, label)
  if not id and not label then
    return log_info "Theme picking cancelled"
  end
  log_info("Applying theme: ", id)

  local theme = window:effective_config().color_schemes[id]

  ---@class Config
  local Overrides = {
    color_scheme = id,
    char_select_bg_color = theme.brights[6],
    char_select_fg_color = theme.background,
    command_palette_bg_color = theme.brights[6],
    command_palette_fg_color = theme.background,
    background = {
      { source = { Color = theme.background }, width = "100%", height = "100%" },
    },
  }
  color.set_tab_button(Overrides, theme)

  window:set_config_overrides(Overrides)
end

return ThemePicker

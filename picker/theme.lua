---@diagnostic disable: undefined-field

local Utils = require "utils"
local Layout = Utils.class.layout
local color = Utils.fn.color

local wt = require "wezterm"
local log_info, wt_format = wt.log_info, wt.format

local ThemePicker = require("picker.generic"):init()
ThemePicker.title = "Theme Picker"
ThemePicker.fuzzy = true
ThemePicker.choices = {}

local _choices = {}
local max_len = 0
for scheme, colors in pairs(color.get_schemes()) do
  if colors.tab_bar then
    _choices[scheme] = colors
    if scheme:len() > max_len then
      max_len = scheme:len()
    end
  end
end

for scheme, colors in pairs(_choices) do
  local ChoiceLayout = Layout:new() ---@class Layout
  ChoiceLayout:push(colors.background, colors.foreground, scheme)

  ChoiceLayout:push("none", "none", (" "):rep(max_len - scheme:len() + 3))
  for i = 1, #colors.ansi do
    local bg = colors.ansi[i]
    ChoiceLayout:push(bg, bg, "  ")
  end

  ChoiceLayout:push("none", "none", "   ")
  for i = 1, #colors.brights do
    local bg = colors.brights[i]
    ChoiceLayout:push(bg, bg, "  ")
  end

  ThemePicker.choices[#ThemePicker.choices + 1] =
    { label = wt_format(ChoiceLayout), id = scheme }
end

table.sort(ThemePicker.choices, function(a, b)
  return a.id < b.id
end)

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

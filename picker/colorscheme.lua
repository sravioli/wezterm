---@module "picker.colorscheme"

local warp = require "plugs.warp" ---@class Warp.Api
local str = warp.string ---@class Warp.String
local wt = require "wezterm" ---@class Wezterm

local Layout = require "utils.layout" ---@class Layout
local Picker = require "utils.picker" ---@class Picker

return Picker.new {
  title = "󰢷  Colorscheme",
  name = "colorschemes",

  format_choices = function(__choices, opts)
    local choices = {}

    local max_label_len = 0
    for _, item in pairs(__choices) do
      local len = str.width(item.choice.label --[[@as string]])
      max_label_len = len > max_label_len and len or max_label_len
    end

    local Config = opts.window:effective_config()
    local fg = Config.color_schemes[Config.color_scheme].foreground

    for _, item in pairs(__choices) do
      local id, label = item.choice.id, item.choice.label
      local colors = item.module.scheme
      ---@cast label string

      local layout = Layout:new "ColorschemeChoices"

      layout:append(nil, fg, label)
      layout:append(nil, fg, (" "):rep((max_label_len - str.width(label)) + 2))

      for i = 1, #colors.ansi do
        local color = colors.ansi[i]
        layout:append(color, color, "  ")
      end

      layout:append(nil, nil, "   ")

      for i = 1, #colors.brights do
        local color = colors.brights[i]
        layout:append(color, color, "  ")
      end

      choices[#choices + 1] = { label = layout:format(), id = id }
    end

    return choices
  end,

  comp = function(a, b)
    return a.id < b.id
  end,
}

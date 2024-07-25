local wt = require "wezterm"

local Utils = require "utils"
local Picker = Utils.class.picker
local Layout = Utils.class.layout
local fs = Utils.fn.fs

local ColorschemePicker = Picker.new {
  title = "Colorscheme picker",
  subdir = fs.pathconcat "colorschemes",
  fuzzy = true,

  make_choices = function(choices)
    local __choices = {}
    for _, opts in pairs(choices) do
      local id, label = opts.value.id, opts.value.label
      local colors = opts.module.scheme

      local ChoiceLayout = Layout:new() ---@class Layout

      for i = 1, #colors.ansi do
        local bg = colors.ansi[i]
        ChoiceLayout:push(bg, bg, "  ")
      end

      ChoiceLayout:push("none", "none", "   ")
      for i = 1, #colors.brights do
        local bg = colors.brights[i]
        ChoiceLayout:push(bg, bg, "  ")
      end

      ChoiceLayout:push("none", "none", (" "):rep(5))
      ChoiceLayout:push(colors.background, colors.foreground, label)
      __choices[#__choices + 1] = { label = wt.format(ChoiceLayout), id = id }
    end

    table.sort(__choices, function(a, b)
      return a.id < b.id
    end)

    return __choices
  end,
}

return ColorschemePicker

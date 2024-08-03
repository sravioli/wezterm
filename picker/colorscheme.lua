---@module "picker.colorscheme"
---@author sravioli
---@license GNU-GPLv3

local Utils = require "utils"
local Picker, Layout = Utils.class.picker, Utils.class.layout

return Picker.new {
  title = "Colorscheme picker",
  subdir = "colorschemes",
  fuzzy = true,
  fuzzy_description = "Matching colorscheme: ",

  build = function(__choices, _, opts)
    local choices = {}
    for _, item in pairs(__choices) do
      local id, label = item.value.id, item.value.label
      local colors = item.module.scheme
      ---@cast label string

      local ChoiceLayout = Layout:new "ColorschemeChoices"
      for i = 1, #colors.ansi do
        local bg = colors.ansi[i]
        ChoiceLayout:push("none", bg, " ")
      end

      ChoiceLayout:push("none", "none", "   ")
      for i = 1, #colors.brights do
        local bg = colors.brights[i]
        ChoiceLayout:push("none", bg, " ")
      end

      local Config = opts.window:effective_config()
      local fg = Config.color_schemes[Config.color_scheme].foreground
      ChoiceLayout:push("none", "none", (" "):rep(5))
      ChoiceLayout:push("none", fg, label)
      choices[#choices + 1] = { label = ChoiceLayout:format(), id = id }
    end

    table.sort(choices, function(a, b)
      return a.id < b.id
    end)

    return choices
  end,
}

---@module "picker.assets.fonts.jetbrains-mono-nf"
---@author sravioli, akthe-at
---@license GNU-GPLv3

---@class PickList
local M = {}

local wt = require "wezterm"

M.get = function()
  return { id = "jetbrains-mono-nf", label = "Jetbrains Mono Nerd Font" }
end

M.activate = function(Config, _)
  local monaspace_features =
    { "dlig", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" }

  Config.font = wt.font_with_fallback {
    {
      family = "JetBrainsMono Nerd Font",
      weight = "Regular",
      harfbuzz_features = {},
    },
    { family = "Noto Color Emoji" },
    { family = "LegacyComputing" },
  }

  Config.line_height = 1.2
  Config.font_rules = {
    {
      intensity = "Normal",
      italic = true,
      font = wt.font_with_fallback {
        {
          family = "Monaspace Radon", --"Monaspace Radon Var",
          style = "Normal",
          weight = "Regular",
          stretch = "Expanded",
          harfbuzz_features = monaspace_features,
        },
        { family = "Symbols Nerd Font" },
      },
    },
    {
      intensity = "Bold",
      italic = true,
      font = wt.font_with_fallback {
        {
          family = "Monaspace Krypton Var", --"Monaspace Krypton Var",
          style = "Italic",
          weight = "Black",
          harfbuzz_features = monaspace_features,
          scale = 1.1,
        },
        { family = "Symbols Nerd Font" },
      },
    },
  }
end

return M

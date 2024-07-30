---@module "picker.assets.fonts.monaspace-radon"
---@author sravioli, akthe-at
---@license GNU-GPLv3

---@class PickList
local M = {}

local wt = require "wezterm"

M.get = function()
  return { id = "monaspace-radon", label = "Monaspace Radon" }
end

M.activate = function(Config, _)
  Config.font = wt.font_with_fallback {
    {
      family = "Monaspace Radon",
      weight = "Regular",
      harfbuzz_features = {
        "cv06",
        "cv12",
        "cv14",
        "cv16",
        "cv25",
        "cv26",
        "cv28",
        "cv29",
        "cv31",
        "cv32",
        "ss03",
        "ss04",
        "ss05",
        "ss07",
        "ss09",
      },
    },
    { family = "Noto Color Emoji" },
    { family = "LegacyComputing" },
  }

  Config.font_rules = {
    {
      intensity = "Normal",
      italic = true,
      font = wt.font("Monaspace Radon", { weight = "Regular" }),
    },
    {
      intensity = "Bold",
      italic = false,
      font = wt.font("Monaspace Neon", { weight = "ExtraBold" }),
    },
    {
      intensity = "Bold",
      italic = true,
      font = wt.font("Monaspace Radon", { weight = "ExtraBold" }),
    },
  }
end

return M

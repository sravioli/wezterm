---@diagnostic disable: undefined-field

local wt = require "wezterm"

local FontPicker = require("picker.generic"):init()
FontPicker.title = "Font Picker"
FontPicker.choices = {}
FontPicker.fuzzy = true
-- FIX: fuzzy description doesn't seem to be implemented yet.
FontPicker.fuzzy_description = "Fuzzy find the font you want..."

--TODO: Going to redesign this so that it setups a table automatically based on
--the fonts folder and a person won't have to manually map them.
local available_fonts = {
  { name = "Reset to Default", mod = "fonts.font-reset" },
  { name = "Maple Mono", mod = "fonts.font-maple" },
  { name = "JetBrainsMono Nerd Font", mod = "fonts.font-jetbrains" },
  { name = "ComicShannsMono Nerd Font", mod = "fonts.font-commicshanns" },
  { name = "Hack Nerd Font", mod = "fonts.font-hack" },
  { name = "Pragmasevka Nerd Font", mod = "fonts.font-pragmasevka" },
  { name = "Monaspace Neon", mod = "fonts.font-monaspace-neon" },
  { name = "Monaspace Argon", mod = "fonts.font-monaspace-argon" },
  { name = "Monaspace Krypton Var", mod = "fonts.font-monaspace-krypton" },
  { name = "Monaspace Radon", mod = "fonts.font-monaspace-radon" },
  { name = "Monaspace Xenon", mod = "fonts.font-monaspace-xenon" },
  { name = "UbuntuMono Nerd Font", mod = "fonts.font-ubuntu" },
  { name = "CommitMonoAK", mod = "fonts.font-commitmonoak" },
  { name = "CaskaydiaCove Nerd Font", mod = "fonts.font-caskaydiacove" },
  { name = "Victor Mono", mod = "fonts.font-victor" },
  { name = "FiraCode Nerd Font", mod = "fonts.font-firacode" },
  { name = "DroidSansM Nerd Font", mod = "fonts.font-droidsans" },
  { name = "D2CodingLigature Nerd Font", mod = "fonts.font-d2coding" },
  { name = "Cascadia Code PL", mod = "fonts.font-cascadiaPL" },
  { name = "Cascadia Code Mono NF", mod = "fonts.font-cascadiaNF" },
}

local register_fonts = function(opts)
  for _, v in ipairs(opts or {}) do
    local name = v.name or v.mod
    FontPicker.choices[name] = v
  end
end

FontPicker.select = function(config, name)
  local font = FontPicker.choices[name]
  require(font.mod)(config, font.opts)
end

register_fonts(available_fonts)

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
---@class config
---@field command_palette_bg_color string Specifies the background color used by
---       `ActivateCommandPalette`. Defaults to `"#333333"`.
---@field command_palette_fg_color string Specifies the text color used by
---       `ActivateCommandPalette`. Defaults to `rgba(0.75, 0.75, 0.75, 1.0)`.
---@field command_palette_font_size integer Specifies the size of the font used with
---       `ActivateCommandPalette`. Defaults to `14`.
---@field char_select_bg_color string Specifies the background color used by `CharSelect`.
---       Defaults to `"#333333"`.
---@field char_select_fg_color string Specifies the foreground color used by `CharSelect`.
---       Defaults to `rgba(0.75, 0.75, 0.75, 1.0)`.
---@field char_select_font_size string Specifies the size of the font used with `CharSelect`.
---       Defaults to `14`
local config = {}

---Set options for bg, fg and font size for both command-palette and char-select
for key, value in pairs { bg_color = "#957fb8", fg_color = "#1f1f28", font_size = 12 } do
  for _, prefix in pairs { "command_palette_", "char_select_" } do
    config[prefix .. key] = value
  end
end

return config

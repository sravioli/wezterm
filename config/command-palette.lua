---@class config
local config = {}

---Set options for bg, fg and font size for both command-palette and char-select
for key, value in pairs { bg_color = "#957fb8", fg_color = "#1f1f28", font_size = 12 } do
  for _, prefix in pairs { "command_palette_", "char_select_" } do
    config[prefix .. key] = value
  end
end

return config

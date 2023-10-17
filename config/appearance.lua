local wezterm = require "wezterm"

local colorschemes = require "colorschemes"

return {
  color_schemes = colorschemes, -- load custom color schemes
  color_scheme = "kanagawa", -- use kanagawa
  force_reverse_video_cursor = true,

  use_fancy_tab_bar = true,
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  tab_bar_at_bottom = false,

  font = wezterm.font "FiraCode Nerd Font",

  enable_scroll_bar = true,

  -- it's not working right now
  -- window_background_opacity = 0,
  -- win32_system_backdrop = "Mica",

  window_decorations = "TITLE | RESIZE",
}

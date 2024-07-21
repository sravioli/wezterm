local main = {
  base = "#232136",
  overlay = "#393552",
  muted = "#6e6a86",
  text = "#e0def4",
  love = "#eb6f92",
  gold = "#f6c177",
  rose = "#ea9a97",
  pine = "#3e8fb0",
  foam = "#9ccfd8",
  iris = "#c4a7e7",
  highlight_high = "#56526e",
  rosewater = "#ebbcba",
}
local colorscheme = {
  foreground = main.text,
  background = main.base,
  cursor_bg = main.rose,
  cursor_border = main.rose,
  cursor_fg = main.base,
  selection_bg = main.gold,
  selection_fg = "rgba(0% 0% 0% 0%)",
  ansi = {
    main.overlay,
    main.love,
    main.gold,
    main.foam,
    main.pine,
    main.iris,
    main.rosewater,
    main.text,
  },
  brights = {
    main.rosewater,
    main.love,
    main.gold,
    main.foam,
    main.pine,
    main.iris,
    main.highlight_high,
    main.text,
  },
  tab_bar = {
    background = main.base,
    inactive_tab_edge = main.base,
    active_tab = {
      bg_color = main.base,
      fg_color = main.pine,
    },
    inactive_tab = {
      bg_color = main.base,
      fg_color = main.rose,
    },

    inactive_tab_hover = {
      bg_color = main.rose,
      fg_color = main.base,
      italic = false,
    },
    new_tab = {
      bg_color = main.love,
      fg_color = main.base,
    },
    new_tab_hover = {
      bg_color = main.rose,
      fg_color = main.base,
      italic = false,
      strikethrough = false,
    },
  },
  visual_bell = main.muted,
  indexed = {
    [16] = main.love,
    [17] = main.rose,
  },
  scrollbar_thumb = main.muted,
  split = main.muted,
  compose_cursor = main.rose, -- nightbuild only
  copy_mode_active_highlight_bg = { Color = "#223249" },
  copy_mode_active_highlight_fg = { Color = "#DCD7BA" },
  copy_mode_inactive_highlight_bg = { Color = "#C8C093" },
  copy_mode_inactive_highlight_fg = { Color = "#16161D" },

  quick_select_label_bg = { Color = "#FF5D62" },
  quick_select_label_fg = { Color = "#DCD7BA" },
  quick_select_match_bg = { Color = "#FF9E3B" },
  quick_select_match_fg = { Color = "#DCD7BA" },
}

return colorscheme

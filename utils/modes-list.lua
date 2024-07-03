local theme = require("colors")[require("utils.fun").get_scheme()]

return {
  copy_mode = { text = " 󰆏 COPY ", bg = theme.brights[3], pad = 8 },
  search_mode = { text = " 󰍉 SEARCH ", bg = theme.brights[4], pad = 7 },
  window_mode = { text = " 󱂬 WINDOW ", bg = theme.ansi[6], pad = 7 },
  font_mode = { text = " 󰛖 FONT ", bg = theme.indexed[16] or theme.ansi[8], pad = 7 },
  lock_mode = { text = "  LOCK ", bg = theme.ansi[8], pad = 0 },
  help_mode = { text = " 󰞋 NORMAL ", bg = theme.ansi[5], pad = 9 },
}

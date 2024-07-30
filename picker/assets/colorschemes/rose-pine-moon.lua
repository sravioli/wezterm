---Ported from: https://github.com/neapsix/wezterm
---@module "picker.assets.colorschemes.rose-pine-moon"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#232136",
  foreground = "#E0DEF4",
  cursor_bg = "#59546D",
  cursor_fg = "#E0DEF4",
  cursor_border = "#59546D",
  selection_fg = "#E0DEF4",
  selection_bg = "#393552",
  scrollbar_thumb = "#393552",
  split = "#6E6A86",
  ansi = {
    "#393552",
    "#EB6F92",
    "#3E8FB0",
    "#F6C177",
    "#9CCFD8",
    "#C4A7E7",
    "#EBBCBA",
    "#E0DEF4",
  },
  brights = {
    "#817C9C",
    "#EB6F92",
    "#3E8FB0",
    "#F6C177",
    "#9CCFD8",
    "#C4A7E7",
    "#EBBCBA",
    "#E0DEF4",
  },
  indexed = {},

  compose_cursor = "#C4A7E7",
  copy_mode_active_highlight_bg = { Color = "#393552" },
  copy_mode_active_highlight_fg = { Color = "#E0DEF4" },
  copy_mode_inactive_highlight_bg = { Color = "#59546D" },
  copy_mode_inactive_highlight_fg = { Color = "#E0DEF4" },
  quick_select_label_bg = { Color = "#EB6F92" },
  quick_select_label_fg = { Color = "#E0DEF4" },
  quick_select_match_bg = { Color = "#F6C177" },
  quick_select_match_fg = { Color = "#E0DEF4" },
  visual_bell = "#E0DEF4",
  tab_bar = {
    background = "#232136",
    inactive_tab_edge = "#6E6A86",
    active_tab = { bg_color = "#393552", fg_color = "#E0DEF4" },
    inactive_tab = { bg_color = "#232136", fg_color = "#6E6A86" },
    inactive_tab_hover = { bg_color = "#393552", fg_color = "#E0DEF4" },
    new_tab = { bg_color = "#232136", fg_color = "#6E6A86" },
    new_tab_hover = { bg_color = "#393552", fg_color = "#E0DEF4" },
  },
}

function M.get()
  return { id = "rose-pine-moon", label = "Rosé Pine Moon" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

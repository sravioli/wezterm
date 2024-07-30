---Ported from: https://github.com/neapsix/wezterm
---@module "picker.assets.colorschemes.rose-pine"
---@author sravioli, akthe-at
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  foreground = "#E0DEF4",
  background = "#191724",
  cursor_bg = "#524F67",
  cursor_fg = "#E0DEF4",
  cursor_border = "#524F67",
  selection_bg = "#2A283E",
  selection_fg = "#E0DEF4",
  scrollbar_thumb = "#2A283E",
  split = "#6E6A86",
  ansi = {
    "#26233A",
    "#EB6F92",
    "#31748F",
    "#F6C177",
    "#9CCFD8",
    "#C4A7E7",
    "#EBBCBA",
    "#E0DEF4",
  },
  brights = {
    "#6E6A86",
    "#EB6F92",
    "#31748F",
    "#F6C177",
    "#9CCFD8",
    "#C4A7E7",
    "#EBBCBA",
    "#E0DEF4",
  },

  indexed = {},
  compose_cursor = "#C4A7E7",
  copy_mode_active_highlight_bg = { Color = "#2A283E" },
  copy_mode_active_highlight_fg = { Color = "#E0DEF4" },
  copy_mode_inactive_highlight_bg = { Color = "#524F67" },
  copy_mode_inactive_highlight_fg = { Color = "#E0DEF4" },
  quick_select_label_bg = { Color = "#EB6F92" },
  quick_select_label_fg = { Color = "#E0DEF4" },
  quick_select_match_bg = { Color = "#F6C177" },
  quick_select_match_fg = { Color = "#E0DEF4" },
  visual_bell = "#E0DEF4",
  tab_bar = {
    background = "#191724",
    inactive_tab_edge = "#6E6A86",
    active_tab = { bg_color = "#26233A", fg_color = "#E0DEF4" },
    inactive_tab = { bg_color = "#191724", fg_color = "#6E6A86" },
    inactive_tab_hover = { bg_color = "#26233A", fg_color = "#E0DEF4" },
    new_tab = { bg_color = "#191724", fg_color = "#6E6A86" },
    new_tab_hover = { bg_color = "#26233A", fg_color = "#E0DEF4" },
  },
}

function M.get()
  return { id = "rose-pine", label = "Rosé Pine" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

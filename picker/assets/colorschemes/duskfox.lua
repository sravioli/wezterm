---Ported from https://www.github.com/EdenEast/nightfox.nvim
---@module "picker.assets.colorschemes.duskfox"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#232136",
  foreground = "#E0DEF4",
  cursor_bg = "#E0DEF4",
  cursor_fg = "#232136",
  cursor_border = "#E0DEF4",
  selection_bg = "#433C59",
  selection_fg = "#E0DEF4",
  scrollbar_thumb = "#6E6A86",
  split = "#191726",
  ansi = {
    "#393552",
    "#EB6F92",
    "#A3BE8C",
    "#F6C177",
    "#569FBA",
    "#C4A7E7",
    "#9CCFD8",
    "#E0DEF4",
  },
  brights = {
    "#47407D",
    "#F083A2",
    "#B1D196",
    "#F9CB8C",
    "#65B1CD",
    "#CCB1ED",
    "#A6DAE3",
    "#E2E0F7",
  },
  indexed = { [16] = "#EB98C3", [17] = "#EA9A97" },
  compose_cursor = "#EA9A97",
  copy_mode_active_highlight_bg = { Color = "#433C59" },
  copy_mode_active_highlight_fg = { Color = "#E0DEF4" },
  copy_mode_inactive_highlight_bg = { Color = "#47407D" },
  copy_mode_inactive_highlight_fg = { Color = "#E2E0F7" },
  quick_select_label_bg = { Color = "#EB6F92" },
  quick_select_label_fg = { Color = "#E0DEF4" },
  quick_select_match_bg = { Color = "#F6C177" },
  quick_select_match_fg = { Color = "#E0DEF4" },
  visual_bell = "#E0DEF4",
  tab_bar = {
    background = "#191726",
    inactive_tab_edge = "#191726",
    active_tab = { bg_color = "#6E6A86", fg_color = "#232136" },
    inactive_tab = { bg_color = "#2D2A45", fg_color = "#CDCBE0" },
    inactive_tab_hover = { bg_color = "#373354", fg_color = "#E0DEF4", italic = false },
    new_tab = { bg_color = "#232136", fg_color = "#CDCBE0" },
    new_tab_hover = { bg_color = "#373354", fg_color = "#E0DEF4", italic = false },
  },
}

function M.get()
  return { id = "duskfox", label = "Duskfox" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

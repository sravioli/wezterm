---Ported from: https://github.com/dracula/wezterm
---@module "picker.assets.colorschemes.dracula"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#282A36",
  foreground = "#F8F8F2",
  cursor_bg = "#F8F8F2",
  cursor_fg = "#282A36",
  cursor_border = "#F8F8F2",
  selection_fg = "#F8F8F2",
  selection_bg = "rgba(68,71,90,0.5)",
  scrollbar_thumb = "#44475A",
  split = "#6272A4",
  ansi = {
    "#21222C",
    "#FF5555",
    "#50FA7B",
    "#F1FA8C",
    "#BD93F9",
    "#FF79C6",
    "#8BE9FD",
    "#F8F8F2",
  },
  brights = {
    "#6272A4",
    "#FF6E6E",
    "#69FF94",
    "#FFFFA5",
    "#D6ACFF",
    "#FF92DF",
    "#A4FFFF",
    "#FFFFFF",
  },
  indexed = {},
  compose_cursor = "#FFB86C",
  visual_bell = "#44475A",
  copy_mode_active_highlight_bg = { Color = "#44475A" },
  copy_mode_active_highlight_fg = { Color = "#F8F8F2" },
  copy_mode_inactive_highlight_bg = { Color = "#21222C" },
  copy_mode_inactive_highlight_fg = { Color = "#F8F8F2" },
  quick_select_label_bg = { Color = "#FF5555" },
  quick_select_label_fg = { Color = "#F8F8F2" },
  quick_select_match_bg = { Color = "#F1FA8C" },
  quick_select_match_fg = { Color = "#F8F8F2" },
  tab_bar = {
    background = "#282A36",
    inactive_tab_edge = "#282A36",
    active_tab = { bg_color = "#BD93F9", fg_color = "#282A36", italic = false },
    inactive_tab = { bg_color = "#282A36", fg_color = "#F8F8F2" },
    inactive_tab_hover = { bg_color = "#6272A4", fg_color = "#F8F8F2", italic = true },
    new_tab = { bg_color = "#282A36", fg_color = "#F8F8F2" },
    new_tab_hover = { bg_color = "#FF79C6", fg_color = "#F8F8F2", italic = true },
  },
}

function M.get()
  return { id = "dracula", label = "Dracula" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

---Ported from: https://github.com/catppuccin/wezterm
---@module "picker.assets.colorschemes.catppuccin-latte"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#EFF1F5",
  foreground = "#4C4F69",
  cursor_bg = "#DC8A78",
  cursor_fg = "#DCE0E8",
  cursor_border = "#DC8A78",
  selection_fg = "#4C4F69",
  selection_bg = "#ACB0BE",
  scrollbar_thumb = "#ACB0BE",
  split = "#9CA0B0",
  ansi = {
    "#BCC0CC",
    "#D20F39",
    "#40A02B",
    "#DF8E1D",
    "#1E66F5",
    "#EA76CB",
    "#179299",
    "#5C5F77",
  },
  brights = {
    "#ACB0BE",
    "#D20F39",
    "#40A02B",
    "#DF8E1D",
    "#1E66F5",
    "#EA76CB",
    "#179299",
    "#6C6F85",
  },
  indexed = { [16] = "#FE640B", [17] = "#DC8A78" },
  compose_cursor = "#DD7878",
  visual_bell = "#CCD0DA",
  copy_mode_active_highlight_bg = { Color = "#ACB0BE" },
  copy_mode_active_highlight_fg = { Color = "#4C4F69" },
  copy_mode_inactive_highlight_bg = { Color = "#BCC0CC" },
  copy_mode_inactive_highlight_fg = { Color = "#4C4F69" },
  quick_select_label_bg = { Color = "#D20F39" },
  quick_select_label_fg = { Color = "#4C4F69" },
  quick_select_match_bg = { Color = "#DF8E1D" },
  quick_select_match_fg = { Color = "#4C4F69" },
  tab_bar = {
    background = "#DCE0E8",
    inactive_tab_edge = "#CCD0DA",
    active_tab = { bg_color = "#8839EF", fg_color = "#DCE0E8", italic = false },
    inactive_tab = { bg_color = "#E6E9EF", fg_color = "#4C4F69", italic = false },
    inactive_tab_hover = { bg_color = "#EFF1F5", fg_color = "#4C4F69", italic = false },
    new_tab = { bg_color = "#CCD0DA", fg_color = "#4C4F69", italic = false },
    new_tab_hover = { bg_color = "#BCC0CC", fg_color = "#4C4F69", italic = false },
  },
}

function M.get()
  return { id = "catppuccin-latte", label = "Catppuccin Latte" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

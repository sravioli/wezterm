---Ported from: https://github.com/catppuccin/wezterm
---@module "picker.assets.colorschemes.catppuccin-mocha"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#1E1E2E",
  foreground = "#CDD6F4",
  cursor_bg = "#F5E0DC",
  cursor_fg = "#11111B",
  cursor_border = "#F5E0DC",
  selection_fg = "#CDD6F4",
  selection_bg = "#585B70",
  scrollbar_thumb = "#585B70",
  split = "#6C7086",
  ansi = {
    "#45475A",
    "#F38BA8",
    "#A6E3A1",
    "#F9E2AF",
    "#89B4FA",
    "#F5C2E7",
    "#94E2D5",
    "#BAC2DE",
  },
  brights = {
    "#585B70",
    "#F38BA8",
    "#A6E3A1",
    "#F9E2AF",
    "#89B4FA",
    "#F5C2E7",
    "#94E2D5",
    "#A6ADC8",
  },
  indexed = { [16] = "#FAB387", [17] = "#F5E0DC" },
  compose_cursor = "#F2CDCD",
  visual_bell = "#313244",
  copy_mode_active_highlight_bg = { Color = "#585B70" },
  copy_mode_active_highlight_fg = { Color = "#CDD6F4" },
  copy_mode_inactive_highlight_bg = { Color = "#45475A" },
  copy_mode_inactive_highlight_fg = { Color = "#CDD6F4" },
  quick_select_label_bg = { Color = "#F38BA8" },
  quick_select_label_fg = { Color = "#CDD6F4" },
  quick_select_match_bg = { Color = "#F9E2AF" },
  quick_select_match_fg = { Color = "#CDD6F4" },
  tab_bar = {
    background = "#11111B",
    inactive_tab_edge = "#313244",
    active_tab = { bg_color = "#CBA6F7", fg_color = "#11111B", italic = false },
    inactive_tab = { bg_color = "#181825", fg_color = "#CDD6F4", italic = false },
    inactive_tab_hover = { bg_color = "#1E1E2E", fg_color = "#CDD6F4", italic = false },
    new_tab = { bg_color = "#313244", fg_color = "#CDD6F4", italic = false },
    new_tab_hover = { bg_color = "#45475A", fg_color = "#CDD6F4", italic = false },
  },
}

function M.get()
  return { id = "catppuccin-mocha", label = "Catppuccin Mocha" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

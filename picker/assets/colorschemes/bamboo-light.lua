---@module "picker.assets.colorschemes.bamboo-light"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#FAFAE0",
  foreground = "#3A4238",
  cursor_bg = "#0F0800",
  cursor_fg = "#FFF8F0",
  cursor_border = "#0F0800",
  selection_bg = "#A1A7A0",
  selection_fg = "#3A4238",
  scrollbar_thumb = "#C7C7AF",
  split = "#838781",
  ansi = {
    "#DADAC2",
    "#C72A3C",
    "#27850B",
    "#A77B00",
    "#1745D5",
    "#8A4ADF",
    "#188A9E",
    "#3A4238",
  },
  brights = {
    "#C7C7AF",
    "#C72A3C",
    "#27850B",
    "#A77B00",
    "#1745D5",
    "#8A4ADF",
    "#188A9E",
    "#252623",
  },
  indexed = {},
  compose_cursor = "#DF5926",
  visual_bell = "#E4E4CC",
  copy_mode_active_highlight_bg = { Color = "#A1A7A0" },
  copy_mode_active_highlight_fg = { Color = "#3A4238" },
  copy_mode_inactive_highlight_bg = { Color = "#C7C7AF" },
  copy_mode_inactive_highlight_fg = { Color = "#0F0800" },
  quick_select_label_bg = { Color = "#C72A3C" },
  quick_select_label_fg = { Color = "#3A4238" },
  quick_select_match_bg = { Color = "#A77B00" },
  quick_select_match_fg = { Color = "#3A4238" },
  tab_bar = {
    background = "#E4E4CC",
    inactive_tab_edge = "#DADAC2",
    active_tab = { bg_color = "#3A4238", fg_color = "#FAFAE0" },
    inactive_tab = { bg_color = "#C7C7AF", fg_color = "#5B5E5A" },
    inactive_tab_hover = { bg_color = "#838781", fg_color = "#DADAC2", italic = true },
    new_tab = { bg_color = "#A1A7A0", fg_color = "#DADAC2" },
    new_tab_hover = { bg_color = "#838781", fg_color = "#3A4238", italic = false },
  },
}

function M.get()
  return { id = "bamboo-light", label = "Bamboo Light" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

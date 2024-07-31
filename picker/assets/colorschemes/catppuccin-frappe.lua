---Ported from: https://github.com/catppuccin/wezterm
---@module "picker.assets.colorschemes.catppuccin-frappe"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#303446",
  foreground = "#C6D0F5",
  cursor_bg = "#F2D5CF",
  cursor_fg = "#232634",
  cursor_border = "#F2D5CF",
  selection_fg = "#C6D0F5",
  selection_bg = "#626880",
  scrollbar_thumb = "#626880",
  split = "#737994",
  ansi = {
    "#51576D",
    "#E78284",
    "#A6D189",
    "#E5C890",
    "#8CAAEE",
    "#F4B8E4",
    "#81C8BE",
    "#B5BFE2",
  },
  brights = {
    "#626880",
    "#E78284",
    "#A6D189",
    "#E5C890",
    "#8CAAEE",
    "#F4B8E4",
    "#81C8BE",
    "#A5ADCE",
  },
  indexed = { [16] = "#EF9F76", [17] = "#F2D5CF" },
  compose_cursor = "#EEBEBE",
  visual_bell = "#414559",
  copy_mode_active_highlight_bg = { Color = "#626880" },
  copy_mode_active_highlight_fg = { Color = "#C6D0F5" },
  copy_mode_inactive_highlight_bg = { Color = "#51576D" },
  copy_mode_inactive_highlight_fg = { Color = "#C6D0F5" },
  quick_select_label_bg = { Color = "#E78284" },
  quick_select_label_fg = { Color = "#C6D0F5" },
  quick_select_match_bg = { Color = "#E5C890" },
  quick_select_match_fg = { Color = "#C6D0F5" },
  tab_bar = {
    background = "#232634",
    active_tab = { bg_color = "#CA9EE6", fg_color = "#232634" },
    inactive_tab = { bg_color = "#292C3C", fg_color = "#C6D0F5" },
    inactive_tab_hover = { bg_color = "#303446", fg_color = "#C6D0F5", italic = false },
    new_tab = { bg_color = "#414559", fg_color = "#C6D0F5" },
    new_tab_hover = { bg_color = "#51576D", fg_color = "#C6D0F5", italic = false },
  },
}

function M.get()
  return { id = "catppuccin-frappe", label = "Catppuccin Frappe" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

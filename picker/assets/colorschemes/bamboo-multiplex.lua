---@module "picker.assets.colorschemes.bamboo-multiplex"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#232923",
  foreground = "#ECE1C0",
  cursor_bg = "#FFF8F0",
  cursor_fg = "#0F0800",
  cursor_border = "#FFF8F0",
  selection_bg = "#5A5E5A",
  selection_fg = "#ECE1C0",
  scrollbar_thumb = "#171F17",
  split = "#818781",
  ansi = {
    "#171F17",
    "#DC4F62",
    "#81AF58",
    "#CEBA49",
    "#409CDC",
    "#A09AF8",
    "#68BAAE",
    "#ECE1C0",
  },
  brights = {
    "#5A5E5A",
    "#DC4F62",
    "#81AF58",
    "#CEBA49",
    "#409CDC",
    "#A09AF8",
    "#68BAAE",
    "#FFF8F0",
  },
  indexed = {},
  compose_cursor = "#EF9946",
  visual_bell = "#363B35",
  copy_mode_active_highlight_bg = { Color = "#5A5E5A" },
  copy_mode_active_highlight_fg = { Color = "#ECE1C0" },
  copy_mode_inactive_highlight_bg = { Color = "#5A5E5A" },
  copy_mode_inactive_highlight_fg = { Color = "#0F0800" },
  quick_select_label_bg = { Color = "#DC4F62" },
  quick_select_label_fg = { Color = "#ECE1C0" },
  quick_select_match_bg = { Color = "#CEBA49" },
  quick_select_match_fg = { Color = "#ECE1C0" },
  tab_bar = {
    background = "#171F17",
    inactive_tab_edge = "#383D37",
    active_tab = { bg_color = "#ECE1C0", fg_color = "#101210" },
    inactive_tab = { bg_color = "#383D37", fg_color = "#5A5E5A" },
    inactive_tab_hover = { bg_color = "#2D312C", fg_color = "#818781", italic = true },
    new_tab = { bg_color = "#5A5E5A", fg_color = "#ECE1C0" },
    new_tab_hover = { bg_color = "#818781", fg_color = "#ECE1C0", italic = false },
  },
}

function M.get()
  return { id = "bamboo-multiplex", label = "Bamboo Multiplex" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

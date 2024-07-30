---Ported from https://www.github.com/EdenEast/nightfox.nvim
---@module "picker.assets.colorschemes.nordfox"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#2E3440",
  foreground = "#CDCECF",
  cursor_bg = "#CDCECF",
  cursor_fg = "#2E3440",
  cursor_border = "#CDCECF",
  selection_bg = "#3E4A5B",
  selection_fg = "#CDCECF",
  scrollbar_thumb = "#7E8188",
  split = "#232831",
  ansi = {
    "#3B4252",
    "#BF616A",
    "#A3BE8C",
    "#EBCB8B",
    "#81A1C1",
    "#B48EAD",
    "#88C0D0",
    "#E5E9F0",
  },
  brights = {
    "#465780",
    "#D06F79",
    "#B1D196",
    "#F0D399",
    "#8CAFD2",
    "#C895BF",
    "#93CCDC",
    "#E7ECF4",
  },
  indexed = { [16] = "#BF88BC", [17] = "#C9826B" },
  compose_cursor = "#C9826B",
  copy_mode_active_highlight_bg = { Color = "#3E4A5B" },
  copy_mode_active_highlight_fg = { Color = "#CDCECF" },
  copy_mode_inactive_highlight_bg = { Color = "#465780" },
  copy_mode_inactive_highlight_fg = { Color = "#E7ECF4" },
  quick_select_label_bg = { Color = "#BF616A" },
  quick_select_label_fg = { Color = "#CDCECF" },
  quick_select_match_bg = { Color = "#EBCB8B" },
  quick_select_match_fg = { Color = "#CDCECF" },
  visual_bell = "#CDCECF",
  tab_bar = {
    background = "#232831",
    inactive_tab_edge = "#232831",
    active_tab = { bg_color = "#7E8188", fg_color = "#2E3440" },
    inactive_tab = { bg_color = "#39404F", fg_color = "#ABB1BB" },
    inactive_tab_hover = { bg_color = "#444C5E", fg_color = "#CDCECF", italic = false },
    new_tab = { bg_color = "#2E3440", fg_color = "#ABB1BB" },
    new_tab_hover = { bg_color = "#444C5E", fg_color = "#CDCECF", italic = false },
  },
}

function M.get()
  return { id = "nordfox", label = "Nordfox" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

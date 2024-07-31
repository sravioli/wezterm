---Ported from: https://github.com/folke/tokyonight.nvim
---@module "picker.assets.colorschemes.tokyonight-night"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  foreground = "#C0CAF5",
  background = "#1A1B26",
  cursor_bg = "#C0CAF5",
  cursor_fg = "#1A1B26",
  cursor_border = "#C0CAF5",
  selection_bg = "#283457",
  selection_fg = "#C0CAF5",
  scrollbar_thumb = "#292E42",
  split = "#7AA2F7",
  ansi = {
    "#15161E",
    "#F7768E",
    "#9ECE6A",
    "#E0AF68",
    "#7AA2F7",
    "#BB9AF7",
    "#7DCFFF",
    "#A9B1D6",
  },
  brights = {
    "#414868",
    "#F7768E",
    "#9ECE6A",
    "#E0AF68",
    "#7AA2F7",
    "#BB9AF7",
    "#7DCFFF",
    "#C0CAF5",
  },
  indexed = {},
  compose_cursor = "#FF9E64",
  copy_mode_active_highlight_bg = { Color = "#283457" },
  copy_mode_active_highlight_fg = { Color = "#C0CAF5" },
  copy_mode_inactive_highlight_bg = { Color = "#292E42" },
  copy_mode_inactive_highlight_fg = { Color = "#C0CAF5" },
  quick_select_label_bg = { Color = "#F7768E" },
  quick_select_label_fg = { Color = "#C0CAF5" },
  quick_select_match_bg = { Color = "#E0AF68" },
  quick_select_match_fg = { Color = "#C0CAF5" },
  visual_bell = "#283457",
  tab_bar = {
    background = "#1A1B26",
    inactive_tab_edge = "#16161E",
    active_tab = { fg_color = "#16161E", bg_color = "#7AA2F7" },
    inactive_tab = { fg_color = "#545C7E", bg_color = "#292E42" },
    inactive_tab_hover = { fg_color = "#7AA2F7", bg_color = "#292E42" },
    new_tab = { fg_color = "#7AA2F7", bg_color = "#1A1B26" },
    new_tab_hover = { fg_color = "#7AA2F7", bg_color = "#1A1B26", intensity = "Bold" },
  },
}

function M.get()
  return { id = "tokyonight-night", label = "Tokyonight Night" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

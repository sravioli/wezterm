---Ported from: https://github.com/folke/tokyonight.nvim
---@module "picker.assets.colorschemes.tokyonight-day"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  foreground = "#3760BF",
  background = "#E1E2E7",
  cursor_bg = "#3760BF",
  cursor_fg = "#E1E2E7",
  cursor_border = "#3760BF",
  selection_bg = "#B7C1E3",
  selection_fg = "#3760BF",
  scrollbar_thumb = "#C4C8DA",
  split = "#2E7DE9",
  ansi = {
    "#B4B5B9",
    "#F52A65",
    "#587539",
    "#8C6C3E",
    "#2E7DE9",
    "#9854F1",
    "#007197",
    "#6172B0",
  },
  brights = {
    "#A1A6C5",
    "#F52A65",
    "#587539",
    "#8C6C3E",
    "#2E7DE9",
    "#9854F1",
    "#007197",
    "#3760BF",
  },
  indexed = {},
  compose_cursor = "#B15C00",
  copy_mode_active_highlight_bg = { Color = "#B7C1E3" },
  copy_mode_active_highlight_fg = { Color = "#3760BF" },
  copy_mode_inactive_highlight_bg = { Color = "#C4C8DA" },
  copy_mode_inactive_highlight_fg = { Color = "#3760BF" },
  quick_select_label_bg = { Color = "#F52A65" },
  quick_select_label_fg = { Color = "#3760BF" },
  quick_select_match_bg = { Color = "#8C6C3E" },
  quick_select_match_fg = { Color = "#3760BF" },
  visual_bell = "#B7C1E3",
  tab_bar = {
    background = "#E1E2E7",
    inactive_tab_edge = "#D0D5E3",
    active_tab = { fg_color = "#D0D5E3", bg_color = "#2E7DE9" },
    inactive_tab = { fg_color = "#8990B3", bg_color = "#C4C8DA" },
    inactive_tab_hover = { fg_color = "#2E7DE9", bg_color = "#C4C8DA" },
    new_tab = { fg_color = "#2E7DE9", bg_color = "#E1E2E7" },
    new_tab_hover = { fg_color = "#2E7DE9", bg_color = "#E1E2E7", intensity = "Bold" },
  },
}

function M.get()
  return { id = "tokyonight-day", label = "Tokyonight Day" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

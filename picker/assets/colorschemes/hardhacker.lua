---Ported from: https://github.com/hardhackerlabs/theme-wezterm
---@module "picker.assets.colorschemes.hardhacker"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#282433",
  foreground = "#EEE9FC",
  cursor_bg = "#EEE9FC",
  cursor_fg = "#EEE9FC",
  cursor_border = "#EEE9FC",
  selection_bg = "#E965A5",
  selection_fg = "#EEE9FC",
  scrollbar_thumb = "#3F3951",
  split = "#938AAD",
  ansi = {
    "#282433",
    "#E965A5",
    "#B1F2A7",
    "#EBDE76",
    "#B1BAF4",
    "#E192EF",
    "#B3F4F3",
    "#EEE9FC",
  },
  brights = {
    "#3F3951",
    "#E965A5",
    "#B1F2A7",
    "#EBDE76",
    "#B1BAF4",
    "#E192EF",
    "#B3F4F3",
    "#EEE9FC",
  },
  indexed = {},
  compose_cursor = "#EBDE76",
  visual_bell = "#3F3951",
  copy_mode_active_highlight_bg = { Color = "#E965A5" },
  copy_mode_active_highlight_fg = { Color = "#EEE9FC" },
  copy_mode_inactive_highlight_bg = { Color = "#3F3951" },
  copy_mode_inactive_highlight_fg = { Color = "#938AAD" },
  quick_select_label_bg = { Color = "#E965A5" },
  quick_select_label_fg = { Color = "#EEE9FC" },
  quick_select_match_bg = { Color = "#EBDE76" },
  quick_select_match_fg = { Color = "#EEE9FC" },
  tab_bar = {
    background = "#282433",
    inactive_tab_edge = "#282433",
    active_tab = { bg_color = "#282433", fg_color = "#E965A5", italic = false },
    inactive_tab = { bg_color = "#282433", fg_color = "#938AAD", italic = false },
    inactive_tab_hover = { bg_color = "#E192EF", fg_color = "#EEE9FC", italic = false },
    new_tab = { bg_color = "#282433", fg_color = "#938AAD", italic = false },
    new_tab_hover = { bg_color = "#E192EF", fg_color = "#EEE9FC", italic = true },
  },
}

function M.get()
  return { id = "hardhacker", label = "Hardhacker" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

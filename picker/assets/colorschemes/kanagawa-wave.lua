---Ported from: https://github.com/rebelot/kanagawa.nvim
---@module "picker.assets.colorschemes.kanagawa-wave"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#1F1F28",
  foreground = "#DCD7BA",
  cursor_bg = "#C8C093",
  cursor_fg = "#16161D",
  cursor_border = "#C8C093",
  selection_fg = "#DCD7BA",
  selection_bg = "#223249",
  scrollbar_thumb = "#223249",
  split = "#54546D",
  ansi = {
    "#16161D",
    "#C34043",
    "#76946A",
    "#C0A36E",
    "#7E9CD8",
    "#957FB8",
    "#6A9589",
    "#C8C093",
  },
  brights = {
    "#727169",
    "#E82424",
    "#98BB6C",
    "#E6C384",
    "#7FB4CA",
    "#938AA9",
    "#7AA89F",
    "#DCD7BA",
  },
  indexed = { [16] = "#FFA066", [17] = "#FF5D62" },
  compose_cursor = "#938AA9",
  visual_bell = "#16161D",
  copy_mode_active_highlight_bg = { Color = "#223249" },
  copy_mode_active_highlight_fg = { Color = "#DCD7BA" },
  copy_mode_inactive_highlight_bg = { Color = "#C8C093" },
  copy_mode_inactive_highlight_fg = { Color = "#16161D" },
  quick_select_label_bg = { Color = "#FF5D62" },
  quick_select_label_fg = { Color = "#DCD7BA" },
  quick_select_match_bg = { Color = "#FF9E3B" },
  quick_select_match_fg = { Color = "#DCD7BA" },
  tab_bar = {
    background = "#16161D",
    inactive_tab_edge = "#727169",
    active_tab = { bg_color = "#7E9CD8", fg_color = "#1F1F28" },
    inactive_tab = { bg_color = "#727169", fg_color = "#181820" },
    inactive_tab_hover = { bg_color = "#223249", fg_color = "#727169", italic = true },
    new_tab = { bg_color = "#727169", fg_color = "#181820" },
    new_tab_hover = { bg_color = "#9CABCA", fg_color = "#181820", italic = true },
  },
}

function M.get()
  return { id = "kanagawa-wave", label = "Kanagawa Wave" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

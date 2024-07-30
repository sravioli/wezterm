---Ported from: https://github.com/neapsix/wezterm
---@module "picker.assets.colorschemes.rose-pine-dawn"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#FAF4ED",
  foreground = "#575279",
  cursor_bg = "#9893A5",
  cursor_fg = "#575279",
  cursor_border = "#9893A5",
  selection_fg = "#575279",
  selection_bg = "#F2E9E1",
  scrollbar_thumb = "#F2E9E1",
  split = "#9893A5",
  ansi = {
    "#F2E9DE",
    "#B4637A",
    "#286983",
    "#EA9D34",
    "#56949F",
    "#907AA9",
    "#D7827E",
    "#575279",
  },
  brights = {
    "#6E6A86",
    "#B4637A",
    "#286983",
    "#EA9D34",
    "#56949F",
    "#907AA9",
    "#D7827E",
    "#575279",
  },
  indexed = {},
  compose_cursor = "#9893A5",
  copy_mode_active_highlight_bg = { Color = "#F2E9E1" },
  copy_mode_active_highlight_fg = { Color = "#575279" },
  copy_mode_inactive_highlight_bg = { Color = "#9893A5" },
  copy_mode_inactive_highlight_fg = { Color = "#575279" },
  quick_select_label_bg = { Color = "#B4637A" },
  quick_select_label_fg = { Color = "#575279" },
  quick_select_match_bg = { Color = "#EA9D34" },
  quick_select_match_fg = { Color = "#575279" },
  visual_bell = "#575279",
  tab_bar = {
    background = "#FAF4ED",
    inactive_tab_edge = "#9893A5",
    active_tab = { bg_color = "#F2E9E1", fg_color = "#575279" },
    inactive_tab = { bg_color = "#FAF4ED", fg_color = "#9893A5" },
    inactive_tab_hover = { bg_color = "#F2E9E1", fg_color = "#575279" },
    new_tab = { bg_color = "#FAF4ED", fg_color = "#9893A5" },
    new_tab_hover = { bg_color = "#F2E9E1", fg_color = "#575279" },
  },
}

function M.get()
  return { id = "rose-pine-dawn", label = "Rosé Pine Dawn" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

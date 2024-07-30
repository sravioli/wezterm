---Ported from https://www.github.com/EdenEast/nightfox.nvim
---@module "picker.assets.colorschemes.dawnfox"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#FAF4ED",
  foreground = "#575279",
  cursor_bg = "#575279",
  cursor_fg = "#FAF4ED",
  cursor_border = "#575279",
  selection_bg = "#D0D8D8",
  selection_fg = "#575279",
  scrollbar_thumb = "#A8A3B3",
  split = "#EBE5DF",
  ansi = {
    "#575279",
    "#B4637A",
    "#618774",
    "#EA9D34",
    "#286983",
    "#907AA9",
    "#56949F",
    "#E5E9F0",
  },
  brights = {
    "#5F5695",
    "#C26D85",
    "#629F81",
    "#EEA846",
    "#2D81A3",
    "#9A80B9",
    "#5CA7B4",
    "#E6EBF3",
  },
  indexed = { [16] = "#D685AF", [17] = "#D7827E" },
  compose_cursor = "#D7827E",
  copy_mode_active_highlight_bg = { Color = "#D0D8D8" },
  copy_mode_active_highlight_fg = { Color = "#575279" },
  copy_mode_inactive_highlight_bg = { Color = "#5F5695" },
  copy_mode_inactive_highlight_fg = { Color = "#E6EBF3" },
  quick_select_label_bg = { Color = "#B4637A" },
  quick_select_label_fg = { Color = "#575279" },
  quick_select_match_bg = { Color = "#EA9D34" },
  quick_select_match_fg = { Color = "#575279" },
  visual_bell = "#575279",
  tab_bar = {
    background = "#EBE5DF",
    inactive_tab_edge = "#EBE5DF",
    active_tab = { bg_color = "#A8A3B3", fg_color = "#FAF4ED" },
    inactive_tab = { bg_color = "#EBE0DF", fg_color = "#625C87" },
    inactive_tab_hover = { bg_color = "#EBDFE4", fg_color = "#575279", italic = false },
    new_tab = { bg_color = "#FAF4ED", fg_color = "#625C87" },
    new_tab_hover = { bg_color = "#EBDFE4", fg_color = "#575279", italic = false },
  },
}

function M.get()
  return { id = "dawnfox", label = "Dawnfox" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

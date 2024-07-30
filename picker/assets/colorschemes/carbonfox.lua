---Ported from https://www.github.com/EdenEast/nightfox.nvim
---@module "picker.assets.colorschemes.carbonfox"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#161616",
  foreground = "#F2F4F8",
  cursor_bg = "#F2F4F8",
  cursor_fg = "#161616",
  cursor_border = "#F2F4F8",
  selection_bg = "#2A2A2A",
  selection_fg = "#F2F4F8",
  scrollbar_thumb = "#7B7C7E",
  split = "#0C0C0C",
  ansi = {
    "#282828",
    "#EE5396",
    "#25BE6A",
    "#08BDBA",
    "#78A9FF",
    "#BE95FF",
    "#33B1FF",
    "#DFDFE0",
  },
  brights = {
    "#484848",
    "#F16DA6",
    "#46C880",
    "#2DC7C4",
    "#8CB6FF",
    "#C8A5FF",
    "#52BDFF",
    "#E4E4E5",
  },
  indexed = { [16] = "#FF7EB6", [17] = "#3DDBD9" },
  compose_cursor = "#3DDBD9",
  copy_mode_active_highlight_bg = { Color = "#2A2A2A" },
  copy_mode_active_highlight_fg = { Color = "#F2F4F8" },
  copy_mode_inactive_highlight_bg = { Color = "#484848" },
  copy_mode_inactive_highlight_fg = { Color = "#E4E4E5" },
  quick_select_label_bg = { Color = "#EE5396" },
  quick_select_label_fg = { Color = "#F2F4F8" },
  quick_select_match_bg = { Color = "#08BDBA" },
  quick_select_match_fg = { Color = "#F2F4F8" },
  visual_bell = "#F2F4F8",
  tab_bar = {
    background = "#0C0C0C",
    inactive_tab_edge = "#0C0C0C",
    active_tab = { bg_color = "#7B7C7E", fg_color = "#161616" },
    inactive_tab = { bg_color = "#252525", fg_color = "#B6B8BB" },
    inactive_tab_hover = { bg_color = "#353535", fg_color = "#F2F4F8", italic = false },
    new_tab = { bg_color = "#161616", fg_color = "#B6B8BB" },
    new_tab_hover = { bg_color = "#353535", fg_color = "#F2F4F8", italic = false },
  },
}

function M.get()
  return { id = "carbonfox", label = "Carbonfox" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

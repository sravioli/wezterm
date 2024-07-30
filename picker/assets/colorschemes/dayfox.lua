---Ported from https://www.github.com/EdenEast/nightfox.nvim
---@module "picker.assets.colorschemes.dayfox"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#F6F2EE",
  foreground = "#3D2B5A",
  cursor_bg = "#3D2B5A",
  cursor_fg = "#F6F2EE",
  cursor_border = "#3D2B5A",
  selection_bg = "#E7D2BE",
  selection_fg = "#3D2B5A",
  scrollbar_thumb = "#824D5B",
  split = "#E4DCD4",
  ansi = {
    "#352C24",
    "#A5222F",
    "#396847",
    "#AC5402",
    "#2848A9",
    "#6E33CE",
    "#287980",
    "#F2E9E1",
  },
  brights = {
    "#534C45",
    "#B3434E",
    "#577F63",
    "#B86E28",
    "#4863B6",
    "#8452D5",
    "#488D93",
    "#F4ECE6",
  },
  indexed = { [16] = "#A440B5", [17] = "#955F61" },
  compose_cursor = "#955F61",
  copy_mode_active_highlight_bg = { Color = "#E7D2BE" },
  copy_mode_active_highlight_fg = { Color = "#3D2B5A" },
  copy_mode_inactive_highlight_bg = { Color = "#534C45" },
  copy_mode_inactive_highlight_fg = { Color = "#F4ECE6" },
  quick_select_label_bg = { Color = "#A5222F" },
  quick_select_label_fg = { Color = "#3D2B5A" },
  quick_select_match_bg = { Color = "#AC5402" },
  quick_select_match_fg = { Color = "#3D2B5A" },
  visual_bell = "#3D2B5A",
  tab_bar = {
    background = "#E4DCD4",
    inactive_tab_edge = "#E4DCD4",
    active_tab = { bg_color = "#824D5B", fg_color = "#F6F2EE" },
    inactive_tab = { bg_color = "#DBD1DD", fg_color = "#643F61" },
    inactive_tab_hover = { bg_color = "#D3C7BB", fg_color = "#3D2B5A", italic = false },
    new_tab = { bg_color = "#F6F2EE", fg_color = "#643F61" },
    new_tab_hover = { bg_color = "#D3C7BB", fg_color = "#3D2B5A", italic = false },
  },
}

function M.get()
  return { id = "dayfox", label = "Dayfox" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

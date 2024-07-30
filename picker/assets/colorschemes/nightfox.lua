---Ported from https://www.github.com/EdenEast/nightfox.nvim
---@module "picker.assets.colorschemes.nightfox"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#192330",
  foreground = "#CDCECF",
  cursor_bg = "#CDCECF",
  cursor_fg = "#192330",
  cursor_border = "#CDCECF",
  selection_bg = "#2B3B51",
  selection_fg = "#CDCECF",
  scrollbar_thumb = "#71839B",
  split = "#131A24",
  ansi = {
    "#393B44",
    "#C94F6D",
    "#81B29A",
    "#DBC074",
    "#719CD6",
    "#9D79D6",
    "#63CDCF",
    "#DFDFE0",
  },
  brights = {
    "#575860",
    "#D16983",
    "#8EBAA4",
    "#E0C989",
    "#86ABDC",
    "#BAA1E2",
    "#7AD5D6",
    "#E4E4E5",
  },
  indexed = { [16] = "#D67AD2", [17] = "#F4A261" },
  compose_cursor = "#F4A261",
  copy_mode_active_highlight_bg = { Color = "#2B3B51" },
  copy_mode_active_highlight_fg = { Color = "#CDCECF" },
  copy_mode_inactive_highlight_bg = { Color = "#575860" },
  copy_mode_inactive_highlight_fg = { Color = "#E4E4E5" },
  quick_select_label_bg = { Color = "#C94F6D" },
  quick_select_label_fg = { Color = "#CDCECF" },
  quick_select_match_bg = { Color = "#DBC074" },
  quick_select_match_fg = { Color = "#CDCECF" },
  visual_bell = "#CDCECF",
  tab_bar = {
    background = "#131A24",
    inactive_tab_edge = "#131A24",
    active_tab = { bg_color = "#71839B", fg_color = "#192330" },
    inactive_tab = { bg_color = "#212E3F", fg_color = "#AEAFB0" },
    inactive_tab_hover = { bg_color = "#29394F", fg_color = "#CDCECF", italic = false },
    new_tab = { bg_color = "#192330", fg_color = "#AEAFB0" },
    new_tab_hover = { bg_color = "#29394F", fg_color = "#CDCECF", italic = false },
  },
}

function M.get()
  return { id = "nightfox", label = "Nightfox" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

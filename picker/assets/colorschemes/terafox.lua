---Ported from https://www.github.com/EdenEast/nightfox.nvim
---@module "picker.assets.colorschemes.terafox"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#152528",
  foreground = "#E6EAEA",
  cursor_bg = "#E6EAEA",
  cursor_fg = "#152528",
  cursor_border = "#E6EAEA",
  selection_bg = "#293E40",
  selection_fg = "#E6EAEA",
  scrollbar_thumb = "#587B7B",
  split = "#0F1C1E",
  ansi = {
    "#2F3239",
    "#E85C51",
    "#7AA4A1",
    "#FDA47F",
    "#5A93AA",
    "#AD5C7C",
    "#A1CDD8",
    "#EBEBEB",
  },
  brights = {
    "#4E5157",
    "#EB746B",
    "#8EB2AF",
    "#FDB292",
    "#73A3B7",
    "#B97490",
    "#AFD4DE",
    "#EEEEEE",
  },
  indexed = { [16] = "#CB7985", [17] = "#FF8349" },
  compose_cursor = "#FF8349",
  copy_mode_active_highlight_bg = { Color = "#293E40" },
  copy_mode_active_highlight_fg = { Color = "#E6EAEA" },
  copy_mode_inactive_highlight_bg = { Color = "#4E5157" },
  copy_mode_inactive_highlight_fg = { Color = "#EEEEEE" },
  quick_select_label_bg = { Color = "#E85C51" },
  quick_select_label_fg = { Color = "#E6EAEA" },
  quick_select_match_bg = { Color = "#FDA47F" },
  quick_select_match_fg = { Color = "#E6EAEA" },
  visual_bell = "#E6EAEA",
  tab_bar = {
    background = "#0F1C1E",
    inactive_tab_edge = "#0F1C1E",
    active_tab = { bg_color = "#587B7B", fg_color = "#152528" },
    inactive_tab = { bg_color = "#1D3337", fg_color = "#CBD9D8" },
    inactive_tab_hover = { bg_color = "#254147", fg_color = "#E6EAEA", italic = true },
    new_tab = { bg_color = "#152528", fg_color = "#CBD9D8" },
    new_tab_hover = { bg_color = "#254147", fg_color = "#E6EAEA", italic = true },
  },
}

function M.get()
  return { id = "terafox", label = "Terafox" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

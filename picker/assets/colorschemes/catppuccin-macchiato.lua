---Ported from: https://github.com/catppuccin/wezterm
---@module "picker.assets.colorschemes.catppuccin-macchiato"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#24273A",
  foreground = "#CAD3F5",
  cursor_bg = "#F4DBD6",
  cursor_fg = "#181926",
  cursor_border = "#F4DBD6",
  selection_fg = "#CAD3F5",
  selection_bg = "#5B6078",
  scrollbar_thumb = "#5B6078",
  split = "#6E738D",
  ansi = {
    "#494D64",
    "#ED8796",
    "#A6DA95",
    "#EED49F",
    "#8AADF4",
    "#F5BDE6",
    "#8BD5CA",
    "#B8C0E0",
  },
  brights = {
    "#5B6078",
    "#ED8796",
    "#A6DA95",
    "#EED49F",
    "#8AADF4",
    "#F5BDE6",
    "#8BD5CA",
    "#A5ADCB",
  },
  indexed = { [16] = "#F5A97F", [17] = "#F4DBD6" },
  compose_cursor = "#F0C6C6",
  visual_bell = "#363A4F",
  tab_bar = {
    background = "#181926",
    inactive_tab_edge = "#363A4F",
    active_tab = { bg_color = "#C6A0F6", fg_color = "#181926", italic = false },
    inactive_tab = { bg_color = "#1E2030", fg_color = "#CAD3F5", italic = false },
    inactive_tab_hover = { bg_color = "#24273A", fg_color = "#CAD3F5", italic = false },
    new_tab = { bg_color = "#363A4F", fg_color = "#CAD3F5", italic = false },
    new_tab_hover = { bg_color = "#494D64", fg_color = "#CAD3F5", italic = false },
  },
}

function M.get()
  return { id = "catppuccin-macchiato", label = "Catppuccin Macchiato" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

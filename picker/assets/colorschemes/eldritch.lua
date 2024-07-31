---Ported from: https://github.com/eldritch-theme/wezterm
---@module "picker.assets.colorschemes.eldritch"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#212337",
  foreground = "#EBFAFA",
  cursor_bg = "#37F499",
  cursor_fg = "#212337",
  cursor_border = "#04D1F9",
  selection_bg = "rgba(26.67% 27.84% 35.29% 50%)",
  selection_fg = "rgba(0% 0% 0% 0%)",
  scrollbar_thumb = "#37F499",
  split = "#A48CF2",
  ansi = {
    "#212337",
    "#F16C75",
    "#37F499",
    "#F7C67F",
    "#A48CF2",
    "#F265B5",
    "#04D1F9",
    "#EBFAFA",
  },
  brights = {
    "#323449",
    "#F9515D",
    "#37F499",
    "#E9F941",
    "#9071F4",
    "#F265B5",
    "#66E4FD",
    "#FFFFFF",
  },
  indexed = {},
  compose_cursor = "#F7C67F",
  visual_bell = "#323449",
  copy_mode_active_highlight_bg = { Color = "#37F499" },
  copy_mode_active_highlight_fg = { Color = "#212337" },
  copy_mode_inactive_highlight_bg = { Color = "#212337" },
  copy_mode_inactive_highlight_fg = { Color = "#04D1F9" },
  quick_select_label_bg = { Color = "#F16C75" },
  quick_select_label_fg = { Color = "#EBFAFA" },
  quick_select_match_bg = { Color = "#F7C67F" },
  quick_select_match_fg = { Color = "#EBFAFA" },
  tab_bar = {
    background = "#212337",
    inactive_tab_edge = "#212337",
    active_tab = { bg_color = "#37F499", fg_color = "#212337", italic = false },
    inactive_tab = { bg_color = "#212337", fg_color = "#04D1F9", italic = false },
    inactive_tab_hover = { bg_color = "#37F499", fg_color = "#212337", italic = true },
    new_tab = { bg_color = "#212337", fg_color = "#EBFAFA", italic = false },
    new_tab_hover = { bg_color = "#37F499", fg_color = "#EBFAFA", italic = true },
  },
}

function M.get()
  return { id = "eldritch", label = "Eldritch" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

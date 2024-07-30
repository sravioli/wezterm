---Ported from: https://github.com/olivercederborg/poimandres.nvim
---@module "picker.assets.colorschemes.poimandres-storm"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#252B37",
  foreground = "#E4F0FB",
  cursor_bg = "#A6ACCD",
  cursor_fg = "#252B37",
  cursor_border = "#A6ACCD",
  compose_cursor = "#FCC5E9",
  selection_bg = "#506477",
  selection_fg = "#E4F0FB",
  scrollbar_thumb = "#404350",
  split = "#252B37",
  visual_bell = "#506477",
  ansi = {
    "#1B1E28",
    "#D0679D",
    "#5DE4C7",
    "#FFFAC2",
    "#89DDFF",
    "#FCC5E9",
    "#89DDFF",
    "#FFFFFF",
  },
  brights = {
    "#506477",
    "#D0679D",
    "#5DE4C7",
    "#FFFAC2",
    "#ADD7FF",
    "#FCC5E9",
    "#ADD7FF",
    "#FFFFFF",
  },
  indexed = {
    [16] = "#5DE4C7",
    [17] = "#D0679D",
  },
  tab_bar = {
    background = "#1B1E28",
    active_tab = { bg_color = "#1B1E28", fg_color = "#E4F0FB", italic = false },
    new_tab = { bg_color = "#1B1E28", fg_color = "#506477", italic = false },
    inactive_tab = { bg_color = "#1B1E28", fg_color = "#506477", italic = false },
    new_tab_hover = { bg_color = "#1B1E28", fg_color = "#868CAD", italic = true },
    inactive_tab_hover = { bg_color = "#1B1E28", fg_color = "#868CAD", italic = false },
  },
}

function M.get()
  return { id = "poimandres-storm", label = "Poimandres Storm" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

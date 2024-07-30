---Ported from: https://github.com/folke/tokyonight.nvim
---@module "picker.assets.colorschemes.tokyonight-moon"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  foreground = "#C8D3F5",
  background = "#222436",
  cursor_bg = "#C8D3F5",
  cursor_fg = "#222436",
  cursor_border = "#C8D3F5",
  selection_bg = "#2D3F76",
  selection_fg = "#C8D3F5",
  split = "#82AAFF",
  compose_cursor = "#FF966C",
  scrollbar_thumb = "#2F334D",
  ansi = {
    "#1B1D2B",
    "#FF757F",
    "#C3E88D",
    "#FFC777",
    "#82AAFF",
    "#C099FF",
    "#86E1FC",
    "#828BB8",
  },
  brights = {
    "#444A73",
    "#FF757F",
    "#C3E88D",
    "#FFC777",
    "#82AAFF",
    "#C099FF",
    "#86E1FC",
    "#C8D3F5",
  },
  indexed = {},
  tab_bar = {
    background = "#222436",
    inactive_tab_edge = "#1E2030",
    active_tab = { bg_color = "#82AAFF", fg_color = "#1E2030" },
    inactive_tab = { bg_color = "#2F334D", fg_color = "#545C7E" },
    inactive_tab_hover = { bg_color = "#2F334D", fg_color = "#82AAFF" },
    new_tab = { bg_color = "#222436", fg_color = "#82AAFF" },
    new_tab_hover = { bg_color = "#222436", fg_color = "#82AAFF", intensity = "Bold" },
  },
}

function M.get()
  return { id = "tokyonight-moon", label = "Tokyonight Moon" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

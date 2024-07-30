---@module "picker.assets.colorschemes.tokyonight-moon"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local Utils = require "utils"
local color = Utils.fn.color

M.scheme = {
  foreground = "#c8d3f5",
  background = "#222436",
  cursor_bg = "#c8d3f5",
  cursor_border = "#c8d3f5",
  cursor_fg = "#222436",
  selection_bg = "#2d3f76",
  selection_fg = "#c8d3f5",
  split = "#82aaff",
  compose_cursor = "#ff966c",
  scrollbar_thumb = "#2f334d",
  ansi = {
    "#1b1d2b",
    "#ff757f",
    "#c3e88d",
    "#ffc777",
    "#82aaff",
    "#c099ff",
    "#86e1fc",
    "#828bb8",
  },
  brights = {
    "#444a73",
    "#ff757f",
    "#c3e88d",
    "#ffc777",
    "#82aaff",
    "#c099ff",
    "#86e1fc",
    "#c8d3f5",
  },
  tab_bar = {
    inactive_tab_edge = "#1e2030",
    background = "#222436",
    active_tab = {
      fg_color = "#1e2030",
      bg_color = "#82aaff",
    },
    inactive_tab = {
      fg_color = "#545c7e",
      bg_color = "#2f334d",
    },
    inactive_tab_hover = {
      fg_color = "#82aaff",
      bg_color = "#2f334d",
    },
    new_tab_hover = {
      fg_color = "#82aaff",
      bg_color = "#222436",
      intensity = "Bold",
    },
    new_tab = {
      fg_color = "#82aaff",
      bg_color = "#222436",
    },
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

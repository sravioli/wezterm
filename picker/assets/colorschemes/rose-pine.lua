---@module "picker.assets.colorschemes.rose-pine"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local Utils = require "utils"
local color = Utils.fn.color

M.scheme = {
  foreground = "#e0def4",
  background = "#191724",
  cursor_bg = "#524f67",
  cursor_border = "#524f67",
  cursor_fg = "#e0def4",
  selection_bg = "#2a283e",
  selection_fg = "#e0def4",

  ansi = {
    "#26233a",
    "#eb6f92",
    "#31748f",
    "#f6c177",
    "#9ccfd8",
    "#c4a7e7",
    "#ebbcba",
    "#e0def4",
  },

  brights = {
    "#6e6a86",
    "#eb6f92",
    "#31748f",
    "#f6c177",
    "#9ccfd8",
    "#c4a7e7",
    "#ebbcba",
    "#e0def4",
  },

  tab_bar = {
    background = "#191724",
    active_tab = {
      bg_color = "#26233a",
      fg_color = "#e0def4",
    },
    inactive_tab = {
      bg_color = "#191724",
      fg_color = "#6e6a86",
    },
    inactive_tab_hover = {
      bg_color = "#26233a",
      fg_color = "#e0def4",
    },
    new_tab = {
      bg_color = "#191724",
      fg_color = "#6e6a86",
    },
    new_tab_hover = {
      bg_color = "#26233a",
      fg_color = "#e0def4",
    },
    inactive_tab_edge = "#6e6a86",
  },
}

function M.get()
  return { id = "rose-pine", label = "Rosé Pine" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

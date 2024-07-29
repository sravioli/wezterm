---@class PickList
local M = {}

local Utils = require "utils"
local color = Utils.fn.color

M.scheme = {
  foreground = "#575279",
  background = "#faf4ed",
  cursor_bg = "#9893a5",
  cursor_border = "#9893a5",
  cursor_fg = "#575279",
  selection_bg = "#f2e9e1",
  selection_fg = "#575279",

  ansi = {
    "#f2e9de",
    "#b4637a",
    "#286983",
    "#ea9d34",
    "#56949f",
    "#907aa9",
    "#d7827e",
    "#575279",
  },

  brights = {
    "#6e6a86", -- muted from rose-pine palette
    "#b4637a",
    "#286983",
    "#ea9d34",
    "#56949f",
    "#907aa9",
    "#d7827e",
    "#575279",
  },

  tab_bar = {
    background = "#faf4ed",
    active_tab = {
      bg_color = "#f2e9e1",
      fg_color = "#575279",
    },
    inactive_tab = {
      bg_color = "#faf4ed",
      fg_color = "#9893a5",
    },
    inactive_tab_hover = {
      bg_color = "#f2e9e1",
      fg_color = "#575279",
    },
    new_tab = {
      bg_color = "#faf4ed",
      fg_color = "#9893a5",
    },
    new_tab_hover = {
      bg_color = "#f2e9e1",
      fg_color = "#575279",
    },
    inactive_tab_edge = "#9893a5",
  },
}

function M.get()
  return { id = "rose-pine-dawn", label = "Rosé Pine Dawn" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

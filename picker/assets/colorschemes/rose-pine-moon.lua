---@class PickList
local M = {}

local Utils = require "utils"
local color = Utils.fn.color

M.scheme = {
  foreground = "#e0def4",
  background = "#232136",
  cursor_bg = "#59546d",
  cursor_border = "#59546d",
  cursor_fg = "#e0def4",
  selection_bg = "#393552",
  selection_fg = "#e0def4",

  ansi = {
    "#393552",
    "#eb6f92",
    "#3e8fb0",
    "#f6c177",
    "#9ccfd8",
    "#c4a7e7",
    "#ebbcba", -- replacement for rose
    "#e0def4",
  },

  brights = {
    "#817c9c", -- replacement for muted
    "#eb6f92",
    "#3e8fb0",
    "#f6c177",
    "#9ccfd8",
    "#c4a7e7",
    "#ebbcba", -- replacement for rose
    "#e0def4",
  },

  tab_bar = {
    background = "#232136",
    active_tab = {
      bg_color = "#393552",
      fg_color = "#e0def4",
    },
    inactive_tab = {
      bg_color = "#232136",
      fg_color = "#6e6a86",
    },
    inactive_tab_hover = {
      bg_color = "#393552",
      fg_color = "#e0def4",
    },
    new_tab = {
      bg_color = "#232136",
      fg_color = "#6e6a86",
    },
    new_tab_hover = {
      bg_color = "#393552",
      fg_color = "#e0def4",
    },
    inactive_tab_edge = "#6e6a86",
  },
}

function M.get()
  return { id = "rose-pine-moon", label = "Rosé Pine Moon" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

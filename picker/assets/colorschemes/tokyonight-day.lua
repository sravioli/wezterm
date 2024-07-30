---@module "picker.assets.colorschemes.tokyonight-day"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local Utils = require "utils"
local color = Utils.fn.color

M.scheme = {
  foreground = "#3760bf",
  background = "#e1e2e7",
  cursor_bg = "#3760bf",
  cursor_border = "#3760bf",
  cursor_fg = "#e1e2e7",
  selection_bg = "#b7c1e3",
  selection_fg = "#3760bf",
  split = "#2e7de9",
  compose_cursor = "#b15c00",
  scrollbar_thumb = "#c4c8da",
  ansi = {
    "#b4b5b9",
    "#f52a65",
    "#587539",
    "#8c6c3e",
    "#2e7de9",
    "#9854f1",
    "#007197",
    "#6172b0",
  },
  brights = {
    "#a1a6c5",
    "#f52a65",
    "#587539",
    "#8c6c3e",
    "#2e7de9",
    "#9854f1",
    "#007197",
    "#3760bf",
  },
  tab_bar = {
    inactive_tab_edge = "#d0d5e3",
    background = "#e1e2e7",
    active_tab = {
      fg_color = "#d0d5e3",
      bg_color = "#2e7de9",
    },
    inactive_tab = {
      fg_color = "#8990b3",
      bg_color = "#c4c8da",
    },
    inactive_tab_hover = {
      fg_color = "#2e7de9",
      bg_color = "#c4c8da",
    },
    new_tab_hover = {
      fg_color = "#2e7de9",
      bg_color = "#e1e2e7",
      intensity = "Bold",
    },
    new_tab = {
      fg_color = "#2e7de9",
      bg_color = "#e1e2e7",
    },
  },
}

function M.get()
  return { id = "tokyonight-day", label = "Tokyonight Day" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

---@module "picker.assets.colorschemes.catppuccin-macchiato"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local Utils = require "utils"
local color = Utils.fn.color

M.scheme = {

  ansi = {
    "#494d64",
    "#ed8796",
    "#a6da95",
    "#eed49f",
    "#8aadf4",
    "#f5bde6",
    "#8bd5ca",
    "#b8c0e0",
  },
  background = "#24273a",
  brights = {
    "#5b6078",
    "#ed8796",
    "#a6da95",
    "#eed49f",
    "#8aadf4",
    "#f5bde6",
    "#8bd5ca",
    "#a5adcb",
  },
  compose_cursor = "#f0c6c6",
  cursor_bg = "#f4dbd6",
  cursor_border = "#f4dbd6",
  cursor_fg = "#181926",
  foreground = "#cad3f5",
  scrollbar_thumb = "#5b6078",
  selection_bg = "#5b6078",
  selection_fg = "#cad3f5",
  split = "#6e738d",
  visual_bell = "#363a4f",

  indexed = {
    [16] = "#f5a97f",
    [17] = "#f4dbd6",
  },

  tab_bar = {
    background = "#181926",
    inactive_tab_edge = "#363a4f",

    active_tab = {
      bg_color = "#c6a0f6",
      fg_color = "#181926",
      intensity = "Normal",
      italic = false,
      strikethrough = false,
      underline = "None",
    },

    inactive_tab = {
      bg_color = "#1e2030",
      fg_color = "#cad3f5",
      intensity = "Normal",
      italic = false,
      strikethrough = false,
      underline = "None",
    },

    inactive_tab_hover = {
      bg_color = "#24273a",
      fg_color = "#cad3f5",
      intensity = "Normal",
      italic = false,
      strikethrough = false,
      underline = "None",
    },

    new_tab = {
      bg_color = "#363a4f",
      fg_color = "#cad3f5",
      intensity = "Normal",
      italic = false,
      strikethrough = false,
      underline = "None",
    },

    new_tab_hover = {
      bg_color = "#494d64",
      fg_color = "#cad3f5",
      intensity = "Normal",
      italic = false,
      strikethrough = false,
      underline = "None",
    },
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

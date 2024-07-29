---@module "picker.assets.colorschemes.dracula"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local Utils = require "utils"
local color = Utils.fn.color

M.scheme = {
  background = "#282a36",
  foreground = "#f8f8f2",
  cursor_bg = "#f8f8f2",
  cursor_fg = "#282a36",
  cursor_border = "#f8f8f2",
  selection_fg = "none",
  selection_bg = "rgba(68,71,90,0.5)",
  scrollbar_thumb = "#44475a",
  split = "#6272a4",

  ansi = {
    "#21222C",
    "#FF5555",
    "#50FA7B",
    "#F1FA8C",
    "#BD93F9",
    "#FF79C6",
    "#8BE9FD",
    "#F8F8F2",
  },
  brights = {
    "#6272A4",
    "#FF6E6E",
    "#69FF94",
    "#FFFFA5",
    "#D6ACFF",
    "#FF92DF",
    "#A4FFFF",
    "#FFFFFF",
  },

  compose_cursor = "#FFB86C",

  tab_bar = {
    background = "#282a36",
    active_tab = {
      bg_color = "#bd93f9",
      fg_color = "#282a36",
      intensity = "Normal",
      underline = "None",
      italic = false,
      strikethrough = false,
    },

    inactive_tab = {
      bg_color = "#282a36",
      fg_color = "#f8f8f2",
    },

    inactive_tab_hover = {
      bg_color = "#6272a4",
      fg_color = "#f8f8f2",
      italic = true,
    },

    new_tab = {
      bg_color = "#282a36",
      fg_color = "#f8f8f2",
    },

    new_tab_hover = {
      bg_color = "#ff79c6",
      fg_color = "#f8f8f2",
      italic = true,
    },
  },
}

function M.get()
  return { id = "dracula", label = "Dracula" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

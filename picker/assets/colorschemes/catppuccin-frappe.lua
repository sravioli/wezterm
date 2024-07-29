---@class PickList
local M = {}

local Utils = require "utils"
local color = Utils.fn.color

M.scheme = {
  background = "#303446",
  foreground = "#c6d0f5",
  cursor_bg = "#f2d5cf",
  cursor_fg = "#232634",
  cursor_border = "#f2d5cf",
  selection_bg = "#626880",
  selection_fg = "#c6d0f5",
  scrollbar_thumb = "#626880",
  split = "#737994",
  compose_cursor = "#eebebe",
  visual_bell = "#414559",

  ansi = {
    "#51576d",
    "#e78284",
    "#a6d189",
    "#e5c890",
    "#8caaee",
    "#f4b8e4",
    "#81c8be",
    "#b5bfe2",
  },
  brights = {
    "#626880",
    "#e78284",
    "#a6d189",
    "#e5c890",
    "#8caaee",
    "#f4b8e4",
    "#81c8be",
    "#a5adce",
  },

  indexed = {
    [16] = "#ef9f76",
    [17] = "#f2d5cf",
  },

  tab_bar = {
    background = "#232634",
    inactive_tab_edge = "#414559",

    active_tab = {
      bg_color = "#ca9ee6",
      fg_color = "#232634",
      intensity = "Normal",
      italic = false,
      strikethrough = false,
      underline = "None",
    },

    inactive_tab = {
      bg_color = "#292c3c",
      fg_color = "#c6d0f5",
      intensity = "Normal",
      italic = false,
      strikethrough = false,
      underline = "None",
    },

    inactive_tab_hover = {
      bg_color = "#303446",
      fg_color = "#c6d0f5",
      intensity = "Normal",
      italic = false,
      strikethrough = false,
      underline = "None",
    },

    new_tab = {
      bg_color = "#414559",
      fg_color = "#c6d0f5",
      intensity = "Normal",
      italic = false,
      strikethrough = false,
      underline = "None",
    },

    new_tab_hover = {
      bg_color = "#51576d",
      fg_color = "#c6d0f5",
      intensity = "Normal",
      italic = false,
      strikethrough = false,
      underline = "None",
    },
  },
}

function M.get()
  return { id = "catppuccin-frappe", label = "Catppuccin Frappe" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

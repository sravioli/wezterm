---Ported from: https://github.com/folke/tokyonight.nvim
---@module "picker.assets.colorschemes.tokyostorm-storm"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  foreground = "#C0CAF5",
  background = "#24283B",
  cursor_bg = "#C0CAF5",
  cursor_border = "#C0CAF5",
  cursor_fg = "#24283B",
  selection_bg = "#2E3C64",
  selection_fg = "#C0CAF5",
  split = "#7AA2F7",
  compose_cursor = "#FF9E64",
  scrollbar_thumb = "#292E42",
  ansi = {
    "#1D202F",
    "#F7768E",
    "#9ECE6A",
    "#E0AF68",
    "#7AA2F7",
    "#BB9AF7",
    "#7DCFFF",
    "#A9B1D6",
  },
  brights = {
    "#414868",
    "#F7768E",
    "#9ECE6A",
    "#E0AF68",
    "#7AA2F7",
    "#BB9AF7",
    "#7DCFFF",
    "#C0CAF5",
  },
  tab_bar = {
    inactive_tab_edge = "#1F2335",
    background = "#24283B",
    active_tab = { fg_color = "#1F2335", bg_color = "#7AA2F7" },
    inactive_tab = { fg_color = "#545C7E", bg_color = "#292E42" },
    inactive_tab_hover = { fg_color = "#7AA2F7", bg_color = "#292E42" },
    new_tab_hover = { fg_color = "#7AA2F7", bg_color = "#24283B", intensity = "Bold" },
    new_tab = { fg_color = "#7AA2F7", bg_color = "#24283B" },
  },
}

function M.get()
  return { id = "tokyostorm-storm", label = "Tokyostorm Storm" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

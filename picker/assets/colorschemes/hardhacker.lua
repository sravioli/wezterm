---Ported from: https://github.com/hardhackerlabs/theme-wezterm
---@module "picker.assets.colorschemes.hardhacker"
---@author sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

local color = require("utils").fn.color

M.scheme = {
  background = "#282433",
  foreground = "#EEE9FC",
  cursor_bg = "#EEE9FC",
  cursor_fg = "#EEE9FC",
  cursor_border = "#EEE9FC",
  compose_cursor = "#ebde76",
  selection_bg = "#E965A5",
  selection_fg = "#EEE9FC",
  scrollbar_thumb = "#3f3951",
  split = "#938aad",
  ansi = {
    "#282433",
    "#E965A5",
    "#B1F2A7",
    "#EBDE76",
    "#B1BAF4",
    "#E192EF",
    "#B3F4F3",
    "#EEE9FC",
  },
  brights = {
    "#3F3951",
    "#E965A5",
    "#B1F2A7",
    "#EBDE76",
    "#B1BAF4",
    "#E192EF",
    "#B3F4F3",
    "#EEE9FC",
  },
  indexed = {},
  tab_bar = {
    background = "#282433",
    active_tab = { bg_color = "#282433", fg_color = "#E965A5", italic = false },
    inactive_tab = { bg_color = "#282433", fg_color = "#938AAD", italic = false },
    inactive_tab_hover = { bg_color = "#E192EF", fg_color = "#EEE9FC", italic = false },
    new_tab = { bg_color = "#282433", fg_color = "#938AAD", italic = false },
    new_tab_hover = { bg_color = "#E192EF", fg_color = "#EEE9FC", italic = true },
  },
}

function M.get()
  return { id = "hardhacker", label = "hardhacker" }
end

function M.activate(Config, callback_opts)
  local theme = M.scheme
  color.set_scheme(Config, theme, callback_opts.id)
end

return M

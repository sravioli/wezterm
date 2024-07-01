---@class Wezterm
local wez = require "wezterm"

---@class Fun
local fun = require "utils.fun"

---@class Icons
local icons = require "utils.icons"

---@class Layout
local StatusBar = require "utils.layout"

local strwidth = fun.platform().is_win and string.len or fun.strwidth

-- luacheck: push ignore 561
wez.on("update-status", function(window, pane)
  local theme = require("colors")[fun.get_scheme()]
  local modes = {
    copy_mode = { text = " 󰆏 COPY ", bg = theme.brights[3] },
    search_mode = { text = " 󰍉 SEARCH ", bg = theme.brights[4] },
    window_mode = { text = " 󱂬 WINDOW ", bg = theme.ansi[6] },
    font_mode = { text = " 󰛖 FONT ", bg = theme.indexed[16] or theme.ansi[8] },
    lock_mode = { text = "  LOCK ", bg = theme.ansi[8] },
  }

  local bg = theme.ansi[5]
  local mode_indicator_width = 0

  -- {{{1 LEFT STATUS
  local LeftStatus = StatusBar:new() ---@class Layout
  local name = window:active_key_table()
  if name and modes[name] then
    local txt = modes[name].text or ""
    mode_indicator_width, bg = strwidth(txt) + 2, modes[name].bg
    LeftStatus:push(bg, theme.background, txt, { "Bold" })
  end

  window:set_left_status(wez.format(LeftStatus))
  -- }}}

  -- {{{1 RIGHT STATUS
  local RightStatus = StatusBar:new() ---@class Layout

  bg = wez.color.parse(bg)
  local colors = { bg:darken(0.15), bg, bg:lighten(0.15), bg:lighten(0.25) }

  local battery = wez.battery_info()[1]
  battery.charge = battery.state_of_charge * 100
  battery.lvl_round = fun.toint(fun.mround(battery.charge, 10))
  battery.ico = icons.Battery[battery.state][tostring(battery.lvl_round)]
  battery.lvl = tonumber(math.floor(battery.charge + 0.5))
  battery.full = ("%s %i%%"):format(battery.ico, battery.lvl)

  local cwd, hostname = fun.get_cwd_hostname(pane, true)

  --~ {{{2 Calculate the used width by the tabs
  local MuxWindow = window:mux_window()
  local tab_bar_width = 0
  for _, MuxTab in ipairs(MuxWindow:tabs()) do
    local tab_title = MuxTab:panes()[1]:get_title()
    tab_bar_width = tab_bar_width + strwidth(tab_title) + 4 ---other padding
  end

  local Config = MuxWindow:gui_window():effective_config() ---@class Config
  local has_button = Config.show_new_tab_button_in_tab_bar
  local new_tab_button = has_button and Config.tab_bar_style.new_tab or ""
  tab_bar_width = tab_bar_width + mode_indicator_width + strwidth(new_tab_button)
  wez.log_info(tab_bar_width, pane:get_dimensions().cols)
  --~ }}}

  local status_bar_cells = {
    { cwd, fun.pathshortener(cwd, 4), fun.pathshortener(cwd, 1) },
    { hostname, hostname:sub(1, 1) },
    { wez.strftime "%a %b %-d %H:%M", wez.strftime "%d/%m %R", wez.strftime "%R" },
    { battery.full, battery.lvl .. "%", battery.ico },
  }

  local usable_width = pane:get_dimensions().cols - tab_bar_width - 6 ---padding
  local fancy_bg = Config.window_frame.active_titlebar_bg
  local last_fg = Config.use_fancy_tab_bar and fancy_bg or theme.tab_bar.background

  ---push each cell and the separator
  for i, cell_group in ipairs(status_bar_cells) do
    local cell_bg = colors[i]
    local cell_fg = i == 1 and last_fg or colors[i - 1]
    local sep = icons.Separators.StatusBar.right

    ---add each cell separator
    RightStatus:push(cell_fg, cell_bg, sep)

    ---auto choose the first cell of the list
    local cell_to_use, used_cell = cell_group[1], false

    ---try to use the longest cell of the list, then fallback to a shorter one
    for _, cell in ipairs(cell_group) do
      -- local cell_width = strwidth(cell) + strwidth(sep)
      local cell_width = 0
      if usable_width >= cell_width then
        cell_to_use, used_cell = cell, true
        break
      end
    end

    ---use the cell that fits best, otherwise set it to an empty one
    cell_to_use = not used_cell and "" or " " .. cell_to_use .. " "

    ---push the cell
    RightStatus:push(colors[i], theme.tab_bar.background, cell_to_use, { "Bold" })

    ---update the usable width
    usable_width = usable_width - strwidth(cell_to_use) - strwidth(sep) - 2
  end

  window:set_right_status(wez.format(RightStatus))
  -- }}}
end)
-- luacheck: pop

-- vim: fdm=marker fdl=1

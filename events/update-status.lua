---@class WezTerm
local wez = require "wezterm"

local fun = require "utils.fun" ---@class Fun
local icons = require "utils.icons" ---@class Icons
local StatusBar = require "utils.layout" ---@class Layout

local strwidth = fun.strwidth

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
    mode_indicator_width, bg = strwidth(txt), modes[name].bg
    LeftStatus:push(bg, theme.background, txt, { "Bold" })
  end

  window:set_left_status(wez.format(LeftStatus))
  -- }}}

  -- {{{1 RIGHT STATUS
  local RightStatus = StatusBar:new() ---@class Layout

  bg = wez.color.parse(bg)
  local colors = { bg:darken(0.15), bg, bg:lighten(0.15), bg:lighten(0.25) }

  local battery = wez.battery_info()[1]
  battery.lvl = fun.toint(fun.mround(battery.state_of_charge * 100, 10))
  battery.ico = icons.Battery[battery.state][tostring(battery.lvl)]
  battery.full = ("%s %i%%"):format(
    battery.ico,
    tonumber(math.floor(battery.state_of_charge * 100 + 0.5))
  )

  local datetime = wez.strftime "%a %b %-d %H:%M"
  local cwd, hostname = fun.get_cwd_hostname(pane, true)

  --~ {{{2 Calculate the used width by the tabs
  local MuxWindow = window:mux_window()
  local tab_bar_width = 0
  for _, MuxTab in ipairs(MuxWindow:tabs()) do
    -- tab_bar_width = tab_bar_width + strwidth(MuxTab:panes()[1]:get_title()) + 2
    tab_bar_width = tab_bar_width + string.len(MuxTab:panes()[1]:get_title()) + 2
    wez.log_info(tab_bar_width)
  end

  local Config = MuxWindow:gui_window():effective_config() ---@class Config
  local has_button = Config.show_new_tab_button_in_tab_bar
  local new_tab_button = has_button and Config.tab_bar_style.new_tab or ""
  tab_bar_width = tab_bar_width + mode_indicator_width + strwidth(new_tab_button)
  --~ }}}

  local usable_width = pane:get_dimensions().cols - tab_bar_width - 4 ---padding
  local fancy_bg = Config.window_frame.active_titlebar_bg
  local last_fg = Config.use_fancy_tab_bar and fancy_bg or theme.tab_bar.background

  ---push each cell and the cells separator
  for i, cell in ipairs { cwd, hostname, datetime, battery.full } do
    local cell_bg = colors[i]
    local cell_fg = i == 1 and last_fg or colors[i - 1]
    local sep = icons.Separators.StatusBar.right

    ---add each cell separator
    RightStatus:push(cell_fg, cell_bg, sep)

    usable_width = usable_width - strwidth(cell) - strwidth(sep)

    ---add cell or empty string
    cell = usable_width <= 0 and " " or " " .. cell .. " "
    RightStatus:push(colors[i], theme.tab_bar.background, cell, { "Bold" })
  end

  window:set_right_status(wez.format(RightStatus))
  -- }}}
end)
-- luacheck: pop

-- vim: fdm=marker fdl=1


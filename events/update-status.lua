---@class Wezterm
local wt = require "wezterm"

---@class Fun
local fun = require "utils.fun"

---@class Icons
local icons = require "utils.icons"

---@class Layout
local StatusBar = require "utils.layout"

local strwidth = fun.platform().is_win and string.len or fun.strwidth

-- luacheck: push ignore 561
wt.on("update-status", function(window, pane)
  local theme = require("colors")[window:effective_config().color_scheme]
  local modes = require "utils.modes-list"

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

  window:set_left_status(wt.format(LeftStatus))
  -- }}}

  -- {{{1 RIGHT STATUS
  local RightStatus = StatusBar:new() ---@class Layout

  --~~ {{{2 Calculate the used width by the tabs
  local MuxWindow = window:mux_window()
  local tab_bar_width = 0
  for _, MuxTab in ipairs(MuxWindow:tabs()) do
    local tab_title = MuxTab:panes()[1]:get_title()
    tab_bar_width = tab_bar_width + strwidth(tab_title) + 2
  end

  local Config = MuxWindow:gui_window():effective_config() ---@class Config
  local has_button = Config.show_new_tab_button_in_tab_bar
  local new_tab_button = has_button and Config.tab_bar_style.new_tab or ""
  tab_bar_width = tab_bar_width + mode_indicator_width + strwidth(new_tab_button) + 2
  --~~ }}}

  local usable_width = pane:get_dimensions().cols - tab_bar_width - 6

  --~ {{{2 MODAL PROMPTS
  if name and modes[name] then
    local mode = modes[name]
    local prompt_bg, map_fg, txt_fg = theme.tab_bar.background, mode.bg, theme.foreground
    local sep = icons.Separators.StatusBar.modal

    local key_tbl = require("mappings.modes")[2][name]
    for idx, map_tbl in ipairs(key_tbl) do
      local map, desc = map_tbl[1], map_tbl[3]
      if map:find "%b<>" then
        map = map:gsub("(%b<>)", function(str)
          return str:sub(2, -2)
        end)
      end

      local prompt_len = strwidth(map .. desc) + mode.pad
      if usable_width > 0 and desc ~= "" then
        RightStatus:push(prompt_bg, txt_fg, "<", { "Bold" })
        RightStatus:push(prompt_bg, map_fg, map)
        RightStatus:push(prompt_bg, txt_fg, ">")
        RightStatus:push(prompt_bg, txt_fg, fun.pad(desc), { "Normal", "Italic" })

        ---add separator only if it's not the last item and there's enough space
        local next_prompt = key_tbl[idx]
        local next_prompt_len = strwidth(next_prompt[1] .. next_prompt[3]) + 4
        if idx < #key_tbl and usable_width - next_prompt_len > 0 then
          RightStatus:push(prompt_bg, theme.brights[1], sep .. " ", { "NoItalic" })
        elseif usable_width - next_prompt_len <= 0 then
          RightStatus:push(prompt_bg, theme.brights[1], sep .. " ...", { "NoItalic" })
        end
      end

      usable_width = usable_width - prompt_len
    end

    window:set_right_status(wt.format(RightStatus))
    return ---return early to not render status bar
  end
  --~ }}}

  --~ {{{2 STATUS BAR
  bg = wt.color.parse(bg)
  local colors = { bg:darken(0.15), bg, bg:lighten(0.15), bg:lighten(0.25) }

  local battery = wt.battery_info()[1]
  battery.charge = battery.state_of_charge * 100
  battery.lvl_round = fun.toint(fun.mround(battery.charge, 10))
  battery.ico = icons.Battery[battery.state][tostring(battery.lvl_round)]
  battery.lvl = tonumber(math.floor(battery.charge + 0.5))
  battery.full = ("%s %i%%"):format(battery.ico, battery.lvl)

  local cwd, hostname = fun.get_cwd_hostname(pane, true)

  local status_bar_cells = {
    { cwd, fun.pathshortener(cwd, 4), fun.pathshortener(cwd, 1) },
    { hostname, hostname:sub(1, 1) },
    { wt.strftime "%a %b %-d %H:%M", wt.strftime "%d/%m %R", wt.strftime "%R" },
    { battery.full, battery.lvl .. "%", battery.ico },
  }

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
    cell_to_use = not used_cell and "" or fun.pad(cell_to_use)

    ---push the cell
    RightStatus:push(colors[i], theme.tab_bar.background, cell_to_use, { "Bold" })

    ---update the usable width
    usable_width = usable_width - strwidth(cell_to_use) - strwidth(sep) - 2 -- padding
  end

  window:set_right_status(wt.format(RightStatus))
  --~ }}}
  -- }}}
end)
-- luacheck: pop

-- vim: fdm=marker fdl=1

---@module "events.update-status"
---@author sravioli
---@license GNU-GPLv3

local wt = require "wezterm"

local Utils = require "utils"
local StatusBar = Utils.class.layout
local Icon = Utils.class.icon
local fs, mt, str = Utils.fn.fs, Utils.fn.mt, Utils.fn.str

---@diagnostic disable-next-line: undefined-field
local wt_format, strftime = wt.format, wt.strftime
local strwidth = fs.platform().is_win and string.len or str.strwidth

-- luacheck: push ignore 561
---@diagnostic disable-next-line: undefined-field
wt.on("update-status", function(window, pane)
  local Config = window:effective_config()

  local Overrides = window:get_config_overrides() or {}
  local theme = Config.color_schemes[Overrides.color_scheme or Config.color_scheme]
  local modes = {
    search_mode = { i = "󰍉", txt = "SEARCH", bg = theme.brights[4], pad = 10 },
    window_mode = { i = "󱂬", txt = "WINDOW", bg = theme.ansi[6], pad = 8 },
    copy_mode = { i = "󰆏", txt = "COPY", bg = theme.brights[3], pad = 8 },
    font_mode = { i = "󰛖", txt = "FONT", bg = theme.ansi[7], pad = 7 },
    help_mode = { i = "󰞋", txt = "NORMAL", bg = theme.ansi[5], pad = 9 },
    pick_mode = { i = "󰢷", txt = "PICK", bg = theme.ansi[2], pad = 9 },
  }

  local bg = theme.ansi[5]
  local mode_indicator_width = 0

  -- {{{1 LEFT STATUS

  local LeftStatus = StatusBar:new "LeftStatus"
  local name = window:active_key_table()
  if name and modes[name] then
    local txt, ico = modes[name].txt or "", modes[name].i or ""
    mode_indicator_width, bg = strwidth(txt) + 4 + strwidth(ico), modes[name].bg
    LeftStatus:push(bg, theme.background, str.pad(ico .. " " .. txt, 1), { "Bold" })
  end

  window:set_left_status(LeftStatus:format())
  -- }}}

  -- {{{1 RIGHT STATUS

  local RightStatus = StatusBar:new "RightStatus"

  --~~ {{{2 Calculate the used width by the tabs
  local MuxWindow = window:mux_window()
  local tab_bar_width = 5
  for i = 1, #MuxWindow:tabs() do
    local MuxPane = MuxWindow:tabs()[i]:panes()[1]
    local tab_title = MuxPane:get_title()

    local process, other = tab_title:match "^(%S+)%s*%-?%s*%s*(.*)$"
    tab_title = tab_title:gsub("^Copy mode: ", "")
    if Icon.Progs[process] then
      tab_title = Icon.Progs[process] .. " " .. (other or "")
    end

    local proc = MuxPane:get_foreground_process_name()
    if proc and proc:find "nvim" then
      proc = proc:sub(proc:find "nvim")
    end
    if proc == "nvim" then
      local cwd = fs.basename(MuxPane:get_current_working_dir().file_path)
      tab_title = ("%s ( %s)"):format(Icon.Progs[proc], cwd)
    end
    tab_title = tab_title:gsub(fs.basename(fs.home()), "󰋜 ")

    tab_bar_width = tab_bar_width + strwidth(tab_title) + 3
  end

  local new_tab_button = Config.show_new_tab_button_in_tab_bar and 8 or 0
  tab_bar_width = tab_bar_width + mode_indicator_width + new_tab_button
  --~~ }}}

  local usable_width = pane:get_dimensions().cols - tab_bar_width - 2

  --~ {{{2 MODAL PROMPTS
  if name and modes[name] then
    local mode = modes[name]
    local prompt_bg, map_fg, txt_fg = theme.tab_bar.background, mode.bg, theme.foreground
    local sep = Icon.Sep.sb.modal

    local key_tbl = require("mappings.modes")[2][name]
    for idx = 1, #key_tbl do
      local map_tbl = key_tbl[idx]
      local map, desc = map_tbl[1], map_tbl[3]
      if map:find "%b<>" then
        map = map:gsub("(%b<>)", function(s)
          return s:sub(2, -2)
        end)
      end

      local prompt_len = strwidth(map .. desc) + mode.pad
      if usable_width > 0 and desc ~= "" then
        RightStatus:push(prompt_bg, txt_fg, "<", { "Bold" })
        RightStatus:push(prompt_bg, map_fg, map)
        RightStatus:push(prompt_bg, txt_fg, ">")
        RightStatus:push(prompt_bg, txt_fg, str.pad(desc), { "Normal", "Italic" })

        ---add separator only if it's not the last item and there's enough space
        local next_prompt = key_tbl[idx]
        local next_prompt_len = strwidth(next_prompt[1] .. next_prompt[3]) + 3
        if idx < #key_tbl and usable_width - next_prompt_len > 0 then
          RightStatus:push(prompt_bg, theme.brights[1], sep .. " ", { "NoItalic" })
        end
      end

      usable_width = usable_width - prompt_len
    end

    window:set_right_status(wt_format(RightStatus))
    return ---return early to not render status bar
  end
  --~ }}}

  --~ {{{2 STATUS BAR
  bg = wt.color.parse(bg)
  local colors = { bg:darken(0.15), bg, bg:lighten(0.15), bg:lighten(0.25) }

  local battery = wt.battery_info()[1]
  battery.charge = battery.state_of_charge * 100
  battery.lvl_round = mt.toint(mt.mround(battery.charge, 10))
  battery.ico = Icon.Bat[battery.state][tostring(battery.lvl_round)]
  battery.lvl = tonumber(math.floor(battery.charge + 0.5))
  battery.full = ("%s %i%%"):format(battery.ico, battery.lvl)

  local cwd, hostname = fs.get_cwd_hostname(pane, true)

  local status_bar_cells = {
    { cwd, fs.pathshortener(cwd, 4), fs.pathshortener(cwd, 1) },
    { hostname, hostname:sub(1, 1) },
    { strftime "%a %b %-d %H:%M", strftime "%d/%m %R", strftime "%R" },
    { battery.full, battery.lvl .. "%", battery.ico },
  }

  local fancy_bg = Config.window_frame.active_titlebar_bg
  local last_fg = Config.use_fancy_tab_bar and fancy_bg or theme.tab_bar.background

  ---push each cell and the separator
  for i = 1, #status_bar_cells do
    local cell_group = status_bar_cells[i]
    local cell_bg, cell_fg = colors[i], i == 1 and last_fg or colors[i - 1]
    local sep = Icon.Sep.sb.right

    ---add each cell separator
    RightStatus:push(cell_fg, cell_bg, sep)

    ---auto choose the first cell of the list
    local cell_to_use, used_cell = cell_group[1], false

    ---try to use the longest cell of the list, then fallback to a shorter one
    for j = 1, #cell_group do
      local cell = cell_group[j]
      local cell_width = 0
      if usable_width >= cell_width then
        cell_to_use, used_cell = cell, true
        break
      end
    end

    ---use the cell that fits best, otherwise set it to an empty one
    cell_to_use = not used_cell and "" or str.pad(cell_to_use)

    ---push the cell
    RightStatus:push(colors[i], theme.tab_bar.background, cell_to_use, { "Bold" })

    ---update the usable width
    usable_width = usable_width - strwidth(cell_to_use) - strwidth(sep) - 2 -- padding
  end

  window:set_right_status(RightStatus:format())
  --~ }}}
  -- }}}
end)
-- luacheck: pop

-- vim: fdm=marker fdl=1

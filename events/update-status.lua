---@diagnostic disable: undefined-field
---
---@module "events.update-status"
---@author sravioli
---@license GNU-GPLv3

-- selene: allow(incorrect_standard_library_use)
local tunpack, tinsert = table.unpack or unpack, table.insert
local tostring, tonumber = tostring, tonumber
local floor = math.floor

local wt = require "wezterm"
local timefmt, color_parse = wt.strftime, wt.color.parse

local class, fn = require "utils.class", require "utils.fn"
local icon, sep, sb = class.icon, class.icon.Sep, class.layout:new "StatusBar"
local fs, mt, str, tbl = fn.fs, fn.mt, fn.str, fn.tbl

---Update status event
---@param window wt.Window Wezterm's window object
---@param pane   wt.Pane   Wezterm's pane object
wt.on("update-status", function(window, pane)
  local Config, Overrides = window:effective_config(), window:get_config_overrides() or {}
  local theme = Config.color_schemes[Overrides.color_scheme or Config.color_scheme]

  --~ {{{2: Valid modes

  local modes = {
    search_mode = { i = "󰍉", txt = "SEARCH", bg = theme.brights[4], pad = 5 },
    window_mode = { i = "󱂬", txt = "WINDOW", bg = theme.ansi[6], pad = 4 },
    copy_mode = { i = "󰆏", txt = "COPY", bg = theme.brights[3], pad = 5 },
    font_mode = { i = "󰛖", txt = "FONT", bg = theme.ansi[7], pad = 4 },
    help_mode = { i = "󰞋", txt = "NORMAL", bg = theme.ansi[5], pad = 5 },
    pick_mode = { i = "󰢷", txt = "PICK", bg = theme.ansi[2], pad = 5 },
  } --~ }}}

  local bg, fg = theme.background, theme.ansi[5]

  local width = {
    ws = 0,
    mode = 0,
    tabs = 5,
    prompt = 0,
    usable = pane:get_dimensions().cols,
    new_button = Config.show_new_tab_button_in_tab_bar and 8 or 0,
  }

  -- {{{1: Left status

  local lsb = sb:new "LeftStatusBar"

  --~ {{{2: Modal indicator

  local mode = window:active_key_table()
  if mode and modes[mode] then
    local mode_fg = modes[mode].bg
    local txt, ico = modes[mode].txt or "", modes[mode].i or ""
    local indicator = str.pad(str.padr(ico) .. txt, 1)

    lsb:append(mode_fg, bg, indicator, { "Bold" })

    width.mode = str.width(indicator)
  end --~ }}}

  --~ {{{2: workspace indicator

  local ws = window:active_workspace()
  if ws ~= "" and not mode then
    local ws_bg = theme.brights[6]
    ws = str.pad(str.padr(icon.Workspace) .. ws)
    width.ws = str.width(ws) + 4

    if width.usable >= width.ws then
      lsb:append(ws_bg, bg, ws, { "Bold" })
    end
  end

  --~}}}

  window:set_left_status(lsb:format())
  -- }}}

  -- {{{1: Right Status

  local rsb = sb:new "RightStatusBar"

  --~ {{{2 usable width calculation

  for _ = 1, #window:mux_window():tabs() do
    local tab_title = pane:get_title()
    width.tabs = width.tabs + str.width(str.format_tab_title(pane, tab_title, Config, 25))
  end

  width.usable = width.usable - (width.tabs + width.mode + width.new_button + width.ws)
  --~ }}}

  --~ {{{2: Modal prompts

  if mode and modes[mode] then
    local prompt_bg, map_fg, txt_fg =
      theme.tab_bar.background, modes[mode].bg, theme.foreground
    local msep = sep.sb.modal

    local key_tbl = require("mappings.modes")[2][mode]
    for idx = 1, #key_tbl do
      local map, _, desc = tunpack(key_tbl[idx])

      if map:find "%b<>" then
        map = map:gsub("(%b<>)", function(s)
          return s:sub(2, -2)
        end)
      end

      width.prompt = str.width(map .. str.pad(desc)) + modes[mode].pad
      width.usable = width.usable - width.prompt
      if width.usable > 0 and desc ~= "" then
        rsb:append(prompt_bg, txt_fg, "<", { "Bold" })
        rsb:append(prompt_bg, map_fg, map)
        rsb:append(prompt_bg, txt_fg, ">")
        rsb:append(prompt_bg, txt_fg, str.pad(desc), { "Normal", "Italic" })

        local next_map, _, next_desc = tunpack(key_tbl[idx + 1] or { "", "", "" })
        local next_prompt_len = str.width(next_map .. str.pad(next_desc))
        if idx < #key_tbl and next_prompt_len < width.usable then
          rsb:append(prompt_bg, theme.brights[1], str.padr(msep, 1), { "NoItalic" })
        end
      end
    end

    window:set_right_status(rsb:format())
    return -- early return to not render the status bar
  end --~ }}}

  --~ {{{2: Status bar

  fg = color_parse(fg)
  local palette = { fg:darken(0.15), fg, fg:lighten(0.15), fg:lighten(0.25) }
  local cwd, hostname = fs.get_cwd_hostname(pane, true)

  --~~ {{{3: battery cells

  local battery = wt.battery_info()[1]
  battery.charge_lvl = battery.state_of_charge * 100
  battery.charge_lvl_round = mt.toint(mt.mround(battery.charge_lvl, 10))
  battery.ico = icon.Bat[battery.state][tostring(battery.charge_lvl_round)]
  battery.lvl = tonumber(floor(battery.charge_lvl + 0.5)) .. "%"
  battery.full = ("%s %s"):format(battery.lvl, battery.ico)
  battery.cells = { battery.full, battery.lvl, battery.ico }
  --~~ }}}

  --~~ {{{3: datime cells

  local time_ico = str.padl(icon.Clock[timefmt "%I"])
  local time_cells = {
    timefmt "%a %b %-d %H:%M" .. time_ico,
    timefmt "%d/%m %R" .. time_ico,
    timefmt "%R" .. time_ico,
    time_ico,
  } --~~}}}

  --~~ {{{3: cwd cells
  local cwd_ico = str.padl(icon.Folder)
  local cwd_cells = {
    cwd .. cwd_ico,
    fs.pathshortener(cwd, 4) .. cwd_ico,
    fs.pathshortener(cwd, 2) .. cwd_ico,
    fs.pathshortener(cwd, 1) .. cwd_ico,
  } --~~ }}}

  --~~ {{{3: hostname cells
  local hostname_ico = str.padl(icon.Hostname)
  local hostname_cells =
    { hostname .. hostname_ico, hostname:sub(1, 1) .. hostname_ico, hostname_ico }
  --~~}}}

  local fancy_bg = Config.window_frame.active_titlebar_bg
  local last_fg = Config.use_fancy_tab_bar and fancy_bg or theme.tab_bar.background

  local sets = { cwd_cells, hostname_cells, time_cells, battery.cells }

  local function compute_width(combination, sep_width, pad_width)
    local total_width = 0
    for i = 1, #combination do
      total_width = total_width + str.width(combination[i]) + sep_width + pad_width
    end
    return total_width
  end

  local function find_best_fit(combinations, max_width, sep_width, pad_width)
    local best_fit = nil
    local best_fit_width = 0

    for i = 1, #combinations do
      local total_width = compute_width(combinations[i], sep_width, pad_width)
      if total_width <= max_width and total_width > best_fit_width then
        best_fit = combinations[i]
        best_fit_width = total_width
      end
    end

    return best_fit or { "", "", "", "" }
  end

  local cells = tbl.reverse(
    find_best_fit(tbl.cartesian(sets), width.usable, str.width(sep.sb.right), 5)
  )

  -- Render the best fit, ensuring correct colors
  for i = 1, #cells do
    local cell_bg, cell_fg = palette[i], i == 1 and last_fg or palette[i - 1]
    local rsep = sep.sb.right

    rsb:append(cell_fg, cell_bg, rsep)
    rsb:append(cell_bg, theme.tab_bar.background, str.pad(cells[i]), { "Bold" })
  end
  --~ }}}

  window:set_right_status(rsb:format())
  -- }}}
end)

-- vim: fdm=marker fdl=1

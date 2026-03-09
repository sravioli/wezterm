---@module "utils.icons"

local nf = require("wezterm").nerdfonts

---@class Icons
local M = {}

---@type string
M.Notification = nf.cod_circle_small_filled

---@type string
M.Workspace = nf.cod_briefcase

---@type string
M.Folder = nf.md_folder

---@type string
M.Hostname = nf.md_monitor_shimmer

---@type string
M.Leader = nf.md_lightning_bolt

---@type string
M.Ellipsis = nf.fa_ellipsis

M.Modes = {
  copy = nf.md_content_copy,
  search = nf.md_magnify,
  font = nf.md_format_font,
  window = nf.md_dock_window,
  help = nf.md_help_box,
  pick = nf.md_pickaxe,
}

M.Picker = {
  ico = nf.md_pickaxe,
  fuzzy = {
    ico = nf.cod_search_fuzzy,
    punct = "❭",
  },
  exact = {
    ico = nf.cod_search,
    punct = ":",
  },
}

M.Sep = {
  block = "█",

  sb = {
    left = nf.pl_left_hard_divider,
    right = nf.pl_right_hard_divider,
    modal = nf.ple_forwardslash_separator,
  },

  ws = {
    left = nf.ple_right_half_circle_thick,
    right = nf.ple_left_half_circle_thick,
  },

  tb = {
    leftmost = "▐",
    left = nf.ple_upper_right_triangle,
    right = nf.ple_lower_left_triangle,
  },

  leader = {
    right = nf.ple_left_half_circle_thick,
    left = nf.ple_right_half_circle_thick,
  },
}

M.Bat = {
  Full = {
    ["100"] = nf.md_battery,
  },

  Charging = {
    ["00"] = nf.md_battery_alert,
    ["10"] = nf.md_battery_charging_10,
    ["20"] = nf.md_battery_charging_20,
    ["30"] = nf.md_battery_charging_30,
    ["40"] = nf.md_battery_charging_40,
    ["50"] = nf.md_battery_charging_50,
    ["60"] = nf.md_battery_charging_60,
    ["70"] = nf.md_battery_charging_70,
    ["80"] = nf.md_battery_charging_80,
    ["90"] = nf.md_battery_charging_90,
    ["100"] = nf.md_battery_charging_100,
  },

  Discharging = {
    ["00"] = nf.md_battery_outline,
    ["10"] = nf.md_battery_10,
    ["20"] = nf.md_battery_20,
    ["30"] = nf.md_battery_30,
    ["40"] = nf.md_battery_40,
    ["50"] = nf.md_battery_50,
    ["60"] = nf.md_battery_60,
    ["70"] = nf.md_battery_70,
    ["80"] = nf.md_battery_80,
    ["90"] = nf.md_battery_90,
    ["100"] = nf.md_battery,
  },
}

M.Nums = {
  nf.md_numeric_1,
  nf.md_numeric_2,
  nf.md_numeric_3,
  nf.md_numeric_4,
  nf.md_numeric_5,
  nf.md_numeric_6,
  nf.md_numeric_7,
  nf.md_numeric_8,
  nf.md_numeric_9,
  nf.md_numeric_10,
}

M.Clock = {
  night = {
    ["00"] = nf.md_clock_time_twelve,
    ["01"] = nf.md_clock_time_one,
    ["02"] = nf.md_clock_time_two,
    ["03"] = nf.md_clock_time_three,
    ["04"] = nf.md_clock_time_four,
    ["05"] = nf.md_clock_time_five,
    ["06"] = nf.md_clock_time_six,
    ["07"] = nf.md_clock_time_seven,
    ["08"] = nf.md_clock_time_eight,
    ["09"] = nf.md_clock_time_nine,
    ["10"] = nf.md_clock_time_ten,
    ["11"] = nf.md_clock_time_eleven,
    ["12"] = nf.md_clock_time_twelve,
  },
  day = {
    ["00"] = nf.md_clock_time_twelve_outline,
    ["01"] = nf.md_clock_time_one_outline,
    ["02"] = nf.md_clock_time_two_outline,
    ["03"] = nf.md_clock_time_three_outline,
    ["04"] = nf.md_clock_time_four_outline,
    ["05"] = nf.md_clock_time_five_outline,
    ["06"] = nf.md_clock_time_six_outline,
    ["07"] = nf.md_clock_time_seven_outline,
    ["08"] = nf.md_clock_time_eight_outline,
    ["09"] = nf.md_clock_time_nine_outline,
    ["10"] = nf.md_clock_time_ten_outline,
    ["11"] = nf.md_clock_time_eleven_outline,
    ["12"] = nf.md_clock_time_twelve_outline,
  },
}

M.Progs = {
  ["bash"] = nf.cod_terminal_bash,
  ["btm"] = nf.md_chart_donut_variant,
  ["btop"] = nf.md_chart_areaspline,
  ["C:\\WINDOWS\\system32\\cmd.exe"] = nf.md_console_line,
  ["cargo"] = nf.dev_rust,
  ["curl"] = nf.mdi_flattr,
  ["docker-compose"] = nf.linux_docker,
  ["docker"] = nf.linux_docker,
  ["fish"] = nf.md_fish,
  ["gh"] = nf.dev_github_badge,
  ["git"] = nf.dev_git,
  ["go"] = nf.seti_go,
  ["htop"] = nf.md_chart_areaspline,
  ["kubectl"] = nf.linux_docker,
  ["kuberlr"] = nf.linux_docker,
  ["lazydocker"] = nf.linux_docker,
  ["lazygit"] = nf.cod_github,
  ["lua"] = nf.seti_lua,
  ["make"] = nf.seti_makefile,
  ["node"] = nf.md_nodejs,
  ["nvim"] = nf.custom_neovim,
  ["pacman"] = "󰮯 ",
  ["paru"] = "󰮯 ",
  ["perl"] = nf.seti_perl,
  ["psql"] = nf.dev_postgresql,
  ["pwsh"] = nf.md_console,
  ["pwsh.exe"] = nf.md_console,
  ["python"] = nf.seti_python,
  ["ruby"] = nf.cod_ruby,
  ["sudo"] = nf.fa_hashtag,
  ["Topgrade"] = nf.md_rocket_launch,
  ["vim"] = nf.dev_vim,
  ["wget"] = nf.mdi_arrow_down_box,
  ["zsh"] = nf.dev_terminal,
  ["Yazi"] = nf.md_duck,
  ["gitui"] = nf.fa_git,
}

return M

-- vim: fdm=marker fdl=1

---Nerd fonts aggregated by type/class/etc.
---@class Icons
local M = {}

---@class Wezterm
local wt = require "wezterm"

---@class SeparatorsIcons: StatusBarIcons, TabBarIcons
M.Separators = {
  ---@class StatusBarIcons: string, string
  ---@field left  string ``
  ---@field right string ``
  StatusBar = {
    left = wt.nerdfonts.pl_left_hard_divider,
    right = wt.nerdfonts.pl_right_hard_divider,
    modal = wt.nerdfonts.ple_forwardslash_separator,
  },

  ---@class TabBarIcons: string, string, string
  ---@field leftmost string `▐`
  ---@field left     string ``
  ---@field right    string ``
  TabBar = {
    leftmost = "▐",
    left = wt.nerdfonts.ple_upper_right_triangle,
    right = wt.nerdfonts.ple_lower_left_triangle,
  },

  FullBlock = "█",
}

M.Vim = ""

M.Pwsh = wt.nerdfonts.md_powershell

M.Bash = wt.nerdfonts.md_bash

M.Git = wt.nerdfonts.md_git

---@class Icons.Battery: table, table
---@field charging table Icons for charging battery in increments of 10
---@field normal   table Icons for non-charging battery in increments of 10
M.Battery = {
  Full = {
    ["100"] = wt.nerdfonts.md_battery,
  },

  Charging = {
    ["00"] = wt.nerdfonts.md_battery_alert,
    ["10"] = wt.nerdfonts.md_battery_charging_10,
    ["20"] = wt.nerdfonts.md_battery_charging_20,
    ["30"] = wt.nerdfonts.md_battery_charging_30,
    ["40"] = wt.nerdfonts.md_battery_charging_40,
    ["50"] = wt.nerdfonts.md_battery_charging_50,
    ["60"] = wt.nerdfonts.md_battery_charging_60,
    ["70"] = wt.nerdfonts.md_battery_charging_70,
    ["80"] = wt.nerdfonts.md_battery_charging_80,
    ["90"] = wt.nerdfonts.md_battery_charging_90,
    ["100"] = wt.nerdfonts.md_battery_charging_100,
  },

  Discharging = {
    ["00"] = wt.nerdfonts.md_battery_outline,
    ["10"] = wt.nerdfonts.md_battery_10,
    ["20"] = wt.nerdfonts.md_battery_20,
    ["30"] = wt.nerdfonts.md_battery_30,
    ["40"] = wt.nerdfonts.md_battery_40,
    ["50"] = wt.nerdfonts.md_battery_50,
    ["60"] = wt.nerdfonts.md_battery_60,
    ["70"] = wt.nerdfonts.md_battery_70,
    ["80"] = wt.nerdfonts.md_battery_80,
    ["90"] = wt.nerdfonts.md_battery_90,
    ["100"] = wt.nerdfonts.md_battery,
  },
}

M.Admin = wt.nerdfonts.md_lightning_bolt

M.UnseenNotification = wt.nerdfonts.cod_circle_small_filled

M.Numbers = {
  wt.nerdfonts.md_numeric_1,
  wt.nerdfonts.md_numeric_2,
  wt.nerdfonts.md_numeric_3,
  wt.nerdfonts.md_numeric_4,
  wt.nerdfonts.md_numeric_5,
  wt.nerdfonts.md_numeric_6,
  wt.nerdfonts.md_numeric_7,
  wt.nerdfonts.md_numeric_8,
  wt.nerdfonts.md_numeric_9,
  wt.nerdfonts.md_numeric_10,
}

return M

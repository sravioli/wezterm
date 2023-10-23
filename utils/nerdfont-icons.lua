---@diagnostic disable: undefined-field

---@class WezTerm
local wez = require "wezterm"

---Nerd font aggregated by type/class/etc.
---@class NerdFontIcons
---@field SemiCircle SemiCircleIcons
---@field Powerline  PowerlineIcons
---@field Vim        VimIcons
---@field Powershell PowershellIcons
---@field Bash       BashIcons
---@field Battery    BatteryIcons
---@field Wifi       WifiIcons
---@field Admin      AdminIcons
---@field Circle     CircleIcons
---@field Numbers    table
local NerdFontIcons = {
  ---@class SemiCircleIcons: string, string
  ---@field left  string ``
  ---@field right string ``
  SemiCircle = {
    left = wez.nerdfonts.ple_left_half_circle_thick,
    right = wez.nerdfonts.ple_right_half_circle_thick,
  },

  ---@class PowerlineIcons: string, string
  ---@field left  string ``
  ---@field right string ``
  Powerline = {
    left = wez.nerdfonts.pl_left_hard_divider,
    right = wez.nerdfonts.pl_right_hard_divider,
  },

  ---@class VimIcons: string, string
  ---@field dev    string ``
  ---@field custom string ``
  Vim = {
    dev = wez.nerdfonts.dev_vim,
    custom = wez.nerdfonts.custom_vim,
  },

  ---@class PowershellIcons: string, string, string
  ---@field md   string `󰨊`
  ---@field seti string ``
  ---@field cod  string ``
  Powershell = {
    md = wez.nerdfonts.md_powershell,
    seti = wez.nerdfonts.seti_powershell,
    cod = wez.nerdfonts.cod_terminal_powershell,
  },

  ---@class BashIcons: string, string
  ---@field cod  string ``
  ---@field md   string `󱆃`
  ---@field seti string ``
  Bash = {
    cod = wez.nerdfonts.cod_terminal_bash,
    md = wez.nerdfonts.md_bash,
    seti = wez.nerdfonts.seti_shell,
  },

  ---@class BatteryIcons: table, table
  ---@field charging table Icons for charging battery in increments of 10
  ---@field normal table Icons for non-charging battery in increments of 10
  Battery = {
    Charging = {
      ["00"] = wez.nerdfonts.md_battery_alert,
      ["10"] = wez.nerdfonts.md_battery_charging_10,
      ["20"] = wez.nerdfonts.md_battery_charging_20,
      ["30"] = wez.nerdfonts.md_battery_charging_30,
      ["40"] = wez.nerdfonts.md_battery_charging_40,
      ["50"] = wez.nerdfonts.md_battery_charging_50,
      ["60"] = wez.nerdfonts.md_battery_charging_60,
      ["70"] = wez.nerdfonts.md_battery_charging_70,
      ["80"] = wez.nerdfonts.md_battery_charging_80,
      ["90"] = wez.nerdfonts.md_battery_charging_90,
      ["100"] = wez.nerdfonts.md_battery_charging_100,
    },

    Discharging = {
      ["00"] = wez.nerdfonts.md_battery_outline, --- `󰂎`
      ["10"] = wez.nerdfonts.md_battery_10, --- `󰁺`
      ["20"] = wez.nerdfonts.md_battery_20, --- `󰁻`
      ["30"] = wez.nerdfonts.md_battery_30, --- `󰁼`
      ["40"] = wez.nerdfonts.md_battery_40, --- `󰁽`
      ["50"] = wez.nerdfonts.md_battery_50, --- `󰁾`
      ["60"] = wez.nerdfonts.md_battery_60, --- `󰁿`
      ["70"] = wez.nerdfonts.md_battery_70, --- `󰂀`
      ["80"] = wez.nerdfonts.md_battery_80, --- `󰂁`
      ["90"] = wez.nerdfonts.md_battery_90, --- `󰂂`
      ["100"] = wez.nerdfonts.md_battery, --- `󰁹`
    },
  },

  ---@class WifiIcons: string, string, string, string, string, string, string, string, string, string, string, string, string, string, string, string, string, string, string, string
  ---@field wifi             string `󰖩`
  ---@field alert            string `󱚵`
  ---@field arrow_down       string `󱚶`
  ---@field arrow_left       string `󱚷`
  ---@field arrow_left_right string `󱚸`
  ---@field arrow_right      string `󱚹`
  ---@field arrow_up         string `󱚺`
  ---@field arrow_up_down    string `󱚻`
  ---@field cancel           string `󱚼`
  ---@field check            string `󱚽`
  ---@field cog              string `󱚾`
  ---@field lock             string `󱚿`
  ---@field lock_open        string `󱛀`
  ---@field marker           string `󱛁`
  ---@field minus            string `󱛂`
  ---@field off              string `󰖪`
  ---@field plus             string `󱛃`
  ---@field refresh          string `󱛄`
  ---@field remove           string `󱛅`
  ---@field settings         string `󱛆`
  ---@field star             string `󰸋`
  Wifi = {
    wifi = wez.nerdfonts.md_wifi,
    alert = wez.nerdfonts.md_wifi_alert,
    arrow_down = wez.nerdfonts.md_wifi_arrow_down,
    arrow_left = wez.nerdfonts.md_wifi_arrow_left,
    arrow_left_right = wez.nerdfonts.md_wifi_arrow_left_right,
    arrow_right = wez.nerdfonts.md_wifi_arrow_right,
    arrow_up = wez.nerdfonts.md_wifi_arrow_up,
    arrow_up_down = wez.nerdfonts.md_wifi_arrow_up_down,
    cancel = wez.nerdfonts.md_wifi_cancel,
    check = wez.nerdfonts.md_wifi_check,
    cog = wez.nerdfonts.md_wifi_cog,
    lock = wez.nerdfonts.md_wifi_lock,
    lock_open = wez.nerdfonts.md_wifi_lock_open,
    marker = wez.nerdfonts.md_wifi_marker,
    minus = wez.nerdfonts.md_wifi_minus,
    off = wez.nerdfonts.md_wifi_off,
    plus = wez.nerdfonts.md_wifi_plus,
    refresh = wez.nerdfonts.md_wifi_refresh,
    remove = wez.nerdfonts.md_wifi_remove,
    settings = wez.nerdfonts.md_wifi_settings,
    star = wez.nerdfonts.md_wifi_star,
  },

  ---@class BluetoothIcons: string, string, string, string, string
  ---@field bluetooth string `󰂯`
  ---@field audio     string `󰂰`
  ---@field connect   string `󰂱`
  ---@field settings  string `󰂳`
  ---@field transfer  string `󰂴`
  Bluetooth = {
    bluetooth = wez.nerdfonts.md_bluetooth,
    audio = wez.nerdfonts.mmd_bluetooth_audio,
    connect = wez.nerdfonts.mmd_bluetooth_connect,
    settings = wez.nerdfonts.mmd_bluetooth_settings,
    transfer = wez.nerdfonts.mmd_bluetooth_transfer,
  },

  ---@class AdminIcons: string, string, string
  ---@field fill    string `󱐋`
  ---@field circle  string `󰠠`
  ---@field outline string `󱐌`
  Admin = {
    fill = wez.nerdfonts.md_lightning_bolt,
    circle = wez.nerdfonts.md_lightning_bolt_circle,
    outline = wez.nerdfonts.md_lightning_bolt_outline,
  },

  ---@class CircleIcons: string, string, string, string, string, string
  ---@field circle        string ``
  ---@field filled        string ``
  ---@field large         string ``
  ---@field large_filled  string ``
  ---@field slash         string ``
  ---@field small_filled  string ``
  Circle = {
    circle = wez.nerdfonts.cod_circle,
    filled = wez.nerdfonts.cod_circle_filled,
    large = wez.nerdfonts.cod_circle_large,
    large_filled = wez.nerdfonts.cod_circle_large_filled,
    slash = wez.nerdfonts.cod_circle_slash,
    small_filled = wez.nerdfonts.cod_circle_small_filled,
  },

  ---@enum Numbers
  Numbers = {
    wez.nerdfonts.md_numeric_1,
    wez.nerdfonts.md_numeric_2,
    wez.nerdfonts.md_numeric_3,
    wez.nerdfonts.md_numeric_4,
    wez.nerdfonts.md_numeric_5,
    wez.nerdfonts.md_numeric_6,
    wez.nerdfonts.md_numeric_7,
    wez.nerdfonts.md_numeric_8,
    wez.nerdfonts.md_numeric_9,
    wez.nerdfonts.md_numeric_10,
  },
}

return NerdFontIcons

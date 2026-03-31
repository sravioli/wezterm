---@module 'opts.statusbar'

local wt = require "wezterm"
local color_parse, timefmt = wt.color.parse, wt.strftime
local warp = require "plugs.warp" ---@class Warp.Api
local fs = warp.filesystem ---@class Warp.FileSystem
local maths = warp.maths ---@class Warp.Maths

local mfloor = math.floor

local cond = require "utils.conditions" ---@class Conditions
local icons = require "utils.icons" ---@class Icons

---Build a four-stop colour palette from the theme's accent colour.
---Render order (left → right): cwd · hostname · clock · battery
---Index 1 is the darkest (leftmost), 4 is the lightest (rightmost).
---
---Results are cached on `theme.ansi[5]` + `theme.tab_bar.background`; the
---four right-status modules that call this per repaint now share a single
---computation instead of repeating it 4×.
---
---@param  theme table
---@return table<integer, string> palette
---@return string text_fg  foreground colour for text inside palette cells
local _palette_key = nil
local _palette_bg_key = nil
local _palette_cache = nil
local _text_fg_cache = nil

local function make_palette(theme)
  local key = theme.ansi[5]
  local bg_key = theme.tab_bar.background
  if key == _palette_key and bg_key == _palette_bg_key then
    return _palette_cache, _text_fg_cache
  end
  local fg = color_parse(tostring(key))
  _palette_cache = {
    tostring(fg:darken(0.15)), -- [1] cwd
    tostring(fg), -- [2] hostname
    tostring(fg:lighten(0.15)), -- [3] clock
    tostring(fg:lighten(0.25)), -- [4] battery
  }
  _text_fg_cache = tostring(bg_key)
  _palette_key = key
  _palette_bg_key = bg_key
  return _palette_cache, _text_fg_cache
end

---Returns a `sep.style` function that paints a powerline arrow with
---`prev_bg` as its foreground, inheriting the module's own bg from
---`parent_style.bg`.
---
---@param  prev_bg_fn fun(theme: table, config: table): string
---@return fun(theme: table, parent_style: table): table
local function powerline_sep_style(prev_bg_fn)
  return function(theme, parent_style)
    return { bg = prev_bg_fn(theme, parent_style), fg = parent_style.bg }
  end
end

---The background colour of the surface immediately to the left of the
---first right-status cell.  Matches the original `last_fg` computation.
---
---@param  theme  table
---@param  config table
---@return string
local function bar_surface_bg(theme, config)
  if config and config.use_fancy_tab_bar then
    return tostring(config.window_frame.active_titlebar_bg)
  end
  return tostring(theme.tab_bar.background)
end

---@class Opts.StatusBar
local M = {
  enabled = true,
  position = "bottom",
  fancy = false,
  flexible = true,

  layout = {
    left = {
      "leader",
      "workspace",
      "mode",
    },
    right = {
      "keys",
      { "cwd", "hostname", "clock", "battery" },
    },
  },

  modules = {
    workspace = {
      enabled = true,
      padding = { left = 1 },
      cond = cond.all(cond.has_workspace, cond.mode_inactive),
      style = function(theme)
        return { bg = theme.ansi[6], fg = theme.background }
      end,

      icon = {
        enabled = true,
        value = icons.Workspace,
      },

      text = {
        enabled = true,
        padding = { left = 1 },
        value = function(window, _)
          return window:active_workspace()
        end,
        style = { attributes = "i" },
      },

      sep = {
        enabled = true,
        value = icons.Sep.ws,
        invert_bg_fg = true,
      },
    },

    leader = {
      enabled = true,
      cond = cond.leader_active,
      padding = { left = 1 },
      style = function(t)
        return { bg = t.ansi[2], fg = t.background }
      end,

      icon = {
        enabled = true,
        value = icons.Leader,
      },

      sep = {
        enabled = true,
        value = icons.Sep.leader,
        invert_bg_fg = true,
      },
    },

    mode = function(window, _pane, theme)
      local modes = require("utils.keymapper").get_modes(theme)
      local active_mode = window:active_key_table()

      if active_mode then
        local mode = modes[active_mode]

        return {
          enabled = true,
          cond = cond.mode_active,
          padding = { left = 1 },
          style = function(t)
            return { bg = mode.bg, fg = t.background }
          end,

          icon = {
            enabled = true,
            value = mode.i,
            padding = 1,
          },

          text = {
            enabled = true,
            value = mode.txt,
            padding = { right = 1 },
          },
        }
      end
      return { enabled = false }
    end,

    -- ── keys ──────────────────────────────────────────────────────────────────
    -- Renders the current key-table's hint bar with the legacy visual style:
    --   <bracket> in theme.foreground + bold
    --   key name  in mode.bg (the mode accent colour)
    --   desc text in theme.foreground + italic
    --   separator in theme.brights[1]
    --
    -- Width is derived from budget.right_available() which accounts for
    -- screen width, rendered tab cells, left-status columns, and the new-tab
    -- button - so the hint fills exactly the remaining space.
    keys = function(window, _, theme, config)
      local keymapper = require "utils.keymapper"
      local renderer = require "utils.renderer"
      local modes = keymapper.get_modes(theme)
      local active = window:active_key_table()

      if not active then
        return { enabled = false }
      end

      local mode = modes[active]
      if not mode then
        return { enabled = false }
      end

      return {
        enabled = true,
        cond = cond.mode_active,

        -- Use the `layout` field (function form) so the hint is rendered as a
        -- wezterm FormatItem array with per-segment colour and attributes.
        -- ctx.theme is the renderer's current resolved colour scheme.
        layout = function(ctx)
          local width = math.max(0, renderer.width.available - renderer.width.used)
          local hint = keymapper.hint_layout(config, active, width, window, {
            theme = ctx.theme,
            mode_bg = mode.bg,
          })
          return hint
        end,
      }
    end,

    -- cwd is the leftmost data cell → palette[1] (darkest)
    cwd = function(_, pane, theme, config)
      local cwd = fs.get_cwd(pane, true)
      local palette, text_fg = make_palette(theme)

      return {
        enabled = true,
        cond = cond.mode_inactive,
        can_hide = true,
        style = function()
          return { bg = palette[1], fg = text_fg }
        end,

        sep = {
          enabled = true,
          value = { right = icons.Sep.sb.right },
          style = powerline_sep_style(function(t, cfg)
            return bar_surface_bg(t, cfg or config)
          end),
        },

        icon = {
          enabled = true,
          value = icons.Folder,
          position = "right",
          padding = { right = 1 },
        },

        text = {
          enabled = true,
          value = cwd,
          padding = 1,
        },
      }
    end,

    -- hostname → palette[2], prev = cwd (palette[1])
    hostname = function(_, pane, theme, _)
      local hostname = fs.get_hostname(pane)
      local palette, text_fg = make_palette(theme)

      return {
        enabled = true,
        cond = cond.mode_inactive,
        can_hide = true,
        style = function()
          return { bg = palette[2], fg = text_fg }
        end,

        sep = {
          enabled = true,
          value = { right = icons.Sep.sb.right },
          style = powerline_sep_style(function()
            return palette[1]
          end),
        },

        icon = {
          enabled = true,
          value = icons.Hostname,
          position = "right",
          padding = { right = 1 },
        },

        text = {
          enabled = true,
          value = hostname,
          padding = 1,
        },
      }
    end,

    clock = function(_, _, theme, _)
      local palette, text_fg = make_palette(theme)

      local hour_24 = tonumber(timefmt "%H")
      local hour_12 = timefmt "%I"

      local is_day = hour_24 >= 6 and hour_24 < 18
      local mode = is_day and "day" or "night"

      local time_ico = icons.Clock[mode][hour_12]

      return {
        enabled = true,
        cond = cond.mode_inactive,
        style = function()
          return { bg = palette[3], fg = text_fg }
        end,

        sep = {
          enabled = true,
          value = { right = icons.Sep.sb.right },
          style = powerline_sep_style(function()
            return palette[2]
          end),
        },

        icon = {
          enabled = true,
          value = time_ico,
          position = "right",
          padding = 1,
        },

        text = {
          enabled = true,
          value = timefmt "%a %b %-d %H:%M",
          padding = { left = 1 },
        },
      }
    end,

    -- battery is the rightmost data cell → palette[4] (lightest); can be hidden
    battery = function(_, _, theme, _)
      local bat = wt.battery_info()[1]
      if not bat then
        return { enabled = false }
      end

      local charge = bat.state_of_charge * 100
      local charge_r = mfloor(maths.round_to(charge, 10))
      local bat_ico = icons.Bat[bat.state][tostring(charge_r)]
      local bat_lvl = tostring(math.floor(charge + 0.5)) .. "%"
      local palette, text_fg = make_palette(theme)

      return {
        enabled = true,
        cond = cond.mode_inactive,
        can_hide = true,
        style = function()
          return { bg = palette[4], fg = text_fg }
        end,

        sep = {
          enabled = true,
          value = { right = icons.Sep.sb.right },
          style = powerline_sep_style(function()
            return palette[3]
          end),
        },

        icon = {
          enabled = true,
          value = bat_ico,
          position = "right",
          padding = 1,
        },

        text = {
          enabled = true,
          value = bat_lvl,
          padding = { left = 1, right = 0 },
        },
      }
    end,
  },
}

return M

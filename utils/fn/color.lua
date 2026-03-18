local wt = require "wezterm" ---@class Wezterm

local Opts = require("opts").config.color ---@class Opts.Config.Color

local Icon = require "utils.icons" ---@class Icons
local layout = require "utils.layout" ---@class Layout

---Manage and apply color schemes in Lua-based environment.
---Dynamically load schemes, determine scheme based on GUI appearance, and apply schemes
---to visual elements.
---@class Fn.Color
local M = {}

---Internal logger instance.
---@package
M.log = require("utils.logger").new "Fn.Color"

---Load color schemes lazily via `__index`.
---Schemes are loaded on first access by name, avoiding the startup cost of
---scanning the filesystem and requiring all ~30 colorscheme modules eagerly.
---@return table<string, table> schemes Lazy map of colorschemes.
M.get_schemes = function()
  return setmetatable({}, {
    __index = function(t, name)
      -- Ignore non-string keys (WezTerm's Rust side probes numeric indices)
      if type(name) ~= "string" then
        return nil
      end
      local mod_path = "picker.assets.colorschemes." .. name
      local ok, mod = pcall(require, mod_path)
      if ok and mod and mod.scheme then
        rawset(t, name, mod.scheme)
        M.log:debug("loaded %s colorscheme (lazy)", name)
        return mod.scheme
      end
      M.log:error("Unable to load colorscheme: '%s'", name)
      return nil
    end,
  })
end

---Determine appropriate color scheme based on GUI appearance.
---Check current GUI appearance (Dark/Light) and return compatible scheme name.
---@return "kanagawa-wave"|"kanagawa-lotus" colorscheme Name of the active colorscheme.
M.get_scheme = function()
  if string.find((wt.gui and wt.gui.get_appearance() or ""), "Dark") then
    return Opts.default_schemes.dark
  end
  return Opts.default_schemes.light
end --~~}}}

---Set tab button style in configuration based on specified theme.
---Update configuration object with styles for `new_tab` and `new_tab_hover`.
---@param Config table Configuration object to update.
---@param theme Fn.Color.Theme Theme object containing specific tab states.
M.set_tab_button = function(Config, theme)
  Config.tab_bar_style = {}
  local sep = Icon.Sep.tb

  local states = { "new_tab", "new_tab_hover" }
  for i = 1, #states do
    local state = states[i]
    local style = theme.tab_bar[state]
    local sep_bg, sep_fg = style.bg_color, theme.tab_bar.background

    local bl = layout:new "ButtonLayout"
    local attributes = {
      style.intensity
        or (style.italic and "Italic")
        or (style.strikethrough and "Strikethrough")
        or (style.underline ~= "None" and style.underline),
    }

    bl:append(sep_bg, sep_fg, sep.right, attributes)
    bl:append(sep_bg, style.fg_color, " + ", attributes)
    bl:append(sep_bg, sep_fg, sep.left, attributes)

    Config.tab_bar_style[state] = bl:format()
  end
end

---Configure color scheme and related visual settings.
---Apply background, character selection, and command palette colors based on theme.
---@param Config table Configuration to update with new color scheme.
---@param theme Fn.Color.Theme Valid colorscheme object.
---@param name string Name of the color scheme to apply.
M.set_scheme = function(Config, theme, name)
  Config.color_scheme = name
  Config.color_schemes = Config.color_schemes or {}
  Config.color_schemes[name] = theme
  Config.char_select_bg_color = theme.brights[6]
  Config.char_select_fg_color = theme.background
  Config.command_palette_bg_color = theme.brights[6]
  Config.command_palette_fg_color = theme.background
  Config.background = {
    {
      source = { Color = theme.background },
      width = "100%",
      height = "100%",
      opacity = Opts.opacity or 1,
    },
  }
  M.set_tab_button(Config, theme)
end

return M

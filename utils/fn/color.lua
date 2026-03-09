local wt = require "wezterm" ---@class Wezterm

local Opts = require("opts").config.color ---@class Opts.Config.Color

local Icon = require "utils.icons" ---@class Icons
local fs = require "utils.fn.fs" ---@class Fn.FileSystem
local layout = require "utils.layout" ---@class Layout

---Manage and apply color schemes in Lua-based environment.
---Dynamically load schemes, determine scheme based on GUI appearance, and apply schemes
---to visual elements.
---@class Fn.Color
local M = {}

---Internal logger instance.
---@package
M.log = require("utils.logger"):new "Fn.Color"

---Load and return all available color schemes.
---Scan predefined directory for Lua files, load them dynamically, and return table of schemes.
---@return table<string, table> schemes Map of loaded colorschemes.
M.get_schemes = function()
  local dir = fs.join_path(wt.config_dir, "picker", "assets", "colorschemes")
  local files = fs.ls_dir(dir)
  if not files then
    M.log:error("Unable to read from directory: '%s'", fs.basename(dir))
    return {}
  end

  local schemes = {}
  for i = 1, #files do
    local name = fs.basename(files[i]:gsub("%.lua$", ""))
    schemes[name] = require("picker.assets.colorschemes." .. name).scheme
    M.log:debug("loaded %s colorscheme", name)
  end
  return schemes
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

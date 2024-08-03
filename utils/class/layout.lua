---@module "utils.class.layout"
---@author sravioli
---@license GNU-GPLv3.0

local Logger = require "utils.class.logger"
local wt = require "wezterm"

local attribute_mappings = {
  None = "ResetAttributes",
  NoUnderline = { Underline = "None" },
  Single = { Underline = "Single" },
  Double = { Underline = "Double" },
  Curly = { Underline = "Curly" },
  Dotted = { Underline = "Dotted" },
  Dashed = { Underline = "Dashed" },
  Normal = { Intensity = "Normal" },
  Bold = { Intensity = "Bold" },
  Half = { Intensity = "Half" },
  Italic = { Italic = true },
  NoItalic = { Italic = false },
}

-- stylua: ignore
local ansi_colors = {
  Black = true, Maroon  = true, Green = true, Olive = true, Navy = true, Purple = true,
  Teal  = true, Silver  = true, Grey  = true, Red   = true, Lime = true, Yellow = true,
  Blue  = true, Fuchsia = true, Aqua  = true, White = true,
}

---The `Layout` class was created to address the need for a more straightforward and organized
---way to build formatted text layouts in Wezterm.  Wezterm's
---[`FormatItem`](https://wezfurlong.org/wezterm/config/lua/wezterm/format.html) objects
---can be cumbersome to handle directly, especially when dealing with multiple attributes
---and text segments.  The `Layout` class encapsulates this complexity, providing a clear
---and concise API to manage these objects.
---
---@class Utils.Class.Layout
---@field private layout table
---@field private log    table
---@field private name   string
local M = {}

---Creates a new class instance.
---
---@param name? string name of the layout. Used for logging purposes.
---@return Utils.Class.Layout layout newly created class instance.
function M:new(name)
  name = "Layout" .. (name and " > " .. name or "")
  return setmetatable(
    { layout = {}, log = Logger:new(name), name = name },
    { __index = self }
  )
end

---Push the given element in the Layout.
---
---Pushes the text element with the specified background and foreground colors, as well as
---optional attributes such as: underline style, text intensity, etc.
---
---Supports all the attributes that the Wezterm's
---[`FormatItem`](https://wezfurlong.org/wezterm/config/lua/wezterm/format.html) object
---defines:
---
--- - `None`: Reset attributes.
--- - `NoUnderline`: No underline.
--- - `Single`: Single underline.
--- - `Double`: Double underline.
--- - `Curly`: Curly underline.
--- - `Dotted`: Dotted underline.
--- - `Dashed`: Dashed underline.
--- - `Normal`: Normal intensity.
--- - `Bold`: Bold intensity.
--- - `Half`: Half intensity.
--- - `Italic`: Italic text.
--- - `NoItalic`: No italic text.
---
---Moreover support the definition of the `background` and/or `foreground` color either
---with ansi colors, named colors, rbg values or Wezterm's color objects.
---
---@param background  string background color of the element.
---@param foreground  string foreground color of the element.
---@param text        string text to be added.
---@param attributes? table  attributes to style the text.
---@return Utils.Class.Layout self updated layout instance.
function M:push(background, foreground, text, attributes)
  self.log:debug(
    "pushing: { bg: %s, fg: %s, attributes: %s, text: %s }",
    background,
    foreground,
    attributes,
    text
  )
  self = self or {}

  local function set_color(attr, color)
    if ansi_colors[color] then
      self[#self + 1] = { [attr] = { AnsiColor = color } }
    else
      self[#self + 1] = { [attr] = { Color = color } }
    end
  end

  set_color("Background", background)
  set_color("Foreground", foreground)

  if attributes then
    for k = 1, #attributes do
      local attribute = attributes[k]
      if attribute_mappings[attribute] then
        self[#self + 1] = { Attribute = attribute_mappings[attribute] }
      else
        self.log:error("attribute '%s' is not defined!", attribute)
      end
    end
  end

  self[#self + 1] = { Text = text }

  return self
end

---Clears all elements from the layout.
---
---@return Utils.Class.Layout self The cleared layout instance.
function M:clear()
  self.log:debug("clearing layout %s", self.name)
  self.layout = {}
  return self
end

---Formats the Layout object
---
---@return string format The resulting string formatted by `wezterm.format()`
function M:format()
  self.log:debug("formatting layout %s", self.name)

  ---@diagnostic disable-next-line: undefined-field
  return wt.format(self)
end

---Logs the unformatted layout to wezterm's debug console
---@param formatted boolean whether to log the formatted layout or not
function M:debug(formatted)
  self.log:info(formatted and self:format() or self)
end

return M

---@module "utils.class.layout"
---@author sravioli
---@license GNU-GPLv3.0

local Logger = require "utils.class.logger"
local wt = require "wezterm"

-- selene: allow(incorrect_standard_library_use)
local tinsert, tunpack = table.insert, unpack or table.unpack

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

---Inserts the given element in the Layout.
---
---Inserts the text element with the specified background and foreground colors, as well as
---optional attributes such as: underline style, text intensity, etc.
---
---Supports all the attributes that Wezterm's
---[`FormatItem`](https://wezfurlong.org/wezterm/config/lua/wezterm/format.html) object
---defines, and supports color definitions similarly.
---
---@param action      "append"|"prepend" action type
---@param background  string background color of the element.
---@param foreground  string foreground color of the element.
---@param text        string text to be added.
---@param attributes? table  attributes to style the text.
---@return Utils.Class.Layout self updated layout instance.
function M:insert(action, background, foreground, text, attributes)
  if not action or action == "" then
    return self.log:error "Cannot operate with empty action"
  end

  local idx = function()
    return action == "prepend" and 1 or #self + 1
  end

  local colors_pair = { { "Background", background }, { "Foreground", foreground } }
  for i = 1, #colors_pair do
    local attr, color = tunpack(colors_pair[i])
    local color_entry = ansi_colors[color] and { [attr] = { AnsiColor = color } }
      or { [attr] = { Color = color } }

    tinsert(self, idx(), color_entry)
  end

  if attributes then
    for i = 1, #attributes do
      local attribute = attributes[i]
      if not attribute_mappings[attribute] then
        return self.log:error("attribute '%s' is not defined!", attribute)
      end

      tinsert(self, idx(), { Attribute = attribute_mappings[attribute] })
    end
  end

  tinsert(self, idx(), { Text = text })

  return self
end

---Append the given element in the Layout.
---@see Utils.Class.Layout.insert
function M:append(background, foreground, text, attributes)
  return M.insert(self, "append", background, foreground, text, attributes)
end

---Prepend the given element in the Layout.
---@see Utils.Class.Layout.insert
function M:prepend(background, foreground, text, attributes)
  return M.insert(self, "prepend", foreground, background, text, attributes)
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

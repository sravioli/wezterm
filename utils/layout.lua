---@module "utils.layout"
---@author sravioli
---@license GNU-GPLv3.0

local wt = require "wezterm" ---@class Wezterm

---@class Layout
local Layout = {}

local insert = table.insert

---Creates a new instance of the Layout class.
---
---Initializes a new Layout object with an empty layout table.
---
---@return Layout layout newly created class instance.
function Layout:new()
  return setmetatable({ layout = {} }, { __index = self })
end

---Add elements to the layout table.
---
---Adds text elements to the layout with specified background and foreground colors, as
---well as optional attributes such as underline style, intensity, and italic style.
---
---The following attributes are supported:
---
---```lua
---local attributes = {
---  NoUnderline = { Underline = "None" },
---  Single = { Underline = "Single" },
---  Double = { Underline = "Double" },
---  Curly = { Underline = "Curly" },
---  Dotted = { Underline = "Dotted" },
---  Dashed = { Underline = "Dashed" },
---  Normal = { Intensity = "Normal" },
---  Bold = { Intensity = "Bold" },
---  Half = { Intensity = "Half" },
---  Italic = { Italic = true },
--   NoItalic = { Italic = false },
---}
---```
---@param background string background color of the cell.
---@param foreground string foreground color of the cell.
---@param text string text to be added.
---@param attributes? table list of attributes to be added.
---@return Layout self The updated layout instance.
function Layout:push(background, foreground, text, attributes)
  self = self or {}
  insert(self, { Background = { Color = background } })
  insert(self, { Foreground = { Color = foreground } })

  local attribute_mappings = {
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

  if attributes then
    for _, attribute in ipairs(attributes) do
      if attribute_mappings[attribute] then
        insert(self, { Attribute = attribute_mappings[attribute] })
      else
        wt.log_error("Layout: Attribute '" .. attribute .. "' is non-existant")
      end
    end
  end

  insert(self, { Text = text })

  return self
end

---Clears all elements from the layout.
---
---@return Layout self The cleared layout instance.
function Layout:clear()
  self.layout = {}
  return self
end

return Layout

---@class Layout
local Layout = {}

---Creates a new instance of the Layout class.
---@return table instance newly created class instance
function Layout:new()
  return setmetatable({ layout = {} }, { __index = self })
end

---Add elements to the layout table.
---
---the following attributes are supported:
---
---```lua
---local attributes = {
---  Single = { Underline = "Single" },
---  Double = { Underline = "Double" },
---  Curly = { Underline = "Curly" },
---  Dotted = { Underline = "Dotted" },
---  Dashed = { Underline = "Dashed" },
---  Normal = { Intensity = "Normal" },
---  Bold = { Intensity = "Bold" },
---  Half = { Intensity = "Half" },
---  Italic = { Italic = true },
---}
---```
---@param background string The background color of the cell.
---@param foreground string The foreground color of the cell.
---@param text string The text to be added.
---@param attributes? table The list of attributes to be added.
---@return table self The updated layout table.
function Layout:push(background, foreground, text, attributes)
  self = self or {}
  local insert = table.insert
  insert(self, { Background = { Color = background } })
  insert(self, { Foreground = { Color = foreground } })

  local attribute_mappings = {
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
      end
    end
  end

  table.insert(self, { Text = text })

  return self
end

return Layout


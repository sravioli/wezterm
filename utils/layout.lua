---@class WezTermLayout: function, function
local Layout = {}

---Creates a new instance of the Layout class.
---@return table obj The newly created Layout instance.
function Layout:new()
  self.layout = {}
  self = setmetatable(self.layout, { __index = Layout })
  return self
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
  self.layout = self.layout or {}
  table.insert(self.layout, { Background = { Color = background } })
  table.insert(self.layout, { Foreground = { Color = foreground } })

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
  }

  if attributes then
    for _, attribute in ipairs(attributes) do
      if attribute_mappings[attribute] then
        table.insert(self.layout, { Attribute = attribute_mappings[attribute] })
      end
    end
  end

  table.insert(self.layout, { Text = text })

  return self.layout
end

return Layout


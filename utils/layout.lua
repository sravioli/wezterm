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
---@param background string The background color of the cell.
---@param foreground string The foreground color of the cell.
---@param text string The text to be added.
---@param attributes? table The list of attributes to be added.
---@return table self The updated layout table.
function Layout:push(background, foreground, text, attributes)
  self.layout = self.layout or {}
  table.insert(self.layout, { Background = { Color = background } })
  table.insert(self.layout, { Foreground = { Color = foreground } })

  if attributes then
    for _, attribute in ipairs(attributes) do
      if attribute == "Single" then
        table.insert(self.layout, { Attribute = { Underline = "Single" } })
      elseif attribute == "Double" then
        table.insert(self.layout, { Attribute = { Underline = "Double" } })
      elseif attribute == "Curly" then
        table.insert(self.layout, { Attribute = { Underline = "Curly" } })
      elseif attribute == "Dotted" then
        table.insert(self.layout, { Attribute = { Underline = "Dotted" } })
      elseif attribute == "Dashed" then
        table.insert(self.layout, { Attribute = { Underline = "Dashed" } })
      elseif attribute == "Normal" then
        table.insert(self.layout, { Attribute = { Intensity = "Normal" } })
      elseif attribute == "Bold" then
        table.insert(self.layout, { Attribute = { Intensity = "Bold" } })
      elseif attribute == "Half" then
        table.insert(self.layout, { Attribute = { Intensity = "Half" } })
      elseif attribute == "Italic" then
        table.insert(self.layout, { Attribute = { Italic = true } })
      end
    end
  end

  table.insert(self.layout, { Text = text })

  return self.layout
end

return Layout

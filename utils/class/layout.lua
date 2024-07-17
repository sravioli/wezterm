---@diagnostic disable: undefined-field

---Utility class to simplify the creation and handling of wezterm's `FormatItem` object.
---
---@module "utils.class.layout"
---@author sravioli
---@license GNU-GPLv3.0

local wt = require "wezterm"
local log_info, _, log_error = wt.log_info, wt.log_warn, wt.log_error
local wt_format = wt.format

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

---@class Layout
local M = {}

---Creates a new instance of the Layout class.
---
---Initializes a new Layout object with an empty layout table.
---
---@return Layout layout newly created class instance.
function M:new()
  log_info "Creating new layout object"
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
---  None = "ResetAttributes",
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
---  NoItalic = { Italic = false },
---}
---```
---@param background string background color of the cell.
---@param foreground string foreground color of the cell.
---@param text string text to be added.
---@param attributes? table list of attributes to be added.
---@return Layout self The updated layout instance.
function M:push(background, foreground, text, attributes)
  self = self or {}
  self[#self + 1] = { Background = { Color = background } }
  self[#self + 1] = { Foreground = { Color = foreground } }

  if attributes then
    for k = 1, #attributes do
      local attribute = attributes[k]
      if attribute_mappings[attribute] then
        self[#self + 1] = { Attribute = attribute_mappings[attribute] }
      else
        log_error("Layout: Attribute '" .. attribute .. "' is non-existant")
      end
    end
  end

  self[#self + 1] = { Text = text }

  return self
end

---Clears all elements from the layout.
---
---@return Layout self The cleared layout instance.
function M:clear()
  self.layout = {}
  log_info "Successfully cleared the Layout"
  return self
end

---Formats the Layout object
---
---@return string format The resulting string formatted by `wezterm.format()`
function M:format()
  return wt_format(self.layout)
end

---Logs the unformatted layout to wezterm's debug console
---@param formatted boolean whether to log the formatted layout or not
function M:debug(formatted)
  log_info { Layout = formatted and wt_format(self.layout) or self.layout }
end

return M

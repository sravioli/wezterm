---@module "utils.layout"

local Logger = require "utils.logger" ---@class Logger
local wt = require "wezterm" ---@class Wezterm

local Opts = require("opts").utils.layout ---@class Opts.Utils.Layout

-- selene: allow(incorrect_standard_library_use)
local tinsert, tunpack = table.insert, unpack or table.unpack

---Resolve attribute name through aliases.
---
---Supports both single attribute aliases and multi-attribute combinations.
---Returns either a string (single attribute) or array (multiple attributes).
---
---@param attribute string            Attribute name or alias.
---@param log       Logger            Logger instance for warnings.
---@return string|string[] resolved Resolved attribute(s).
local function _resolve_attribute(attribute, log)
  if Opts.attribute_aliases and Opts.attribute_aliases[attribute] then
    local resolved = Opts.attribute_aliases[attribute]

    if type(resolved) == "table" then
      return resolved
    end

    attribute = resolved
  end

  if Opts.defaults.attributes[attribute] then
    return attribute
  end

  if Opts.validate_attributes then
    local msg = string.format("Unknown attribute '%s'", attribute)
    if Opts.strict_mode then
      error(msg)
    else
      log:warn(msg)
    end
  end

  return attribute
end

---Process text according to configuration.
---
---@param text string|nil Text to process.
---@return string processed Processed text.
local function _process_text(text)
  text = text or tostring(text)

  if Opts.text.strip then
    text = text:match "^%s*(.-)%s*$"
  end

  if Opts.text.transform then
    text = Opts.text.transform(text)
  end

  if Opts.text.max_length and #text > Opts.text.max_length then
    text = text:sub(1, Opts.text.max_length) .. "..."
  end

  return text
end

---Insert color definition at specific index.
---
---@package
---@param layout Layout         Layout to modify in place.
---@param bg?    string         Background color.
---@param fg?    string         Foreground color.
---@param idx    fun(): integer Insertion index.
local function _insert_colors(layout, bg, fg, idx)
  bg = bg or Opts.defaults.background
  fg = fg or Opts.defaults.foreground

  local colors_pair = { { "Background", bg or "none" }, { "Foreground", fg or "none" } }
  for i = 1, #colors_pair do
    local attr, color = tunpack(colors_pair[i])
    local color_entry = Opts.defaults.colors[color] and { [attr] = { AnsiColor = color } }
      or { [attr] = { Color = color } }
    tinsert(layout, idx(), color_entry)
  end
end

---Insert attributes at specific index.
---@package
---@param layout      Layout               Layout to modify in place
---@param attributes? table<string>|string List of attributes or single attribute.
---@param idx         fun(): integer       Insertion index.
---@param log         Logger               Logger instance.
local function _insert_attributes(layout, attributes, idx, log)
  if not attributes or (type(attributes) == "table" and #attributes == 0) then
    attributes = Opts.defaults.attributes
  end

  if not attributes or (type(attributes) == "table" and #attributes == 0) then
    return
  end

  local attr_list = (type(attributes) == "string") and { attributes } or attributes

  local function process_attr(val)
    local resolved = _resolve_attribute(val, log)

    if type(resolved) == "table" then
      for _, nested_val in ipairs(resolved) do
        process_attr(nested_val)
      end
    elseif type(resolved) == "string" then
      if Opts.defaults.attributes[resolved] then
        local attr = Opts.defaults.attributes[resolved]
        tinsert(layout, idx(), attr == "ResetAttributes" and attr or { Attribute = attr })
      else
        log:error("attribute '%s' is not defined!", resolved)
      end
    end
  end

  for _, attr in ipairs(attr_list) do
    process_attr(attr)
  end
end

---Wrapper for WezTerm's `FormatItem` objects.
---
---Encapsulates the complexity of managing multiple attributes, colors, and text segments
---into a linear list of operations.
---
---@class Layout
---@field         log    Logger  Logger instance.
---@field public atomic? boolean Whether to reset text attributes after each operation.
---@field private layout table   Internal storage.
---@field private name   string  Layout identifier.
local M = {}

---Create new layout instance.
---
---@param name?   string Name of the layout used for logging.
---@param atomic? boolean Whether or not each operation is atomic (resets attributes after each operation)
---@return Layout layout Newly created instance.
function M:new(name, atomic)
  name = "Layout" .. (name and " > " .. name or "")
  local is_atomic = atomic
  if is_atomic == nil then
    is_atomic = Opts.atomic
  end
  return setmetatable({
    layout = {},
    log = Logger:new(name, Opts.log.enabled, Opts.log.sinks),
    name = name,
    atomic = is_atomic,
  }, { __index = self })
end

---Add element into layout.
---
---Adds text with specified colors and optional style attributes. Supports all attributes
---defined by WezTerm's `FormatItem`.
---
---@param action      "append"|"prepend"   Action type.
---@param background? string               Background color.
---@param foreground? string               Foreground color.
---@param text?       string               Text content.
---@param attributes? table<string>|string Style attributes (e.g., "Bold", "Italic").
---@return Layout|nil self Updated layout instance. Nil when `action` is invalid.
function M:add(action, background, foreground, text, attributes)
  if not action or action == "" then
    return self.log:error "Cannot operate with empty action"
  end

  local idx = function()
    return action == "prepend" and 1 or #self.layout + 1
  end

  _insert_colors(self.layout, background, foreground, idx)
  _insert_attributes(self.layout, attributes, idx, self.log)

  tinsert(self.layout, idx(), { Text = _process_text(text) })

  if self.atomic then
    tinsert(self.layout, idx(), Opts.defaults.attributes.None)
  end

  return self
end

---Append element to layout end.
---
---@param background? string               Background color.
---@param foreground? string               Foreground color.
---@param text?       string               Text content.
---@param attributes? table<string>|string Style attributes.
---@return Layout|nil self Updated layout instance.
function M:append(background, foreground, text, attributes)
  return M.add(self, "append", background, foreground, text, attributes)
end

---Prepend element to layout start.
---
---@param background? string Background color.
---@param foreground? string Foreground color.
---@param text?       string Text content.
---@param attributes? table  Style attributes.
---@return Layout|nil self Updated layout instance.
function M:prepend(background, foreground, text, attributes)
  return M.add(self, "prepend", foreground, background, text, attributes)
end

---Clear all elements from layout.
---
---@return Layout self Cleared layout instance.
function M:clear()
  self.layout = {}
  return self
end

---
function M:reset_attributes()
  tinsert(self.layout, "ResetAttributes")
end

---Render layout object to string.
---
---@return string format Resulting string formatted by `wezterm.format()`.
function M:format()
  return wt.format(self.layout)
end

---Log layout to debug console.
---
---@param formatted boolean Whether to log the formatted string (true) or raw table (false).
function M:debug(formatted)
  self.log:info(self.name .. " formatted: %s", formatted and self:format() or self.layout)
end

return M

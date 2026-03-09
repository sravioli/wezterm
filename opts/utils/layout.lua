---@module "opts.utils.layout"

---@class Opts.Utils.Layout
return {
  log = {
    enabled = true,
    threshold = "WARN",
    sinks = { default_enabled = true },
  },

  defaults = {
    foreground = nil,
    background = nil,

    attributes = {
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
    },

    -- stylua: ignore
    colors = {
      Black = true, Maroon  = true, Green = true, Olive = true, Navy = true, Purple = true,
      Teal  = true, Silver  = true, Grey  = true, Red   = true, Lime = true, Yellow = true,
      Blue  = true, Fuchsia = true, Aqua  = true, White = true,
    },
  },

  attribute_aliases = {
    -- Single attribute shortcuts
    b = "Bold",
    i = "Italic",
    u = "Single",
    dim = "Half",
    reset = "None",

    -- Multi-attribute combinations
    highlight = { "Bold", "Single" },
    emph = { "Bold", "Italic" },
    subtle = { "Half", "Italic" },
  },

  -- Validation settings
  validate_attributes = false, -- Warn about invalid attributes
  strict_mode = false, -- Error instead of warn on validation failures

  -- Text processing
  text = {
    strip = false,
    max_length = nil,
    transform = nil,
  },

  atomic = false,
}

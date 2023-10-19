local wz = require "wezterm"
local kanagawa = require "colorschemes.kanagawa"

---@class config Appearance configuration options for WezTerm
---@field command_palette_bg_color string Specifies the background color used by
---       `ActivateCommandPalette`. Defaults to `"#333333"`.
---@field command_palette_fg_color string Specifies the text color used by
---       `ActivateCommandPalette`. Defaults to `rgba(0.75, 0.75, 0.75, 1.0)`.
---@field command_palette_font_size integer Specifies the size of the font used with
---       `ActivateCommandPalette`. Defaults to `14`.
---@field char_select_bg_color string Specifies the background color used by `CharSelect`.
---       Defaults to `"#333333"`.
---@field char_select_fg_color string Specifies the foreground color used by `CharSelect`.
---       Defaults to `rgba(0.75, 0.75, 0.75, 1.0)`.
---@field char_select_font_size string Specifies the size of the font used with
---       `CharSelect`. Defaults to `14`
local config = {}

---The `background` config option allows you to compose a number of layers to produce
---the background content in the terminal.
---
---Layers can be image files, gradients or solid blocks of color. Layers composite
---over each other based on their alpha channel. Images in layers can be made to fill
---the viewport or to tile, and also to scroll with optional parallax as the viewport
---is scrolled.
---
---The background option is a table that lists the desired layers starting with the
---deepest/back-most layer. Subsequent layers are composited over the top of preceding
---layers.
---
---**Layer Definition**
---A layer is a lua table with the following fields:
---
---* `source` - defines the source of the layer texture data. See below for source
---  definitions
---* `attachment` - controls whether the layer is fixed to the viewport or moves as
---   it scrolls. Can be:
---   * `"Fixed"` (the default) to not move as the window scrolls,
---   * `"Scroll"` to scroll 1:1 with the number of pixels scrolled in the viewport,
---   * `{Parallax=0.1}` to scroll 1:10 with the number of pixels scrolled in the viewport.
---* `repeat_x` - controls whether the image is repeated in the x-direction. Can be one of:
---   * `"Repeat"` - Repeat as much as possible to cover the area. The last image will
---     be clipped if it doesn't fit. This is the default.
---   * `"Mirror"` - Like `"Repeat"` except that the image is alternately mirrored
---     which can make images that don't tile seamlessly look a bit better when repeated
---   * `"NoRepeat"` - the image is not repeated.
---* `repeat_x_size` - Normally, when repeating, the image is tiled based on its
---  width such that each copy of the image is immediately adjacent to the preceding
---  instance. You may set `repeat_x_size` to a different value to increase or
---  decrease the space between the repeated instances. Accepts:
---  - number values in pixels,
---  - string values like `"100%"` to specify a size relative to the viewport,
---* `"10cell"` to specify a size based on the terminal cell metrics.
---* `repeat_y` - like `repeat_x` but affects the y-direction.
---* `repeat_y_size` - like `repeat_x_size` but affects the y-direction.
---* `vertical_align` - controls the initial vertical position of the layer, relative
---   to the viewport:
---  * `"Top"` (the default),
---  * `"Middle"`,
---  * `"Bottom"`
---* `vertical_offset` - specify an offset from the initial vertical position. Accepts:
---  * number values in pixels,
---  * string values like `"100%"` to specify a size relative to the viewport,
---  * `"10cell"` to specify a size based on terminal cell metrics.
---* `horizontal_align` - controls the initial horizontal position of the layer, relative
---  to the viewport:
---  * `"Left"` (the default),
---  * `"Center"`
---  * `"Right"`
---* `horizontal_offset` - like `vertical_offset` but applies to the x-direction.
---* `opacity` - a number in the range `0` through `1.0` inclusive that is multiplied
---  with the alpha channel of the source to adjust the opacity of the layer. The default
---  is `1.0` to use the source alpha channel as-is. Using a smaller value makes the
---  layer less opaque/more transparent.
---* `hsb` - a hue, saturation, brightness transformation that can be used to adjust
---  those attributes of the layer. See foreground_text_hsb for more information about
---  this kind of transform.
---* `height` - controls the height of the image. The following values are accepted:
---  * `"Cover"` (this is the default) - Scales the image, preserving aspect ratio,
---    to the smallest possible size to fill the viewport, leaving no empty space.
---    If the aspect ratio of the viewport differs from the image, the image is cropped.
---  * `"Contain"` - Scales the image as large as possible without cropping or stretching.
---    If the viewport is larger than the image, tiles the image unless `repeat_y` is
---    set to `"NoRepeat"`.
---  * `123` - specifies a height of `123` pixels
---  * `"50%"` - specifies a size of `50%` of the viewport height
---  * `"2cell"` - specifies a size equivalent to `2` rows
---* `width` - controls the width of the image. Same details as `height` but applies to the x-direction.
config.background = {
  {
    source = {
      Color = require("colorschemes.kanagawa").background,
    },
    width = "100%",
    height = "100%",
    opacity = 0.1,
  },
  {
    source = { Color = "black" },
    width = "100%",
    height = "100%",
    opacity = 0.4,
  },
}

---When true (the default), PaletteIndex 0-7 are shifted to bright when the font
---intensity is bold.
---
---This brightening effect doesn't occur when the text is set to the default foreground
---color!
---
---This defaults to true for better compatibility with a wide range of mature software;
---for instance, a lot of software assumes that Black+Bold renders as a Dark Grey which
---is legible on a Black background, but if this option is set to false, it would render
---as Black on Black.
---
---This option can now have one of three values:
---
---* `"No"` - the bold attribute will not influence palette selection
---* `"BrightAndBold"` - the bold attribute will select a bright version of palette
---  indices 0-7 and preserve the bold attribute on the text, using both a bold font
---  and a brighter color
---* `"BrightOnly"` - the bold attribute will select a bright version of palette
---  indices 0-7 but the intensity will be treated as normal and a non-bold font will
---  be used for the text.
---
---You may use `true` or `false` for backwards compatibility. `true` is equivalent to
---`"BrightAndBold"` and `false` is equivalent to `"No"`.
config.bold_brightens_ansi_colors = "No"

---Enable the scrollbar. This is currently disabled by default. It will occupy the
---right window padding space.
---
---If right padding is set to 0 then it will be increased to a single cell width.
config.enable_scroll_bar = false

---When `force_reverse_video_cursor = true`, override the `cursor_fg`, `cursor_bg`,
---`cursor_border` settings from the color scheme and force the cursor to use reverse
---video colors based on the `foreground` and `background` colors.
---
---When `force_reverse_video_cursor = false` (the default), `cursor_fg`, `cursor_bg`
---and `cursor_border` color scheme settings are applied as normal.
---
---If escape sequences are used to change the cursor color, they will take precedence
---over `force_reverse_video_cursor`. In earlier releases, setting
---`force_reverse_video_cursor = true` always ignored the configured cursor color.
config.force_reverse_video_cursor = true

---If true, the mouse cursor will be hidden when typing, if your mouse cursor is
---hovering over the window.
---
---The default is `true`. Set to `false` to disable this behavior.
config.hide_mouse_cursor_when_typing = true

---Specifies the easing function to use when computing the color for text that has
---the blinking attribute in the fading-in phase--when the text is fading from the
---background color to the foreground color.
---
---@see config.visual_bell for more information about easing functions.
---@see config.cursor_blink_rate to control the rate at which the cursor blinks.
config.text_blink_ease_in = "EaseIn"

---Specifies the easing function to use when computing the color for text that has
---the blinking attribute in the fading-out phase--when the text is fading from the
---foreground color to the background color.
---
---@see config.visual_bell
config.text_blink_ease_out = "EaseOut"

---Specifies the easing function to use when computing the color for text that has
---the rapid blinking attribute in the fading-in phase--when the text is fading from
---the background color to the foreground color.
---
---@see config.visual_bell
config.text_blink_rapid_ease_in = "Linear"

---Specifies the easing function to use when computing the color for text that has
---the rapid blinking attribute in the fading-out phase--when the text is fading from
---the foreground color to the background color.
---
---@see config.visual_bell
config.text_blink_rapid_ease_out = "Linear"

---Specifies how often blinking text (normal speed) transitions between visible and
---invisible, expressed in milliseconds. Setting this to 0 disables slow text blinking.
---Note that this value is approximate due to the way that the system event loop
---schedulers manage timers; non-zero values will be at least the interval specified
---with some degree of slop.
---
---```lua
---config.text_blink_rate = 500
---```
---
---*Since: Version 20220319-142410-0fcdea07*
---Blinking is no longer a binary blink, but interpolates between invisible and visible
---text using an easing function.
---@see config.text_blink_ease_in
---@see config.text_blink_ease_out
config.text_blink_rate = 500

---Specifies how often blinking text (rapid speed) transitions between visible and
---invisible, expressed in milliseconds. Setting this to 0 disables rapid text blinking.
---Note that this value is approximate due to the way that the system event loop
---schedulers manage timers; non-zero values will be at least the interval specified
---with some degree of slop.
---
---```lua
---config.text_blink_rate_rapid = 250
---```
---
---*Since: Version 20220319-142410-0fcdea07*
---Blinking is no longer a binary blink, but interpolates between invisible and
---visible text using an easing function.
---@see config.text_blink_rapid_ease_in
---@see config.text_blink_rapid_ease_out
config.text_blink_rate_rapid = 250

config.animation_fps = 60
config.max_fps = 60

config.color_schemes = require "colorschemes"
config.color_scheme = "kanagawa"
config.font = wz.font "FiraCode Nerd Font"

config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.webgpu_preferred_adapter = {
  backend = "Vulkan",
  device = 8081,
  device_type = "DiscreteGpu",
  driver = "NVIDIA",
  driver_info = "537.58",
  name = "NVIDIA GeForce GTX 1650 with Max-Q Design",
  vendor = 4318,
}

---@see config.char_select_fg_color
---@see config.char_select_bg_color
---@see config.char_select_font_size
---
---@see config.command_palette_fg_color
---@see config.command_palette_bg_color
---@see config.command_palette_font_size
for key, value in pairs {
  bg_color = kanagawa.ansi[6],
  fg_color = kanagawa.ansi[1],
  font_size = 12,
} do
  for _, prefix in pairs { "command_palette_", "char_select_" } do
    config[prefix .. key] = value
  end
end

return config

-- return {
--   color_schemes = colorschemes, -- load custom color schemes
--   color_scheme = "kanagawa", -- use kanagawa
--   force_reverse_video_cursor = true,
--
--   use_fancy_tab_bar = true,
--   enable_tab_bar = true,
--   hide_tab_bar_if_only_one_tab = true,
--   tab_bar_at_bottom = false,
--
--   font = wezterm.font "FiraCode Nerd Font",
--
--   enable_scroll_bar = true,
--
--   -- it's not working right now
--   -- window_background_opacity = 0,
--   -- win32_system_backdrop = "Mica",
--
--   window_decorations = "TITLE | RESIZE",
-- }

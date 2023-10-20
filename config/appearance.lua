---@class WezTerm
local wz = require "wezterm"
local colorschemes = require "colorschemes"

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

---// BACKGROUND //-----------------------------------------------------------------

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
      Color = colorschemes["kanagawa"].background,
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

---// SCROLL BAR AND CURSOR //------------------------------------------------------

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

---// TEXT APPEARANCE //------------------------------------------------------------

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

---// INACTIVE PANES //-------------------------------------------------------------

---To make it easier to see which pane is active, the inactive panes are dimmed and
---de-saturated slightly.
---
---You can specify your own transformation to the pane colors with a hue, saturation,
---brightness (HSB) multiplier.
---
---In this example, inactive panes will be slightly de-saturated and dimmed; this is
---the default configuration:
---
---```lua
---config.inactive_pane_hsb = {
---  saturation = 0.9,
---  brightness = 0.8,
---}
---```
---
---The transform works by converting the RGB colors to HSV values and then multiplying
---the HSV by the numbers specified in `inactive_pane_hsb`.
---
---Modifying the hue changes the hue of the color by rotating it through the color
---wheel. It is not as useful as the other components, but is available "for free"
---as part of the colorspace conversion.
---
---Modifying the saturation can add or reduce the amount of "colorfulness". Making the
---value smaller can make it appear more washed out.
---
---Modifying the brightness can be used to dim or increase the perceived amount of light.
---
---The range of these values is 0.0 and up; they are used to multiply the existing
---values, so the default of 1.0 preserves the existing component, whilst 0.5 will
---reduce it by half, and 2.0 will double the value.
config.inactive_pane_hsb = {
  saturation = 0.6,
  brightness = 0.45,
}

config.animation_fps = 60
config.max_fps = 60

config.color_schemes = colorschemes
config.color_scheme = "kanagawa"

---@see config.char_select_fg_color
---@see config.char_select_bg_color
---@see config.char_select_font_size
---
---@see config.command_palette_fg_color
---@see config.command_palette_bg_color
---@see config.command_palette_font_size
for key, value in pairs {
  bg_color = colorschemes["kanagawa"].ansi[6],
  fg_color = colorschemes["kanagawa"].ansi[1],
  font_size = 14,
} do
  for _, prefix in pairs { "command_palette_", "char_select_" } do
    config[prefix .. key] = value
  end
end

---// HYPERLINK RULES //------------------------------------------------------------

---Defines rules to match text from the terminal output and generate clickable links.
--
---The value is a list of rule entries. Each entry has the following fields:
---* `regex` - the regular expression to match (see supported Regex syntax)
---* `format` - Controls which parts of the regex match will be used to form the link.
---  Must have a `prefix:` signaling the protocol type (e.g., `https:`/`mailto:`), which
---  can either come from the regex match or needs to be explicitly added. The format
---  string can use placeholders like `$0`, `$1`, `$2` etc. that will be replaced with
---  that numbered capture group. So, `$0` will take the entire region of text matched
---  by the whole regex, while `$1` matches out the first capture group. In the example
---  below, `mailto:$0` is used to prefix a protocol to the text to make it into an URL.
---
---_Since: Version 20230320-124340-559cb7b0_
---* `highlight` - specifies the range of the matched text that should be
---  highlighted/underlined when the mouse hovers over the link. The value is a number
---  that corresponds to a capture group in the regex. The default is `0`,
---  highlighting the entire region of text matched by the regex. `1` would be the
---  first capture group, and so on.
---
---_Since: Version 20230408-112425-69ae8472_
---The regex syntax now supports backreferences and look around assertions. See Fancy
---Regex Syntax for the extended syntax, which builds atop the underlying Regex syntax.
---In prior versions, only the base Regex syntax was supported.
---
---Assigning `hyperlink_rules` overrides the built-in default rules.
---
---The default value for `hyperlink_rules` can be retrieved using
---`wezterm.default_hyperlink_rules()`
config.hyperlink_rules = wz.default_hyperlink_rules()

-- make task numbers clickable
-- the first matched regex group is captured in $1.
table.insert(config.hyperlink_rules, {
  regex = [[\b[tt](\d+)\b]],
  format = "https://example.com/tasks/?t=$1",
})

-- make username/project paths clickable. this implies paths like the following are
-- for github. ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim |
-- wez/wezterm | "wez/wezterm.git" ) as long as a full url hyperlink regex exists
-- above this it should not match a full url to github or gitlab / bitbucket (i.e.
-- https://gitlab.com/user/project.git is still a whole clickable url)
table.insert(config.hyperlink_rules, {
  regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
  format = "https://www.github.com/$1/$3",
})

return config
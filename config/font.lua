---@diagnostic disable: undefined-field

---@class WezTerm
local wez = require "wezterm"

---@class config
local config = {}

---Control whether changing the font size adjusts the dimensions of the window (true)
---or adjusts the number of terminal rows/columns (false). The default is true.
---
---If you use a tiling window manager then you may wish to set this to `false`.
---
---See also IncreaseFontSize, DecreaseFontSize.
---
---_Since: Version 20230712-072601-f4abf8fd_
---The default value is now `nil` which causes wezterm to match the name of the
---connected window environment (which you can see if you open the debug overlay)
---against the list of known tiling environments configured by
---tiling_desktop_environments. If the environment is known to be tiling then the
---effective value of `adjust_window_size_when_changing_font_size` is `false`, and
---`true` otherwise.
config.adjust_window_size_when_changing_font_size = false

---Configures how square symbol glyph's cell is rendered:
---
---* `"WhenFollowedBySpace"` - (this is the default) deliberately overflow the cell
---  width when the next cell is a space.
---* `"Always"` - overflow the cell regardless of the next cell being a space.
---* `"Never"` - strictly respect the cell width.
---
---_Since: Version 20210404-112810-b63a949d_
---This setting now applies to any glyph with an aspect ratio larger than 0.9, which
---covers more symbol glyphs than in earlier releases.
---
---The default value for this setting was changed from `Never` to `WhenFollowedBySpace`.
config.allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace"

---Control whether custom_block_glyphs are rendered using anti-aliasing or not.
---Anti-aliasing makes lines look smoother but may not look so nice at smaller font
---sizes.
config.anti_alias_custom_block_glyphs = true

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

---This function constructs a lua table that corresponds to the internal
---`FontAttributes` struct that is used to select a single named font:
---
---```lua
---local wezterm = require 'wezterm'
---
---return {
---  font = wezterm.font 'JetBrains Mono',
---}
---```
---
---The first parameter is the name of the font; the name can be one of the following
---types of names:
---
---* The font family name, eg: `"JetBrains Mono"`. The family name doesn't include any
---  style information (such as weight, stretch or italic), which can be specified via
---  the _attributes_ parameter. **This is the recommended name to use for the font**,
---  as it the most compatible way to resolve an installed font.
---* The computed _full name_, which is the family name with the sub-family (which
---  incorporates style information) appended, eg: `"JetBrains Mono Regular"`.
---* (Since 20210502-154244-3f7122cb) The _postscript name_, which is an ostensibly
---  unique name identifying a given font and style that is encoded into the font by
---  the font designer.
--
---When specifying a font using its family name, the second _attributes_ parameter is
---an optional table that can be used to specify style attributes; the following keys
---are allowed:
--
---* weight` - specifies the weight of the font. The default value is `"Regular"`,
---  and possible values are:
---  - `"Thin"`
---  - `"ExtraLight"`
---  - `"Light"`
---  - `"DemiLight"`
---  - `"Book"`
---  - `"Regular"`
---  - `"Medium"`
---  - `"DemiBold"`
---  - `"Bold"`
---  - `"ExtraBold"`
---  - `"Black"`
---  - `"ExtraBlack"`.
---  `weight` has been supported since version 20210502-130208-bff6815d, In earlier
---  versions you could use `bold=true` to get a bold font variant.
---* `stretch` - specifies the font stretch to select. The default value is `"Normal"`,
---  and possible values are:
---  * `"UltraCondensed"`
---  * `"ExtraCondensed"`
---  * `"Condensed"`
---  * `"SemiCondensed"`
---  * `"Normal"`
---  * `"SemiExpanded"`
---  * `"Expanded"`
---  * `"ExtraExpanded"`
---  * `"UltraExpanded"`.
---  `stretch` has been supported since version 20210502-130208-bff6815d.
---* `style` - specifies the font style to select. The default is `"Normal"`, and
---  possible values are:
---  * `"Normal"`
---  * `"Italic"`
---  * `"Oblique"`
---  `"Oblique"` and `"Italic"` fonts are similar in the sense that the glyphs are
---  presented at an angle. `"Italic"` fonts usually have a distinctive design
---  difference from the `"Normal"` style in a given font family, whereas `"Oblique"`
---  usually looks very similar to `"Normal"`, but skewed at an angle.
---
---  `style` has been supported since version 20220319-142410-0fcdea07. In earlier
---  versions you could use `italic=true` to get an italic font variant.
---
---When attributes are specified, the font must match both the family name and
---attributes in order to be selected.
---
---With the exception of being able to synthesize basic bold and italics (really,
---oblique) for non-bitmap fonts, wezterm can only select and use fonts that you have
---installed on your system. The attributes that you specify are used to match a font
---from those that are available, so if you'd like to use a condensed font, for
---example, then you must install the condensed variant of that family.
---
---```lua
---local wezterm = require 'wezterm'
---
---return {
---  font = wezterm.font('JetBrains Mono', { weight = 'Bold' }),
---}
---```
---
---When resolving fonts from `font_dirs`, wezterm follows CSS Fonts Level 3 compatible
---font matching, which tries to exactly match the specified attributes, but allows
---for locating a close match within the specified font family.
---
---```lua
---local wezterm = require 'wezterm'
---
---return {
---  font = wezterm.font(
---    'Iosevka Term',
---    { stretch = 'Expanded', weight = 'Regular' }
---  ),
---}
---```
---
---An alternative form of specifying the font can be used, where the family and the
---attributes are combined in the same lua table. This form is most useful when used
---together with `wezterm.font\_with\_fallback` when you want to specify precise
---weights for the different fallback fonts:
---
---```lua
---local wezterm = require 'wezterm'
---
---return {
---  font = wezterm.font {
---    family = 'Iosevka Term',
---    stretch = 'Expanded',
---    weight = 'Regular',
---  },
---}
---```
---
---_Since: Version 20220101-133340-7edc5b5a_
---You can use the expanded form mentioned above to override freetype and harfbuzz
---settings just for the specified font; this examples shows how to disable the default
---ligature feature just for this particular font:
---
---```lua
---local wezterm = require 'wezterm'
---return {
---  font = wezterm.font {
---    family = 'JetBrains Mono',
---    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
---  },
---}
---```
---
---The following options can be specified in the same way:
---
---* `harfbuzz_features`
---* `freetype_load_target`
---* `freetype_render_target`
---* `freetype_load_flags`
---* `assume_emoji_presentation = true` or `assume_emoji_presentation = false` to
---  control whether a font is considered to have emoji (rather than text)
---  presentation glyphs for emoji. (_Since: Version 20220807-113146-c2fee766_)
config.font = wez.font_with_fallback {
  {
    family = "FiraCode Nerd Font",
    weight = "Regular",
    harfbuzz_features = {
      -- "cv01", ---styles: a
      -- "cv02", ---styles: g
      "cv06", ---styles: i (03..06)
      -- "cv09", ---styles: l (07..10)
      "cv12", ---styles: 0 (11..13, zero)
      "cv14", ---styles: 3
      "cv16", ---styles: * (15..16)
      -- "cv17", ---styles: ~
      -- "cv18", ---styles: %
      -- "cv19", ---styles: <= (19..20)
      -- "cv21", ---styles: =< (21..22)
      -- "cv23", ---styles: >=
      -- "cv24", ---styles: /=
      "cv25", ---styles: .-
      "cv26", ---styles: :-
      -- "cv27", ---styles: []
      "cv28", ---styles: {. .}
      -- "cv29", ---styles: { }
      -- "cv30", ---styles: |
      -- "cv31", ---styles: ()
      "cv32", ---styles: .=
      -- "ss01", ---styles: r
      -- "ss02", ---styles: <= >=
      "ss03", ---styles: &
      "ss04", ---styles: $
      "ss05", ---styles: @
      -- "ss06", ---styles: \\
      "ss07", ---styles: =~ !~
      -- "ss08", ---styles: == === != !==
      "ss09", ---styles: >>= <<= ||= |=
      -- "ss10", ---styles: Fl Tl fi fj fl ft
      -- "onum", ---styles: 1234567890
    },
  },
  { family = "Noto Color Emoji" },
  { family = "LegacyComputing" },
}

---Specifies the size of the font, measured in points.
---
---You may use fractional point sizes, such as `13.3`, to fine tune the size.
---
---The default font size is `12.0` points. In earlier versions prior to
---20210314-114017-04b7cedd it was `10.0`.
config.font_size = 9.5

---If specified, overrides the position of strikethrough lines.
---
---The default is derived from the underline position metric specified by the
---designer of the primary font.
---
---This config option accepts different units that have slightly different interpretations:
---* `2`, `2.0` or `"2px"` all specify a position of 2 pixels
---* `"2pt"` specifies a position of 2 points, which scales according to the DPI of
---  the window
---* `"200%"` takes the font-specified `underline_position` and multiplies it by 2
---* `"0.5cell"` takes the cell height, scales it by `0.5` and uses that as the
---  position
-- config.strikethrough_position = ""

---If specified, overrides the position of underlines.
---
---The default is to use the underline position metric specified by the designer of
---the primary font.
---
---This config option accepts different units that have slightly different interpretations:
---* `2`, `2.0` or `"2px"` all specify a position of 2 pixels
---* `"2pt"` specifies a position of 2 points, which scales according to the DPI of
---  the window
---* `"200%"` takes the font-specified `underline_position` and multiplies it by 2
---* `"0.1cell"` takes the cell height, scales it by `0.1` and uses that as the
---  position
---
---Note that the `underline_position` is often a small negative number like `-2` or `-4`
---and specifies an offset from the baseline of the font.
-- if wez.gui.screens().active.name == "DISPLAY1:  on Intel(R) UHD Graphics 610" then
config.underline_position = -3.5
-- else
-- config.underline_position = -2.2
-- end

---If specified, overrides the base thickness of underlines. The underline thickness
---is also used for rendering split pane dividers and a number of other lines in custom
---glyphs.
---
---The default is to use the underline thickness metric specified by the designer of
---the primary font.
---
---This config option accepts different units that have slightly different interpretations:
---
---* `2`, `2.0` or `"2px"` all specify a thickness of 2 pixels
---* `"2pt"` specifies a thickness of 2 points, which scales according to the DPI of
---  the window
---* `"200%"` takes the font-specified `underline_thickness` and multiplies it by 2 to
---  arrive at a thickness double the normal size
---* `"0.1cell"` takes the cell height, scales it by `0.1` and uses that as the thickness
config.underline_thickness = "2px"

---An advanced option to fine tune the freetype rasterizer. This is a bitfield, so
---you can combine one or more of these options together, separated by the `|` character,
---although not many of the available options necessarily make sense to be combined.
---
---Available flags are:
---
---* `DEFAULT` - This is the default!
---* `NO_HINTING` - Disable hinting. This generally generates ‘blurrier’ bitmap glyph
---   when the glyph is rendered in any of the anti-aliased modes.
---* `NO_BITMAP` - don't load any pre-rendered bitmap strikes
---* `FORCE_AUTOHINT` - Use the freetype auto-hinter rather than the font's native
---   hinter.
---* `MONOCHROME` - instructs renderer to use 1-bit monochrome rendering. This option
---   doesn't impact the hinter.
---* `NO_AUTOHINT` - don't use the freetype auto-hinter
---
---```lua
----- You probably don't want to do this, but this demonstrates
----- that the flags can be combined
---config.freetype_load_flags = 'NO_HINTING|MONOCHROME'
---```
-- config.freetype_load_flags = "NO_HINTING|NO_BITMAP"
config.freetype_load_flags = "NO_HINTING"

---Selects the freetype interpret version to use. Possible values are `35`, `38` and
---`40` which have different characteristics with respective to subpixel hinting.
---See <https://freetype.org/freetype2/docs/hinting/subpixel-hinting.html>
config.freetype_interpreter_version = 38

---Configures the _rendering_ mode used with the freetype rasterizer.
---
---The default is to use the value of `freetype_load_target`.
---
---You may wish to override that value if you want very fine control over how freetype
---hints and then renders glyphs.
---
---For example, this configuration uses light hinting but produces subpixel-antialiased
---glyph bitmaps:
---
---```lua
---config.freetype_load_target = 'Light'
---config.freetype_render_target = 'HorizontalLcd'
---```
config.freetype_render_target = "Normal"

---The harfbuzz features to use for the Monaspace font family
local monaspace_features =
  { "dlig", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" }

---When textual output in the terminal is styled with bold, italic or other attributes,
---wezterm uses `font_rules` to decide how to render that text.
---
---By default, unstyled text will use the font specified by the font configuration,
---and wezterm will use that as a base, and then automatically generate appropriate
---`font_rules` that use heavier weight fonts for bold text, lighter weight fonts for
---dim text and italic fonts for italic text.
---
---Most users won't need to specify any explicit value for `font_rules`, as the
---defaults should be sufficient.
---
---If you have some unusual fonts or mixtures of fonts that you'd like to use, such
---as using your favourite monospace font for the base and a fancy italic font from a
---different font family for italics, then `font_rules` will allow you to do so.
---
---`font_rules` is comprised of a list of rule entries with fields that are split into
---_matcher_ fields and _action_ fields. Matcher fields specify which textual attributes
---you want to match on, while action fields specify how you want to render them.
---
---The following fields are matcher fields:
---
---- <Name> (<Associated Attribute>): <Possible Values>;
---- **italic** (_italic_): `true` (italic) or `false` (not italic);
---- **intensity** (_bold/bright or dim/half-bright_): `"Normal"` (neither bold nor dim), `"Bold"`, `"Half"`;
---- **underline** (_underline_): `"None"` (not underlined), `"Single"` (single underline), `"Double"` (double underline);
---- **blink** (_blinking_): `"None"` (not blinking), `"Rapid"` (regular rapid blinking), `"Slow"` (slow blinking);
---- **reverse** (_reverse/inverse_): `true` (reversed) or `false` (not reversed);
---- **strikethrough** (_strikethrough_): `true` (struck-through) or `false` (not struck-through);
---- **invisible** (_invisible_): `true` (invisible) or `false` (not invisible);
---
---If a matcher field is omitted, then the associated attribute has no impact on the
---match: the rule _doesn't care about_ that attribute and will match based on the
---attributes that were listed.
---
---The following fields are action fields:
---
---| Name | Action                               |
---| ---- | ------------------------------------ |
---| font | Specify the font that should be used |
---
---The way that `font_rules` are processed is:
---
---1. Take the list of `font_rules` from your configuration
---2. For each rule in the order listed in `font_rules`:
---3. Consider each _matcher_ field explicitly specified in the entry. If the
---   associated attribute does not match the value specified in the entry, move on
---   to the next rule.
---4. If all of the _matcher_ fields explicitly specified in the entry match the
---   attributes of the text, then:
---5. The `font` _action_ field, if specified, will override the base `font` configuration
---6. No further `font_rules` will be considered: the matching is complete
---7. If none of the rules you specify matched, then a set of default rules based on your base `font` will be used in the same way as above.
---
---Here's an example from my configuration file, which I use with a variant of
---`Operator Mono` that is patched to add ligatures. This particular font has font-weights
---that are either too bold or too light for the default rules to produce great results,
---hence this set of rules.
---
---```lua
---config.font = wezterm.font_with_fallback 'Operator Mono SSm Lig Medium'
---config.font_rules = {
---  -- For Bold-but-not-italic text, use this relatively bold font, and override
---  -- its color to a tomato-red color to make bold text really stand out.
---  {
---    intensity = 'Bold',
---    italic = false,
---    font = wezterm.font_with_fallback(
---      'Operator Mono SSm Lig',
---      -- Override the color specified by the terminal output and force
---      -- it to be tomato-red.
---      -- The color value you set here can be any CSS color name or
---      -- RGB color string.
---      { foreground = 'tomato' }
---    ),
---  },
---
---  -- Bold-and-italic
---  {
---    intensity = 'Bold',
---    italic = true,
---    font = wezterm.font_with_fallback {
---      family = 'Operator Mono SSm Lig',
---      italic = true,
---    },
---  },
---
---  -- normal-intensity-and-italic
---  {
---    intensity = 'Normal',
---    italic = true,
---    font = wezterm.font_with_fallback {
---      family = 'Operator Mono SSm Lig',
---      weight = 'DemiLight',
---      italic = true,
---    },
---  },
---
---  -- half-intensity-and-italic (half-bright or dim); use a lighter weight font
---  {
---    intensity = 'Half',
---    italic = true,
---    font = wezterm.font_with_fallback {
---      family = 'Operator Mono SSm Lig',
---      weight = 'Light',
---      italic = true,
---    },
---  },
---
---  -- half-intensity-and-not-italic
---  {
---    intensity = 'Half',
---    italic = false,
---    font = wezterm.font_with_fallback {
---      family = 'Operator Mono SSm Lig',
---      weight = 'Light',
---    },
---  },
---}
---
---```
---
---Here's another example combining `FiraCode` with `Victor Mono`, using `Victor Mono`
---only for italics:
---
---```lua
---config.font = wezterm.font { family = 'FiraCode' }
---
---config.font_rules = {
---  {
---    intensity = 'Bold',
---    italic = true,
---    font = wezterm.font {
---      family = 'VictorMono',
---      weight = 'Bold',
---      style = 'Italic',
---    },
---  },
---  {
---    italic = true,
---    intensity = 'Half',
---    font = wezterm.font {
---      family = 'VictorMono',
---      weight = 'DemiBold',
---      style = 'Italic',
---    },
---  },
---  {
---    italic = true,
---    intensity = 'Normal',
---    font = wezterm.font {
---      family = 'VictorMono',
---      style = 'Italic',
---    },
---  },
---}
---```
config.font_rules = {
  {
    intensity = "Normal",
    italic = true,
    font = wez.font {
      family = "Monaspace Radon Var",
      style = "Normal",
      weight = "Regular",
      stretch = "Expanded",
      harfbuzz_features = monaspace_features,
    },
  },
  {
    intensity = "Bold",
    italic = true,
    font = wez.font {
      family = "Monaspace Krypton Var",
      style = "Italic",
      -- stretch = "Expanded",
      weight = "Black",
      harfbuzz_features = monaspace_features,
    },
  },
}

return config


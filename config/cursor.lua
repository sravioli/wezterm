---@class config
local config = {}

---Specifies the easing function to use when computing the color for the text cursor
---when it is set to a blinking style.
---
---See visual_bell for more information about easing functions.
---
---The following easing functions are supported:
---* `Linear` - the fade happens at a constant rate.
---* `Ease` - The fade starts slowly, accelerates sharply, and then slows gradually
---  towards the end. This is the default.
---* `EaseIn` - The fade starts slowly, and then progressively speeds up until the end,
---  at which point it stops abruptly.
---* `EaseInOut` - The fade starts slowly, speeds up, and then slows down towards the
---  end.
---* `EaseOut` - The fade starts abruptly, and then progressively slows down towards
---  the end.
---* `{CubicBezier={0.0, 0.0, 0.58, 1.0}}` - an arbitrary cubic bezier with the specified
---  parameters.
---* `Constant` - Evaluates as 0 regardless of time. Useful to implement a step transition
---  at the end of the duration. (Since: Version 20220408-101518-b908e2dd)
config.cursor_blink_ease_in = "EaseIn"

---@see config.cursor_blink_ease_in
config.cursor_blink_ease_out = "EaseOut"

---Specifies how often a blinking cursor transitions between visible and invisible,
---expressed in milliseconds. Setting this to 0 disables blinking.
---
---Note that this value is approximate due to the way that the system event loop
---schedulers manage timers; non-zero values will be at least the interval specified
---with some degree of slop.
---
---It is recommended to avoid blinking cursors when on battery power, as it is relatively
---costly to keep re-rendering for the blink!
config.cursor_blink_rate = 450

---Specifies the default cursor style. Various escape sequences can override the default
---style in different situations (eg: an editor can change it depending on the mode),
---but this value controls how the cursor appears when it is reset to default. The
---default is `SteadyBlock`.
---
---Acceptable values are
---* `SteadyBlock`,
---* `BlinkingBlock`,
---* `SteadyUnderline`,
---* `BlinkingUnderline`,
---* `SteadyBar`,
---* `BlinkingBar`.
config.default_cursor_style = "BlinkingUnderline"

---If specified, overrides the base thickness of the lines used to render the textual
---cursor glyph.
---
---The default is to use the underline_thickness.
---
---This config option accepts different units that have slightly different interpretations:
---
---* `2`, `2.0` or `"2px"` all specify a thickness of 2 pixels
---* `"2pt"` specifies a thickness of 2 points, which scales according to the DPI of
---  the window
---* `"200%"` takes the `underline_thickness` and multiplies it by 2 to arrive at a
---  thickness double the normal size
---* `"0.1cell"` takes the cell height, scales it by `0.1` and uses that as the thickness
config.cursor_thickness = "0.9px"

return config


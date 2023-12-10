---@class config
local config = {}

---When the BEL ascii sequence is sent to a pane, the bell is "rung" in that pane.
---
---You may choose to configure the `audible_bell` option to change the sound that
---wezterm makes when the bell rings.
---
---The follow are possible values:
---
---* `"SystemBeep"` - perform the system beep or alert sound. This is the default.
---  On Wayland systems, which have no system beep function, it does not produce a sound.
---* `"Disabled"` - don't make a sound
---
---@see config.visual_bell
config.audible_bell = "Disabled"

---When the BEL ascii sequence is sent to a pane, the bell is "rung" in that pane.
---
---You may choose to configure the `visual_bell` option so show a visible representation
---of the bell event, by having the background color of the pane briefly change color.
---
---There are four fields to the visual_bell config option:
---
---* `fade_in_duration_ms` - how long it should take for the bell color to fade in,
---  in milliseconds. The default is 0.
---* `fade_out_duration_ms` - how long it should take for the bell color to fade out,
---  in milliseconds. The default is 0.
---* `fade_in_function` - an easing function, similar to CSS easing functions, that
---  affects how the bell color is faded in.
---* `fade_out_function` - an easing function that affects how the bell color is
---  faded out.
---* `target` - can be `"BackgroundColor"` (the default) to have the background color
---  of the terminal change when the bell is rung, or `"CursorColor"` to have the
---  cursor color change when the bell is rung.
---
---If the total fade in and out durations are 0, then there will be no visual bell
---indication.
---
---The bell color is itself specified in your color settings; if not specified, the
---text foreground color will be used.
---
---The following easing functions are supported:
---
---* `Linear` - the fade happens at a constant rate.
---* `Ease` - The fade starts slowly, accelerates sharply, and then slows gradually
---  towards the end. This is the default.
---* `EaseIn` - The fade starts slowly, and then progressively speeds up until the
---  end, at which point it stops abruptly.
---* `EaseInOut` - The fade starts slowly, speeds up, and then slows down towards
---  the end.
---* `EaseOut` - The fade starts abruptly, and then progressively slows down towards
---  the end.
---* `{CubicBezier={0.0, 0.0, 0.58, 1.0}}` - an arbitrary cubic bezier with the
---  specified parameters.
---* `Constant` - Evaluates as 0 regardless of time. Useful to implement a step
---  transition at the end of the duration. (_Since: Version 20220408-101518-b908e2dd_)
---
---The following configuration enables a low intensity visual bell that takes a total
---of 300ms to "flash" the screen:
---
---```lua
---config.visual_bell = {
---  fade_in_function = 'EaseIn',
---  fade_in_duration_ms = 150,
---  fade_out_function = 'EaseOut',
---  fade_out_duration_ms = 150,
---}
---config.colors = {
---  visual_bell = '#202020',
---}
---```
---
---The follow configuration make the cursor briefly flare when the bell is run:
---
---```lua
---config.visual_bell = {
---  fade_in_duration_ms = 75,
---  fade_out_duration_ms = 75,
---  target = 'CursorColor',
---}
---```
---
---See also audible_bell and bell event.
---@see config.audible_bell
config.visual_bell = {
  fade_in_function = "EaseOut",
  fade_in_duration_ms = 200,
  fade_out_function = "EaseIn",
  fade_out_duration_ms = 200,
}
config.colors = {
  visual_bell = "black",
}

return config


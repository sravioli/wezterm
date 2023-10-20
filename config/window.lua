---@class config
local config = {}

---Configures whether the window has a title bar and/or resizable border.
---
---The value is a set of of flags:
---* `window_decorations = "NONE"` - disables titlebar and border (borderless mode),
---  but causes problems with resizing and minimizing the window, so you probably want
---  to use `RESIZE` instead of `NONE` if you just want to remove the title bar.
---* `window_decorations = "TITLE"` - disable the resizable border and enable only
---  the title bar
---* `window_decorations = "RESIZE"` - disable the title bar but enable the resizable
---  border
---* `window_decorations = "TITLE | RESIZE"` - Enable titlebar and border. This is the
---  default.
---
---> _Since: Version 20230408-112425-69ae8472_
--->
---> * `window_decorations = "INTEGRATED_BUTTONS|RESIZE"` - place window management
---> buttons (minimize, maximize, close) into the tab bar instead of showing a title bar.
--->
---
---On X11 and Wayland, the windowing system may override the window decorations.
---
---When the titlebar is disabled you can drag the window using the tab bar if it is
---enabled, or by holding down `SUPER` and dragging the window (on Windows: CTRL-SHIFT
---and drag the window). You can map this dragging function for yourself via the
---StartWindowDrag key assignment. Note that if the pane is running an application
---that has enabled mouse reporting you will need to hold down the `SHIFT` modifier
---in order for `StartWindowDrag` to be recognized.
---
---When the resizable border is disabled you will need to use features of your desktop
---environment to resize the window. Windows users may wish to consider AltSnap.
---@see config.integrated_title_button_style
---@see config.integrated_title_buttons
---@see config.integrated_title_button_alignment
---@see config.integrated_title_button_color
---@see config.tab_bar_style If you are using the retro rab style
config.window_decorations = "TITLE | RESIZE"

---Configures the color of the set of window management buttons when
---`window_decorations = "INTEGRATED_BUTTONS|RESIZE"`.
---
---Possible values are:
---* `config.integrated_title_button_color = "Auto"` - automatically compute the color
---* `config.integrated_title_button_color = "red"` - Use a custom color
config.integrated_title_button_color = "Auto"

---Configures the alignment of the set of window management buttons when
---`window_decorations = "INTEGRATED_BUTTONS|RESIZE"`.
---
---Possible values are:
---* `"Left"` - the buttons are shown on the left side of the tab bar
---* `"Right"` - the buttons are shown on the right side of the tab bar
config.integrated_title_button_alignment = "Right"

---Configures the visual style of the tabbar-integrated titlebar button replacements
---that are shown when `window_decorations = "INTEGRATED_BUTTONS|RESIZE"`.
---
---Possible styles are:
---* `"Windows"` - draw Windows-style buttons
---* `"Gnome"` - draw Adwaita-style buttons
---* `"MacOsNative"` - on macOS only, move the native macOS buttons into the tab bar.
---
---The default value is `"MacOsNative"` on macOS systems, but `"Windows"` on other
---systems.
config.integrated_title_button_style = "Windows"

---Configures the ordering and set of window management buttons to show when
---`window_decorations = "INTEGRATED_BUTTONS|RESIZE"`.
---
---The value is a table listing the buttons. Each element can have one of the
---following values:
---
---* `"Hide"` - the window hide or minimize button
---* `"Maximize"` - the window maximize button
---* `"Close"` - the window close button
---
---The default value is equivalent to:
---
---```lua
---config.integrated_title_buttons = { 'Hide', 'Maximize', 'Close' }
---```
---
---You can change the order by listing them in a different order:
---
---```lua
---config.integrated_title_buttons = { 'Close', 'Maximize', 'Hide' }
---```
---
---or remove buttons you don't want:
---
---```lua
---config.integrated_title_buttons = { 'Close' }
---```
config.integrated_title_buttons = { "Hide", "Maximize", "Close" }

---// WIN32 ACRYLIC // -------------------------------------------------------------

---!! SET BACKGROUND TO BLACK IN `config.background`!!
---When combined with `window_background_opacity`, chooses from available window
---background effects provided by Windows.
---
---The possible values for `win32_system_backdrop` are:
---
---* `"Auto"` - the system chooses. In practice, this is the same as `"Disable"`. This
---  is the default value.
---* `"Disable"` - disable backdrop effects.
---* `"Acrylic"` - enable the _Acrylic_ blur-behind-window effect. Available on Windows
---  10 and 11.
---* `"Mica"` - enable the _Mica_ effect, available on Windows 11 build 22621 and later.
---* `"Tabbed"` - enable the _Tabbed_ effect, available on Windows 11 build 22621 and
---  later.
---
---On Windows systems earlier than build 22621, the _Acrylic_ affect can be adjusted
---using `config.win32_acrylic_accent_color`. More recent versions of Windows do not
---permit configuring the accent color for _Acrylic_, so that option has no effect
---there.
---
---The _Acrylic_ setting uses more resources than the others.
---
---You need to reduce the `window_background_opacity` to a value lower than `1.0` for
---the backdrop effect to work. For best results with both `"Mica"` and `"Tabbed"`,
---setting `window_background_opacity = 0` is recommended.
---
---See also macos_window_background_blur for a similar effect on macOS.
---
---**Acrylic**
---
---```lua
---config.window_background_opacity = 0
---config.win32_system_backdrop = 'Acrylic'
---```
---
---**Mica**
---
---```lua
---config.window_background_opacity = 0
---config.win32_system_backdrop = 'Mica'
---```
---
---**Tabbed**
---
---```lua
---config.window_background_opacity = 0
---config.win32_system_backdrop = 'Tabbed'
---```
config.win32_system_backdrop = "Acrylic"
-- config.win32_system_backdrop = "Mica" -- NOT WORKING RIGHT NOW
-- config.win32_system_backdrop = "Tabbed" -- NOT WORKING RIGHT NOW

---Controls the amount of padding between the window border and the terminal cells.
---
---Padding is measured in pixels.
---
---If `enable_scroll_bar` is `true`, then the value you set for `right` will control
---the width of the scrollbar. If you have enabled the scrollbar and have set `right`
---to `0` then the right padding (and thus the scrollbar width) will instead match the
---width of a cell.
---
---```lua
---config.window_padding = {
---  left = 2,
---  right = 2,
---  top = 0,
---  bottom = 0,
---}
---```
---
---_Since: Version 20211204-082213-a66c61ee9_
---You may now express padding using a number of different units by specifying a
---string value with a unit suffix:
---
---* `"1px"` - the `px` suffix indicates pixels, so this represents a `1` pixel value
---* `"1pt"` - the `pt` suffix indicates points. There are `72` points in `1 inch`.
---  The actual size this occupies on screen depends on the dpi of the display device.
---* `"1cell"` - the `cell` suffix indicates the size of the terminal cell, which in
---  turn depends on the font size, font scaling and dpi. When used for width, the
---  width of the cell is used. When used for height, the height of the cell is used.
---* `"1%"` - the `%` suffix indicates the size of the terminal portion of the display,
---  which is computed based on the number of rows/columns and the size of the cell.
---  While it is possible to specify percentage, there are some resize scenarios where
---  the percentage value may not be 100% stable/deterministic, as the size of the
---  padding is used to compute the number of rows/columns.
---
---You may use a fractional number such as `"0.5cell"` or numbers large than one such
---as `"72pt"`.
---
---The default padding is shown below. In earlier releases, the default padding was 0
---for each of the possible edges.
---
---```lua
---config.window_padding = {
---  left = '1cell',
---  right = '1cell',
---  top = '0.5cell',
---  bottom = '0.5cell',
---}
---```
config.window_padding = {
  left = 5,
  right = 5,
  top = 10,
  bottom = 5,
}

return config

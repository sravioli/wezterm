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
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"

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

---// TAB BAR //--------------------------------------------------------------------

---Controls whether the tab bar is enabled. Set to false to disable it.
---@see config.hide_tab_bar_if_only_one_tab
config.enable_tab_bar = true

---When set to `true` (the default), the tab bar is rendered in a native style with
---proportional fonts.
---
---When set to `false`, the tab bar is rendered using a retro aesthetic using the main
---terminal font.
config.use_fancy_tab_bar = true

---If set to true, when there is only a single tab, the tab bar is hidden from the
---display. If a second tab is created, the tab will be shown.
---@see config.enable_tab_bar
config.hide_tab_bar_if_only_one_tab = false

---If set to true, when the active tab is closed, the previously activated tab will
---be activated.
---
---Otherwise, the tab to the left of the active tab will be activated.
config.switch_to_last_active_tab_when_closing_tab = true

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

return config

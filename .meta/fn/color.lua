---@meta fn.Color
error "cannot require a meta file!"

-- luacheck: push ignore 631 (line is too long)

---Wrapper for color definitions using specific formats.
---@class Fn.Color.Theme.ColorSpec
---@field public Color?     string Hex color code (e.g., "#ffffff").
---@field public AnsiColor? string ANSI color name (e.g., "Black").

---Style definition for tab bar elements.
---@class Fn.Color.Theme.TabState
---@field public bg_color       string  Background color.
---@field public fg_color       string  Foreground color.
---@field public intensity?     string  Font intensity (e.g., "Bold").
---@field public italic?        boolean Enable italic font.
---@field public strikethrough? boolean Enable strikethrough.
---@field public underline?     string  Underline style.

---Tab bar specific styling configurations.
---@class Fn.Color.Theme.TabBar
---@field public background         string                  Background color for tab bar.
---@field public inactive_tab_edge  string                  Color of the edge between inactive tabs.
---@field public active_tab         Fn.Color.Theme.TabState Style for the currently active tab.
---@field public inactive_tab       Fn.Color.Theme.TabState Style for inactive tabs.
---@field public inactive_tab_hover Fn.Color.Theme.TabState Style for hovered inactive tabs.
---@field public new_tab            Fn.Color.Theme.TabState Style for the new tab button.
---@field public new_tab_hover      Fn.Color.Theme.TabState Style for the hovered new tab button.

---Complete WezTerm color scheme definition.
---@class Fn.Color.Theme
---@field public background                      string                   Main background color.
---@field public foreground                      string                   Main foreground color.
---@field public cursor_bg                       string                   Cursor background color.
---@field public cursor_fg                       string                   Cursor foreground color.
---@field public cursor_border                   string                   Cursor border color.
---@field public selection_fg                    string                   Selection text color.
---@field public selection_bg                    string                   Selection background color.
---@field public scrollbar_thumb                 string                   Scrollbar thumb color.
---@field public split                           string                   Split divider color.
---@field public ansi                            string[]                 List of standard ANSI colors (0-7).
---@field public brights                         string[]                 List of bright ANSI colors (8-15).
---@field public indexed                         table<number, string>    Map of arbitrary indexed colors (e.g., 16, 17).
---@field public compose_cursor                  string                   Cursor color when composing text.
---@field public visual_bell                     string                   Visual bell color.
---@field public copy_mode_active_highlight_bg   Fn.Color.Theme.ColorSpec Background for active match in copy mode.
---@field public copy_mode_active_highlight_fg   Fn.Color.Theme.ColorSpec Foreground for active match in copy mode.
---@field public copy_mode_inactive_highlight_bg Fn.Color.Theme.ColorSpec Background for inactive matches in copy mode.
---@field public copy_mode_inactive_highlight_fg Fn.Color.Theme.ColorSpec Foreground for inactive matches in copy mode.
---@field public quick_select_label_bg           Fn.Color.Theme.ColorSpec Background for quick select labels.
---@field public quick_select_label_fg           Fn.Color.Theme.ColorSpec Foreground for quick select labels.
---@field public quick_select_match_bg           Fn.Color.Theme.ColorSpec Background for quick select matches.
---@field public quick_select_match_fg           Fn.Color.Theme.ColorSpec Foreground for quick select matches.
---@field public input_selector_label_bg         Fn.Color.Theme.ColorSpec Background for input selector labels.
---@field public input_selector_label_fg         Fn.Color.Theme.ColorSpec Foreground for input selector labels.
---@field public launcher_label_bg               Fn.Color.Theme.ColorSpec Background for launcher labels.
---@field public launcher_label_fg               Fn.Color.Theme.ColorSpec Foreground for launcher labels.
---@field public tab_bar                         Fn.Color.Theme.TabBar    Tab bar configuration.

---@class Fn.Color
---@field public log Logger

-- luacheck: pop

---@meta fn.Color
error "cannot require a meta file!"

-- luacheck: push ignore 631 (line is too long)

---Wrapper for color definitions using specific formats.
---@class Fn.Color.Theme.ColorSpec
---@field Color?     string Hex color code (e.g., "#ffffff").
---@field AnsiColor? string ANSI color name (e.g., "Black").

---Style definition for tab bar elements.
---@class Fn.Color.Theme.TabState
---@field bg_color       string  Background color.
---@field fg_color       string  Foreground color.
---@field intensity?     string  Font intensity (e.g., "Bold").
---@field italic?        boolean Enable italic font.
---@field strikethrough? boolean Enable strikethrough.
---@field underline?     string  Underline style.

---Tab bar specific styling configurations.
---@class Fn.Color.Theme.TabBar
---@field background         string                  Background color for tab bar.
---@field inactive_tab_edge  string                  Color of the edge between inactive tabs.
---@field active_tab         Fn.Color.Theme.TabState Style for the currently active tab.
---@field inactive_tab       Fn.Color.Theme.TabState Style for inactive tabs.
---@field inactive_tab_hover Fn.Color.Theme.TabState Style for hovered inactive tabs.
---@field new_tab            Fn.Color.Theme.TabState Style for the new tab button.
---@field new_tab_hover      Fn.Color.Theme.TabState Style for the hovered new tab button.

---Complete WezTerm color scheme definition.
---@class Fn.Color.Theme
---@field background                      string                   Main background color.
---@field foreground                      string                   Main foreground color.
---@field cursor_bg                       string                   Cursor background color.
---@field cursor_fg                       string                   Cursor foreground color.
---@field cursor_border                   string                   Cursor border color.
---@field selection_fg                    string                   Selection text color.
---@field selection_bg                    string                   Selection background color.
---@field scrollbar_thumb                 string                   Scrollbar thumb color.
---@field split                           string                   Split divider color.
---@field ansi                            string[]                 List of standard ANSI colors (0-7).
---@field brights                         string[]                 List of bright ANSI colors (8-15).
---@field indexed                         table<number, string>    Map of arbitrary indexed colors (e.g., 16, 17).
---@field compose_cursor                  string                   Cursor color when composing text.
---@field visual_bell                     string                   Visual bell color.
---@field copy_mode_active_highlight_bg   Fn.Color.Theme.ColorSpec Background for active match in copy mode.
---@field copy_mode_active_highlight_fg   Fn.Color.Theme.ColorSpec Foreground for active match in copy mode.
---@field copy_mode_inactive_highlight_bg Fn.Color.Theme.ColorSpec Background for inactive matches in copy mode.
---@field copy_mode_inactive_highlight_fg Fn.Color.Theme.ColorSpec Foreground for inactive matches in copy mode.
---@field quick_select_label_bg           Fn.Color.Theme.ColorSpec Background for quick select labels.
---@field quick_select_label_fg           Fn.Color.Theme.ColorSpec Foreground for quick select labels.
---@field quick_select_match_bg           Fn.Color.Theme.ColorSpec Background for quick select matches.
---@field quick_select_match_fg           Fn.Color.Theme.ColorSpec Foreground for quick select matches.
---@field input_selector_label_bg         Fn.Color.Theme.ColorSpec Background for input selector labels.
---@field input_selector_label_fg         Fn.Color.Theme.ColorSpec Foreground for input selector labels.
---@field launcher_label_bg               Fn.Color.Theme.ColorSpec Background for launcher labels.
---@field launcher_label_fg               Fn.Color.Theme.ColorSpec Foreground for launcher labels.
---@field tab_bar                         Fn.Color.Theme.TabBar    Tab bar configuration.

-- luacheck: pop

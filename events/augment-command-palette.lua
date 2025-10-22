---@module "events.augment-command-palette"
---@author sravioli
---@license GNU-GPLv3

---@diagnostic disable: undefined-field
local wt = require "wezterm"
local act = wt.action
local balance = require "utils.balance-panes"

wt.on("augment-command-palette", function(_, _)
  return {
    {
      brief = "Rename tab",
      icon = "md_rename_box",

      action = act.PromptInputLine {
        description = "Enter new name for tab",
        action = wt.action_callback(function(inner_window, _, line)
          if line then
            inner_window:active_tab():set_title(line)
          end
        end),
      },
    },
    {
      brief = "Colorscheme picker",
      icon = "md_palette",
      action = require("picker.colorscheme"):pick(),
    },
    {
      brief = "Font picker",
      icon = "md_format_font",
      action = require("picker.font"):pick(),
    },
    {
      brief = "Font size picker",
      icon = "md_format_font_size_decrease",
      action = require("picker.font-size"):pick(),
    },
    {
      brief = "Font leading picker",
      icon = "fa_text_height",
      action = require("picker.font-leading"):pick(),
    },
    {
      brief = "Balance panes horizontally",
      icon = "md_view_column",
      action = wt.action_callback(balance.balance_panes("x")),
    },
    {
      brief = "Balance panes vertically",
      icon = "md_view_array",
      action = wt.action_callback(balance.balance_panes("y")),
    },
  }
end)

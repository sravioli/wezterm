---@module "events.augment-command-palette"

local wt = require "wezterm" ---@class Wezterm
local act = wt.action

wt.on("augment-command-palette", function(_window, _pane)
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
      brief = "Pick colorscheme",
      icon = "md_palette",
      action = require("picker.colorscheme"):pick(),
    },
    {
      brief = "Pick font",
      icon = "md_format_font",
      action = require("picker.font"):pick(),
    },
    {
      brief = "Pick font size",
      icon = "md_format_font_size_decrease",
      action = require("picker.font-size"):pick(),
    },
    {
      brief = "Pick font leading",
      icon = "fa_text_height",
      action = require("picker.font-leading"):pick(),
    },
    {
      brief = "Invalidate cache",
      icon = "md_cached",
      action = wt.action_callback(function(_, _, _)
        require("utils.fn.cache").forget()
      end),
    },
  }
end)

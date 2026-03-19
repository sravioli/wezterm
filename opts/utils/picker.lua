---@module "opts.utils.picker"

---@module 'opts.picker'

local ico = require "utils.icons" ---@class Icons

---@class Opts.Utils.Picker
return {
  log = {
    enabled = true,
    threshold = "INFO",
    sinks = { default_enabled = true },
  },

  persistence = {
    enabled = true,
    path = nil, -- defaults to %LOCALAPPDATA%/wezterm/ or $XDG_STATE_HOME/wezterm/
    reset_behavior = "clear", -- "clear" | "persist"
  },

  assets_path_segments = { "picker", "assets" },

  defaults = {
    title = "Pick a value",
    sort_by = "id",
    fuzzy = true,
    description = "Select an item.",
    fuzzy_description = "Pick",
    alphabet = "1234567890abcdefghilmnopqrstuvwxyz",

    icons = ico.Picker,

    comp = function(sort_by)
      return function(a, b)
        local a_is_reset = a.id:lower() == "reset" or a.label:lower() == "reset"
        local b_is_reset = b.id:lower() == "reset" or b.label:lower() == "reset"
        return a_is_reset and not b_is_reset
          or (not b_is_reset and a[sort_by] < b[sort_by])
      end
    end,

    format_choices = function(internal_choices, _)
      local choices = {}
      for _, item in pairs(internal_choices) do
        choices[#choices + 1] = { id = item.choice.id, label = item.choice.label }
      end
      return choices
    end,

    format_description = function(desc, fuzzy, icons)
      local fmt = "%s %s%s "
      if fuzzy then
        return fmt:format(icons.fuzzy.ico, desc, icons.fuzzy.punct)
      else
        return fmt:format(icons.exact.ico, desc, icons.exact.punct)
      end
    end,
  },
}

---@diagnostic disable: undefined-field

local wt = require "wezterm"
local act = wt.action

local Util = require "utils"
local fs = Util.fn.fs
local color = Util.fn.color
local dump = Util.fn.dump

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
      brief = "Build themes",
      icon = "cod_paintcan",
      action = wt.action_callback(function()
        local colorschemes = wt.color.get_builtin_schemes()
        local fname = function(name)
          return fs.pathconcat("_themes", name .. ".lua")
        end

        for name, colors in pairs(colorschemes) do
          colors = color.add_tab_bar(colors)
          local filename = fname(name)

          local file = io.open(filename, "w")
          if not file then
            return
          end

          file:write("return " .. dump(colors))
          file:close()
        end
      end),
    },
  }
end)

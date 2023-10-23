local wez = require "wezterm" ---@class WezTerm
local nf = require "utils.nerdfont-icons" ---@class NerdFontIcons
local fn = require "utils.functions" ---@class UtilityFunctions

local M = {}

function M.setup()
  wez.on("format-window-title", function(tab, pane, tabs, _, _)
    local zoomed = ""
    if tab.active_pane.is_zoomed then zoomed = "[Z] " end

    local index = ""
    if #tabs > 1 then index = string.format("[%d/%d] ", tab.tab_index + 1, #tabs) end

    ---tab title
    local title = fn.basename(pane.title):gsub("%.exe%s?$", "")

    -- HACK: running Neovim will turn the tab title to "C:\WINDOWS\system32\cmd.exe".
    -- This is indeed a hack, but I'm never running cmd.exe so it's safe to override
    -- this way.
    if title == "cmd" then
      local cwd, _ = fn.basename(pane.current_working_dir)
      title = "Neovim" .. string.format(" %s%s%s", "(dir: ", cwd, ")")
    end

    -- return zoomed .. index .. tab.active_pane.title
    return zoomed .. index .. title
  end)
end

return M

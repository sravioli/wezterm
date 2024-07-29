---@module "events.augment-window-title"
---@author sravioli
---@license GNU-GPLv3

local wt = require "wezterm"
local fs = require("utils.fn").fs

wt.on("format-window-title", function(tab, pane, tabs, _, _)
  local zoomed = ""
  if tab.active_pane.is_zoomed then
    zoomed = "[Z] "
  end

  local index = ""
  if #tabs > 1 then
    index = ("[%d/%d] "):format(tab.tab_index + 1, #tabs)
  end

  ---tab title
  local title = fs.basename(pane.title):gsub("%.exe%s?$", "")

  local proc = pane.foreground_process_name
  if proc:find "nvim" then
    proc = proc:sub(proc:find "nvim")
  end
  if proc == "nvim" or title == "cmd" then
    local cwd, _ = fs.basename(pane.current_working_dir.file_path)
    title = ("Neovim (dir: %s)"):format(cwd)
  end

  return zoomed .. index .. title
end)

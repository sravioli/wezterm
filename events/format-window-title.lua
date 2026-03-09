---@module "events.augment-window-title"

local fs = require "utils.fn.fs" ---@class Fn.FileSystem
local wt = require "wezterm" ---@class Wezterm

---@param tab TabInformation
---@param pane PaneInformation
---@param tabs MuxTabObj[]
---@param _panes Pane[]
---@param _config Config
---@return string
---@diagnostic disable-next-line: unused-local
wt.on("format-window-title", function(tab, pane, tabs, _panes, _config)
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
    proc = proc:sub(proc:find "nvim" or 0)
  end
  if proc == "nvim" or title == "cmd" then
    local cwd_uri = pane.current_working_dir
    local cwd = cwd_uri and fs.basename(cwd_uri.file_path) or ""
    title = ("Neovim (dir: %s)"):format(cwd)
  end

  return zoomed .. index .. title
end)

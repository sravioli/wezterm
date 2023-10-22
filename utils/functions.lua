local wez = require "wezterm"
local nf = require "utils.nerdfont-icons"

---User defined utility functions
---@class UtilityFunctions
---@field basename function Lua equivalent of `basename(3)`
local functions = {}

---Equivalent to POSIX `basename(3)`
---@param path string Any string representing a path.
---@return string str The basename string.
---
---```lua
----- Example usage
---local name = fn.basename("/foo/bar") -- will be "bar"
---local name = fn.basename("C:\\foo\\bar") -- will be "bar"
---```
functions.basename = function(path)
  local trimmed_path = path:gsub("[/\\]*$", "") ---Remove trailing slashes from the path
  local index = trimmed_path:find "[^/\\]*$" ---Find the last occurrence of '/' in the path

  return index and trimmed_path:sub(index) or trimmed_path
end

functions.tab_title = function(tab)
  return nf.SemiCircle.left .. tab.window_title --process .. " " .. cwd
end

---Checks if the current pane is running as Administrator.
---@param pane_title string The current pane title.
---@return boolean is_admin `true` if running as admin, `false` otherwise.
functions.is_admin = function(pane_title)
  return pane_title:match "^Administrator: " and true or false
end

return functions

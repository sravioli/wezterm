---@diagnostic disable: undefined-field
local wez = require "wezterm" ---@class WezTerm

---User defined utility functions
---@class UtilityFunctions
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

---Rounds the given number to the nearest multiple given.
---@param number number Any number.
---@param multiple number Any number.
---@return number result The floating point number rounded to the closest multiple.
functions.mround = function(number, multiple)
  local remainder = number % multiple
  return number - remainder + (remainder > multiple / 2 and multiple or 0)
end

---Converts a float number to int.
---@param float number Any floating point number.
---@return integer result The closest integer.
functions.toint = function(float) return float | 0 end

---Will search the git project root directory of the given directory path. (see
---implementation to understand why this function exits)
---@param directory string The directory path.
---@return string|nil git_root If found, the `git_root`, else `nil`
functions.find_git_dir = function(directory)
  ---NOTE: this functions exits purely because calling the following function
  ---`wezterm.run_child_process({ "git", "rev-parse", "--show-toplevel" })`
  ---would cause the status bar to blinck every `config.status_update_interval`
  ---milliseconds. Moreover when changing tab, the status bar wouldn't be drawn.
  local home = os.getenv("USERPROFILE"):gsub("\\", "/")
  directory = directory:gsub("~", home)

  while directory do
    local handle = io.open(directory .. "/.git/config", "r")
    if handle then
      handle:close()
      directory = directory:gsub(home, "~")
      return directory
    elseif directory == "/" or directory == "" then
      break
    else
      directory = directory:match "(.+)/[^/]*"
    end
  end

  return nil
end

---Returns the current working directory and the hostname.
---@param pane table The wezterm pane object.
---@param search_git_root_instead? boolean Whether to search for the git root instead.
---@return string cwd The current working directory.
---@return string hostname The hostname.
---@see UtilityFunctions.find_git_dir
functions.get_cwd_hostname = function(pane, search_git_root_instead)
  local cwd, hostname = "", ""
  ---Figure out the cwd and host of the current pane. This will pick up the hostname
  ---for the remote host if your shell is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    if type(cwd_uri) == "userdata" then
      ---Running on a newer version of wezterm and we have a URL object here, making
      ---this simple!
      cwd = cwd_uri.file_path
      hostname = cwd_uri.host or wez.hostname()
    else
      ---an older version of wezterm, 20230712-072601-f4abf8fd or earlier, which
      ---doesn't have the URL object
      cwd_uri = cwd_uri:sub(8)
      local slash = cwd_uri:find "/"
      if slash then
        hostname = cwd_uri:sub(1, slash - 1)

        ---extract the cwd from the uri, decoding %-encoding
        local home = os.getenv("USERPROFILE"):gsub("\\", "/")
        cwd = cwd_uri
          :gsub("%%(%x%x)", function(hex) return string.char(tonumber(hex, 16)) end)
          :gsub("/" .. home .. "(.-)$", "~%1")
      end
    end

    ---Remove the domain name portion of the hostname
    local dot = hostname:find "[.]"
    if dot then hostname = hostname:sub(1, dot - 1) end
    if hostname == "" then hostname = wez.hostname() end
  end

  ---search for the git root of the project if specified
  if search_git_root_instead then
    local git_root = functions.find_git_dir(cwd)
    ---if no git root has been found, return the original cwd
    cwd = git_root and git_root or cwd
  end

  return cwd, hostname
end

return functions


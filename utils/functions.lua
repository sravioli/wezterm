---@diagnostic disable: undefined-field
local wez = require "wezterm" ---@class WezTerm
local nf = require "utils.nerdfont-icons" ---@class NerdFontIcons

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

---Returns the current working directory and the hostname
---@param pane table The wezterm pane object
---@return string cwd The current working directory
---@return string hostname The hostname
functions.get_cwd_hostname = function(pane)
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
      ---doesn't have the Url object
      cwd_uri = cwd_uri:sub(8)
      local slash = cwd_uri:find "/"
      if slash then
        hostname = cwd_uri:sub(1, slash - 1)

        ---extract the cwd from the uri, decoding %-encoding
        local home = (os.getenv "HOMEDRIVE" .. os.getenv "HOMEPATH"):gsub("\\", "/")
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

  return cwd, hostname
end

return functions

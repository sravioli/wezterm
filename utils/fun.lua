local wez = require "wezterm" ---@class WezTerm
local wcwidth, utf8 = require "utils.wcwidth", require "utf8"
local insert = table.insert

---User defined utility functions
---@class Fun
local M = {}

---Checks on which target triple wezterm was built on.
---@return boolean is_windows
M.is_windows = function()
  local target_triple = wez.target_triple
  ---check for the most common windows target triple first
  if target_triple == "x86_64-pc-windows-msvc" then
    return true
  end
  local windows_triples = {
    ["aarch64-pc-windows-gnullvm"] = {},
    ["aarch64-pc-windows-msvc"] = {},
    ["aarch64-uwp-windows-msvc"] = {},
    ["arm64ec-pc-windows-msvc"] = {},
    ["i586-pc-windows-msvc"] = {},
    ["i686-pc-windows-gnu"] = {},
    ["i686-pc-windows-gnullvm"] = {},
    ["i686-pc-windows-msvc"] = {},
    ["i686-uwp-windows-gnu"] = {},
    ["i686-uwp-windows-msvc"] = {},
    ["i686-win7-windows-msvc"] = {},
    ["thumbv7a-pc-windows-msvc"] = {},
    ["thumbv7a-uwp-windows-msvc"] = {},
    ["x86_64-pc-windows-gnu"] = {},
    ["x86_64-pc-windows-gnullvm"] = {},
    ["x86_64-pc-windows-msvc"] = {},
    ["x86_64-uwp-windows-gnu"] = {},
    ["x86_64-uwp-windows-msvc"] = {},
    ["x86_64-win7-windows-msvc"] = {},
  }
  return windows_triples[target_triple] and true or false
end

---User home directory
---@return string home path to the suer home directory.
M.home = (os.getenv "USERPROFILE" or os.getenv "HOME" or wez.home_dir or ""):gsub(
  "\\",
  "/"
)

---Equivalent to POSIX `basename(3)`
---@param path string Any string representing a path.
---@return string str The basename string.
---
---```lua
----- Example usage
---local name = fn.basename("/foo/bar") -- will be "bar"
---local name = fn.basename("C:\\foo\\bar") -- will be "bar"
---```
M.basename = function(path)
  local trimmed_path = path:gsub("[/\\]*$", "") ---Remove trailing slashes from the path
  local index = trimmed_path:find "[^/\\]*$" ---Find the last occurrence of '/' in the path

  return index and trimmed_path:sub(index) or trimmed_path
end

---Rounds the given number to the nearest multiple given.
---@param number number Any number.
---@param multiple number Any number.
---@return number result floating point number rounded to the closest multiple.
M.mround = function(number, multiple)
  local remainder = number % multiple
  return number - remainder + (remainder > multiple / 2 and multiple or 0)
end

---Converts a float into an integer.
---@param number number
---@param increment? number
---@return integer result
M.toint = function(number, increment)
  if increment then
    return math.floor(number / increment) * increment
  end
  return number >= 0 and math.floor(number + 0.5) or math.ceil(number - 0.5)
end

---Will search the git project root directory of the given directory path.
---NOTE: this functions exits purely because calling the following function
---`wezterm.run_child_process({ "git", "rev-parse", "--show-toplevel" })` would cause
---the status bar to blink every `config.status_update_interval` milliseconds. Moreover
---when changing tab, the status bar wouldn't be drawn.
---
---@param directory string The directory path.
---@return string|nil git_root If found, the `git_root`, else `nil`
M.find_git_dir = function(directory)
  directory = directory:gsub("~", M.home)

  while directory do
    local handle = io.open(directory .. "/.git/HEAD", "r")
    if handle then
      handle:close()
      directory = directory:gsub(M.home, "~")
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
---@see Fun.find_git_dir
M.get_cwd_hostname = function(pane, search_git_root_instead)
  local cwd, hostname = "", ""
  ---figure cwd and host of current pane. This will pick up the hostname for the remote
  ---host shell is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    if type(cwd_uri) == "userdata" then
      ---newer wezterm versions have a URL object, making it easier
      cwd = cwd_uri.file_path
      hostname = cwd_uri.host or wez.hostname()
    else
      ---older version, 20230712-072601-f4abf8fd or earlier, which doesn't have the URL object
      cwd_uri = cwd_uri:sub(8)
      local slash = cwd_uri:find "/"
      if slash then
        hostname = cwd_uri:sub(1, slash - 1)

        ---extract the cwd from the uri, decoding %-encoding
        cwd = cwd_uri:gsub("%%(%x%x)", function(hex)
          return string.char(tonumber(hex, 16))
        end)
      end
    end

    ---remove the domain name portion of the hostname
    local dot = hostname:find "[.]"
    if dot then
      hostname = hostname:sub(1, dot - 1)
    end
    if hostname == "" then
      hostname = wez.hostname()
    end
    hostname = hostname:gsub("^%l", string.upper)
  end

  if M.is_windows() then
    cwd = cwd:gsub("/" .. M.home .. "(.-)$", "~%1")
  else
    cwd = cwd:gsub(M.home .. "(.-)$", "~%1")
  end

  ---search for the git root of the project if specified
  if search_git_root_instead then
    local git_root = M.find_git_dir(cwd)
    cwd = git_root or cwd ---fallback to cwd
  end

  return cwd, hostname
end

---Merges two tables
---@param t1 table
---@param ... table[] one or more tables to merge
---@return table t1 modified t1 table
M.tbl_merge = function(t1, ...)
  local tables = { ... }

  for _, t2 in ipairs(tables) do
    for k, v in pairs(t2) do
      if type(v) == "table" then
        if type(t1[k] or false) == "table" then
          M.tbl_merge(t1[k] or {}, t2[k] or {})
        else
          t1[k] = v
        end
      else
        t1[k] = v
      end
    end
  end

  return t1
end

---Returns the colorscheme name absed on the system appearance
---@return '"kanagawa-wave"'|'"kanagawa-lotus"' colorscheme name of the colorscheme
M.get_scheme = function()
  if (wez.gui and wez.gui.get_appearance() or "Dark"):find "Dark" then
    return "kanagawa-wave"
  end
  return "kanagawa-lotus"
end

M.gsplit = function(s, sep, opts)
  local plain
  local trimempty = false
  if type(opts) == "boolean" then
    plain = opts -- For backwards compatibility.
  else
    opts = opts or {}
    plain, trimempty = opts.plain, opts.trimempty
  end

  local start = 1
  local done = false

  -- For `trimempty`: queue of collected segments, to be emitted at next pass.
  local segs = {}
  local empty_start = true -- Only empty segments seen so far.

  local function _pass(i, j, ...)
    if i then
      assert(j + 1 > start, "Infinite loop detected")
      local seg = s:sub(start, i - 1)
      start = j + 1
      return seg, ...
    else
      done = true
      return s:sub(start)
    end
  end

  return function()
    if trimempty and #segs > 0 then
      -- trimempty: Pop the collected segments.
      return table.remove(segs)
    elseif done or (s == "" and sep == "") then
      return nil
    elseif sep == "" then
      if start == #s then
        done = true
      end
      return _pass(start + 1, start)
    end

    local seg = _pass(s:find(sep, start, plain))

    -- Trim empty segments from start/end.
    if trimempty and seg ~= "" then
      empty_start = false
    elseif trimempty and seg == "" then
      while not done and seg == "" do
        insert(segs, 1, "")
        seg = _pass(s:find(sep, start, plain))
      end
      if done and seg == "" then
        return nil
      elseif empty_start then
        empty_start = false
        segs = {}
        return seg
      end
      if seg ~= "" then
        insert(segs, 1, seg)
      end
      return table.remove(segs)
    end

    return seg
  end
end

M.split = function(s, sep, opts)
  local t = {}
  for c in M.gsplit(s, sep, opts) do
    insert(t, c)
  end
  return t
end

---Map an action using (n)vim-like syntax
---@param lhs string keymap
---@param rhs function|string `wezterm.action.<action>`
---@param tbl table table to insert keys to
M.map = function(lhs, rhs, tbl)
  ---Inserts the keymap in the table
  ---@param key string key to press.
  ---@param mods? string modifiers. defaults to `""`
  local function map(key, mods)
    insert(tbl, { key = key, mods = mods or "", action = rhs })
  end

  ---skip checks for single key mapping, just map it.
  if #lhs == 1 then
    map(lhs)
    return
  end

  local aliases =
    { ["CR"] = "Enter", ["BS"] = "Backspace", ["ESC"] = "Escape", ["Bar"] = "|" }
  for i = 0, 9 do
    aliases["k" .. i] = "Numpad" .. i
  end

  local modifiers = { C = "CTRL", S = "SHIFT", W = "SUPER", M = "ALT" }

  local mods = {}
  ---search for a leader key
  if lhs:find "^<leader>" then
    lhs = (lhs:gsub("^<leader>", ""))
    insert(mods, "LEADER")
  end

  if lhs:find "%b<>" then
    lhs = lhs:gsub("(%b<>)", function(str)
      return str:sub(2, -2)
    end)

    local keys = M.split(lhs, "%-")
    if #keys == 1 then
      map(aliases[keys[1]] or keys[1])
      return
    end

    local k = keys[#keys]
    if modifiers[k] then
      wez.log_error "keymap cannot end with modifier!"
      return
    else
      table.remove(keys, #keys)
    end
    k = aliases[k] or k

    for _, key in ipairs(keys) do
      insert(mods, modifiers[key])
    end

    map(k, table.concat(mods, "|"))
    return
  end

  map(lhs, table.concat(mods, "|"))
end

---Calculate the printable length of first "num" characters of string "str" on a
---terminal. Returns the number of cells or -1 if the string contains non-printable
---characters. Raises an error on invalid UTF8 input.
---@param str string input string
---@param num? integer
---@return number|-1
M.strwidth = function(str, num)
  local cells = 0
  if num then
    local count = 0
    for _, rune in utf8.codes(str) do
      local w = wcwidth(rune)
      if w < 0 then
        return -1
      end
      count = count + 1
      if count >= num then
        break
      end
    end
  else
    for _, rune in utf8.codes(str) do
      local w = wcwidth(rune)
      if w < 0 then
        return -1
      end
      cells = cells + w
    end
  end
  return cells
end

---comment
---@param path string
---@param len any
M.pathshortener = function(path, len)
  local path_separator = M.is_windows() and "\\" or "/"
  local splitted_path = M.split(path, path_separator)
  local short_path = ""
  for _, dir in ipairs(splitted_path) do
    local short_dir = dir:sub(1, len)
    if short_dir == "" then
      break
    end
    short_path = short_path
      .. (short_dir == "." and dir:sub(1, len + 1) or short_dir)
      .. path_separator
  end
  wez.log_info(short_path)
end

return M

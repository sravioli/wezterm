---@module "utils.fn"
---@author sravioli
---@license GNU-GPLv3

--~ {{{1 globals to locals (faster)

--~~ {{{2 builtins
local pairs, require, tonumber, tostring, type = pairs, require, tonumber, tostring, type
--~~ }}}

--~~ {{{2 math
local mceil, mfloor = math.ceil, math.floor
--~~ }}}

--~~ {{{2 io
local ioclose, ioopen = io.close, io.open
--~~ }}}

--~~ {{{2 os
local oexec, ogetenv = os.execute, os.getenv
--~~ }}}

--~~ {{{2 string
local schar, sfind, sformat, sgsub, smatch, ssub, srep =
  string.char,
  string.find,
  string.format,
  string.gsub,
  string.match,
  string.sub,
  string.rep
--~~ }}}

--~~ {{{2 table
-- selene: allow(incorrect_standard_library_use)
local tconcat, tremove, tunpack = table.concat, table.remove, unpack or table.unpack
--~~ }}}

--~ }}}

--~ {{{1 requires

local wt = require "wezterm"

---@type table, string, function, table, string, function, string, function
local G, wt_cfg_dir, wt_col_width, wt_gui, wt_home, wt_hostname, wt_triple, wt_truncate_rx =
  wt.GLOBAL, ---@diagnostic disable-line: undefined-field
  wt.config_dir, ---@diagnostic disable-line: undefined-field
  wt.column_width, ---@diagnostic disable-line: undefined-field
  wt.gui, ---@diagnostic disable-line: undefined-field
  wt.home, ---@diagnostic disable-line: undefined-field
  wt.hostname, ---@diagnostic disable-line: undefined-field
  wt.target_triple, ---@diagnostic disable-line: undefined-field
  wt.truncate_right ---@diagnostic disable-line: undefined-field

---@diagnostic disable-next-line: undefined-field
if not wt.GLOBAL.cache then
  ---@diagnostic disable-next-line: undefined-field
  wt.GLOBAL.cache = {}
end
---@diagnostic disable-next-line: undefined-field
local CACHE = wt.GLOBAL.cache

local Icon, Logger = require "utils.class.icon", require "utils.class.logger"
--~ }}}

---@class Utils.Fn
local M = {}

--~ {{{1 Utils.Fn.G

---@class Utils.Fn.G
M.g = {}

--~~ {{{2 M.g.memoize(key: string, value: any) -> any

---Memoizes a value or the result of a function call under a global key.
---
---This function stores the result of a computation or a value in a global table
---(`wezterm.GLOBAL.cache`) for reuse, preventing redundant calculations or value lookups.
---If the `value` parameter is a function, the function is executed once, and its result
---is memoized.  If `value` is not a function, it is directly stored under the given key.
---For `nil` values, nothing gets stored.
---
---@param key string key under which the value or computed result is stored in cache
---@param value any value or function to be memoized.
---@return any value memoized value associated with the provided key.
---
---~~~lua
----- Example usage
---local g = require("utils.fn").g
---local result = g.memoize("some_key", function() return expensive_computation() end)
---print(result) -- will print the cached value
---~~~
M.g.memoize = function(key, value)
  if type(value) == "function" then
    return function()
      CACHE[key] = CACHE[key] or value()
      return CACHE[key]
    end
  end

  if value then
    CACHE[key] = CACHE[key] or value
  end
  return CACHE[key]
end --~~ }}}

--~~ {{{2 M.g.forget(key: string|nil)

---Removes a memoized value or clears the entire memoization table.
---
---This function deletes a specific memoized value identified by the provided `key`
---or clears all memoized values stored in the global table `wezterm.GLOBAL.cache`.   If
---no key is provided, the entire table is emptied and then set to `nil`.
---
---@param key string|nil key of memoized value to remove. If none, the whole cache is cleared.
---
---@usage
---~~~lua
----- Example usage
---local g = require("utils.fn").g
---g.forget("some_key") -- removes the value memoized under "some_key".
---g.forget() -- wipes the `wezterm.GLOBAL.cache` table
---~~~
M.g.forget = function(key)
  if not CACHE then
    return
  end

  if key then
    CACHE[key] = nil
  else
    for k, _ in pairs(CACHE) do
      CACHE[k] = nil
    end
  end
  CACHE = nil
end --~~ }}}

--~ }}}

--~ {{{1 Utils.Fn.Table

---@class Utils.Fn.Table
M.tbl = {}

--~~ {{{2 M.tbl.merge(tbl: table, ...: table[]) -> table

---Merges multiple tables into the first table recursively.
---
---This function takes a base table and one or more additional tables and merges their
---contents into the base table. For nested tables, it performs a recursive merge.
---Non-table values from subsequent tables overwrite values in the base table with the
---same key.
---
---@param tbl table The base table to merge values into.
---@param ... table One or more tables whose contents will be merged into `tbl`.
---@return table tbl `tbl` modified in-place with merged values from all other tables.
---
---@usage
---~~~lua
---local base = { a = 1, b = { x = 1 } }
---local other = { b = { y = 2 }, c = 3 }
---M.tbl.merge(base, other)
----- base = { a = 1, b = { x = 1, y = 2 }, c = 3 }
---~~~
M.tbl.merge = function(tbl, ...)
  local tables = { ... }

  for i = 1, #tables do
    local other_tbl = tables[i]
    for key, value in pairs(other_tbl) do
      if type(value) == "table" then
        if type(tbl[key] or false) == "table" then
          tbl.merge(tbl[key] or {}, other_tbl[key] or {})
        else
          tbl[key] = value
        end
      else
        tbl[key] = value
      end
    end
  end

  return tbl
end --~~ }}}

--~~ {{{2 M.tbl.cartesian(sets: table[]) -> table

---Computes the Cartesian product of multiple tables.
---
---This function takes a table of tables and returns a table containing all possible
---combinations of elements from the input tables, forming the Cartesian product.  The
---result is a table of table, where each table contains one element from each of the
---input tables.
---
---@param sets table table containing sub-tables. Each sub-table is one set of the cartesian.
---@return table cartesian all possible combinations of elements from the sub-tables.
---
---@usage
---~~~lua
---local sets = {
---  { 1, 2 },
---  { 'a', 'b' }
---}
---local product = require("utils.tbl").cartesian(sets)
----- product = {
-----   { 1, 'a' },
-----   { 1, 'b' },
-----   { 2, 'a' },
-----   { 2, 'b' }
----- }
---~~~
M.tbl.cartesian = function(sets)
  local res = { {} }
  for i = 1, #sets do
    local temp = {}
    for j = 1, #sets[i] do
      for k = 1, #res do
        temp[#temp + 1] = { sets[i][j], tunpack(res[k]) }
      end
    end
    res = temp
  end
  return res
end --~~ }}}

--~~ {{{2 M.tbl.reverse(tbl: table) -> table

---Reverses the given table
---@param tbl table table to reverse
---@return table tbl reversed table
M.tbl.reverse = function(tbl)
  local reversed = {}
  for i = #tbl, 1, -1 do
    reversed[#reversed + 1] = tbl[i]
  end
  return reversed
end --~~ }}}

--~ }}}

--~ {{{1 Utils.Fn.FileSystem

---@class Utils.Fn.FileSystem
---
---The `Utils.Fn.FileSystem` class provides a suite of utility functions for handling
---common file system operations, platform detection, and path manipulations. It includes
---methods for determining the operating system, handling paths, interacting with
---directories, and simplifying file system operations.  Memoization is used extensively
---to optimize repeated computations.
---
---**Example Usage**:
---
---~~~lua
---local fs = require("utils.fs")
---
----- Platform Detection
---local platform = fs.platform()
---if platform.is_linux then
---  print("Running on Linux!")
---end
---
----- Get Home Directory
---local home = fs.home()
---print("Home Directory:", home)
---
----- Normalize and Manipulate Paths
---local short_path = fs.pathshortener("/path/to/your/directory", 3)
---print("Shortened Path:", short_path)
---
----- Find Git Root
---local git_root = fs.find_git_dir("/path/to/your/project")
---if git_root then
---  print("Git Root Directory:", git_root)
---end
---
----- List Directory Contents
---local files = fs.read_dir("/path/to/your/directory")
---if files then
---  for _, file in ipairs(files) do
---    print(file)
---  end
---end
---~~~
M.fs = {}

---@package
---
---Class logger
M.fs.log = require("utils.class.logger"):new "Utils.Fn.FileSystem"

---@package
M.fs.target_triple = M.g.memoize("target-triple", wt_triple)

--~ {{{2 META

---@class Utils.Fn.FileSystem.Platform
---@field os "windows"|"linux"|"mac"|"unknown" The operating system name
---@field is_win boolean Whether the platform is Windows.
---@field is_linux boolean Whether the platform is Linux.
---@field is_mac boolean Whether the platform is Mac.

--~ }}}

--~~ {{{2 M.fs.platform() -> Utils.Fn.FileSystem.Platform

---Determines and memoizes the platform information.
---
---This function identifies the operating system based on the target triple and
---returns a table containing the OS name and boolean flags indicating the specific platform
---(Windows, Linux, or macOS).  The result is memoized to avoid redundant computations.
---
---@return Utils.Fn.FileSystem.Platform platform
---
---@usage
---~~~lua
---local platform = require("utils.fs").platform()
---if platform.is_linux then
---  -- linux specific logic
---end
---~~~
M.fs.platform = M.g.memoize("platform", function()
  local is_win = sfind(M.fs.target_triple, "windows") ~= nil
  local is_linux = sfind(M.fs.target_triple, "linux") ~= nil
  local is_mac = sfind(M.fs.target_triple, "apple") ~= nil
  local os = is_win and "windows" or is_linux and "linux" or is_mac and "mac" or "unknown"
  return { os = os, is_win = is_win, is_linux = is_linux, is_mac = is_mac }
end) --~~ }}}

---Whether the current platform is windows or not.
M.fs.is_win = M.g.memoize("is-win", M.fs.platform().is_win)

--~~ {{{2 M.fs.home() -> string

---Retrieves and memoizes the home directory path.
---
---This function determines the user's home directory by checking environment variables
---(`USERPROFILE` or `HOME`), the `wezterm.home`, or defaults to an empty string.
---The path is normalized by replacing backslashes (`\`) with forward slashes (`/`).
---The result is memoized for efficient reuse.
---
---@return string home normalized home directory path.
M.fs.home = M.g.memoize("home", function()
  return (sgsub((ogetenv "USERPROFILE" or ogetenv "HOME" or wt_home or ""), "\\", "/"))
end) --~~ }}}

---Path separator based on the platform.
---
---This variable holds the appropriate path separator character for the current platform.
M.fs.path_separator = M.g.memoize("path-separator", M.fs.is_win and "\\" or "/")

--~~ {{{2 M.fs.basename(path: string) -> string

---Equivalent to POSIX `basename(3)`.
---
---This function extracts the base name (the final component) from a given path.
---
---@param path string Any string representing a path.
---@return string str The base name of the path.
M.fs.basename = function(path)
  CACHE["basename"] = CACHE["basename"] or {}
  if CACHE["basename"][path] then
    return CACHE["basename"][path]
  end

  local trimmed_path = sgsub(path, "[/\\]*$", "")
  local index = sfind(trimmed_path, "[^/\\]*$")
  CACHE["basename"][path] = index and ssub(trimmed_path, index) or trimmed_path
  return CACHE["basename"][path]
end --~~ }}}

--~~ {{{2 M.fs.find_git_dir(directory: string) -> string

---Searches for the git project root directory of the given directory path.
---
---This function traverses up the directory tree to find the `.git` directory, indicating
---the root of a git project.
---
---@param directory string The directory path to start searching from.
---@return string|nil git_root If found, the `git_root`, else `nil`.
M.fs.find_git_dir = function(directory)
  directory = sgsub(directory, "~", M.fs.home())
  CACHE["git-dir"] = CACHE["git-dir"] or {}
  if CACHE["git-dir"][directory] then
    return CACHE["git-dir"][directory]
  end

  while directory do
    local handle = ioopen(directory .. "/.git/HEAD", "r")
    if handle then
      ioclose(handle)
      CACHE["git-dir"][directory] = sgsub(directory, M.fs.home(), "~")
      return CACHE["git-dir"][directory]
    elseif directory == "/" or directory == "" then
      break
    else
      directory = smatch(directory, "(.+)/[^/]*")
    end
  end

  return nil
end --~~ }}}

--~~ {{{2 M.fs.get_cwd_hostname(pane: wt.Pane, search_git_root_instead: boolean) -> string, string

---Returns the current working directory and the hostname.
---
---This function retrieves the current working directory and the hostname from the
---provided pane object. Optionally, it can search for the git root instead.
---
---@param pane wt.Pane The wezterm pane object.
---@param search_git_root_instead? boolean Whether to search for the git root instead.
---@return string cwd The current working directory.
---@return string hostname The hostname.
---@see Utils.Fn.FileSystem.find_git_dir
M.fs.get_cwd_hostname = function(pane, search_git_root_instead)
  local cwd, hostname = "", ""
  local cwd_uri = pane:get_current_working_dir()

  if cwd_uri then
    if type(cwd_uri) == "userdata" then
      cwd = cwd_uri.file_path ---@diagnostic disable-line: undefined-field
      hostname = cwd_uri.host or wt_hostname() ---@diagnostic disable-line: undefined-field
    else
      cwd_uri = ssub(cwd_uri, 8)
      local slash = sfind(cwd_uri, "/")
      if slash then
        hostname = ssub(cwd_uri, 1, slash - 1)
        cwd = sgsub(cwd_uri, "%%(%x%x)", function(hex)
          return schar(tonumber(hex, 16))
        end)
      end
    end

    local dot = sfind(hostname, "[.]")
    if dot then
      hostname = ssub(hostname, 1, dot - 1)
    end
    if hostname == "" then
      hostname = wt_hostname()
    end
    hostname = sgsub(hostname, "^%l", string.upper)
  end

  if M.fs.is_win then
    cwd = sgsub(cwd, "/" .. M.fs.home() .. "(.-)$", "~%1")
  else
    cwd = sgsub(cwd, M.fs.home() .. "(.-)$", "~%1")
  end

  if search_git_root_instead then
    local git_root = M.fs.find_git_dir(cwd)
    cwd = git_root or cwd
  end

  return cwd, hostname
end --~~ }}}

--~~ {{{2 M.fs.pathshortener(path: string, len: number) -> string

---Shortens the given path.
---
---This function truncates each component of a given path to a specified length.
---
---@param path string The path to shorten.
---@param len number The maximum length for each component of the path.
---@return string short_path
M.fs.pathshortener = function(path, len)
  CACHE["pathshortener"] = CACHE["pathshortener"] or {}
  local key = path .. ":" .. tostring(len)
  if CACHE["pathshortener"][key] then
    return CACHE["pathshortener"][key]
  end

  local splitted_path = M.str.split(path, M.fs.path_separator)
  local short_path = ""
  for i = 1, #splitted_path do
    local dir = splitted_path[i]
    local short_dir = ssub(dir, 1, len)
    if short_dir == "" then
      break
    end
    short_path = short_path
      .. (short_dir == "." and ssub(dir, 1, len + 1) or short_dir)
      .. M.fs.path_separator
  end
  CACHE["pathshortener"][key] = short_path
  return CACHE["pathshortener"][key]
end --~~ }}}

--~~ {{{2 M.fs.pathconcat(...: string) -> string

---Concatenates a vararg list of values to a single string
---@vararg string
---@return string path The concatenated path
M.fs.pathconcat = function(...)
  return tconcat({ ... }, M.fs.path_separator)
end --~~ }}}

--~~ {{{2 M.fs.ls_dir(directory: string) -> table[]|nil

---Reads the contents of a directory and returns a list of absolute filenames.
---@param directory string absolute path to the directory to read.
---@return table|nil files list of files present in the directory. nil if not accessible.
---
---@usage
---~~~lua
---local directory = "/path/to/your/directory"
---local files = Fs.read_dir(directory)
---for _, file in ipairs(files) do
---  print(file)
---end
---~~~
M.fs.ls_dir = function(directory)
  CACHE["read-dir"] = CACHE["read-dir"] or {}
  if CACHE["read-dir"][directory] then
    return CACHE["read-dir"][directory]
  end

  local filename = M.fs.basename(directory) .. ".txt"
  local cmd = "find %s -maxdepth 1 -type f > %s"
  local tempfile = M.fs.pathconcat("/tmp", filename)
  if M.fs.is_win then
    cmd = 'cmd /C "dir %s /B /S > %s"'
    tempfile = M.fs.pathconcat(ogetenv "TEMP", filename)
  end
  cmd = sformat(cmd, directory, tempfile)

  local files = {}
  local file = ioopen(tempfile, "r")
  if file then
    for line in file:lines() do
      files[#files + 1] = line
    end
    ioclose(file)
  else
    local success = oexec(cmd)
    if not success then
      return M.fs.log:error "[ls_dir] Unable to create temp file!"
    end
    file = ioopen(tempfile, "r")
    if file then
      for line in file:lines() do
        files[#files + 1] = line
      end
      ioclose(file)
    end
  end

  CACHE["read-dir"][directory] = files
  return CACHE["read-dir"][directory]
end --~~ }}}

--~ }}}

--~ {{{1 Utils.Fn.Keymap

---@class Utils.Fn.Keymap
---@field aliases   table
---@field modifiers table
M.key = {
  ---@package
  aliases = {
    CR = "Enter",
    BS = "Backspace",
    ESC = "Escape",
    Bar = "|",
    k0 = "Numpad0",
    k1 = "Numpad1",
    k2 = "Numpad2",
    k3 = "Numpad3",
    k4 = "Numpad4",
    k5 = "Numpad5",
    k6 = "Numpad6",
    k7 = "Numpad7",
    k8 = "Numpad8",
    k9 = "Numpad9",
  },

  ---@package
  modifiers = { C = "CTRL", S = "SHIFT", W = "SUPER", M = "ALT" },
}

---@package
---
---Class logger
M.key.log = require("utils.class.logger"):new "Utils.Keymap"

--~~ {{{2 M.key.__check(lhs: string?, rhs: (string|table)?, tbl: table?)

---@package
---
---nil checks the given parameters.
---@param lhs string? keymap
---@param rhs (string|table)? keymap action
---@param tbl table? table to fill with keymap
M.key.__check = function(lhs, rhs, tbl)
  if not lhs then
    return M.key.log:error("cannot map %s without lhs!", rhs)
  elseif not rhs then
    return M.key.log:error("cannot map %s to a nil action!", lhs)
  elseif not tbl then
    return M.key.log:error "cannot add keymaps! No table given"
  end
end --~~ }}}

--~~ {{{2 M.key.__has(lhs: string, pattern: string) -> boolean

---@package
---
---Check if the given keymap contains the given pattern
---@param lhs string
---@param pattern string
---@return boolean
M.key.__has = function(lhs, pattern)
  return sfind(lhs, pattern) ~= nil
end --~~ }}}

--~~ {{{2 M.key.__has_leader(lhs: string, mods: table) -> string

---@package
---
---Checks if the given keymap contains the `<leader>` prefix.
---
---If `^<leader>` is found it gets removed from the keymap and added to the mods table.
---
---@param lhs string keymap to check
---@param mods table modifiers table that gets eventually filled with the `"LEADER"` mod
---@return string lhs keymap with `^<leader>` removed (if found)
M.key.__has_leader = function(lhs, mods)
  if M.key.__has(lhs, "^<leader>") then ---leader should always be the fist keymap
    lhs = (sgsub(lhs, "^<leader>", ""))
    mods[#mods + 1] = "LEADER"
  end
  return lhs
end --~~ }}}

--~~ {{{2 M.key.map(lhs: string, rhs: string|table, tbl: table)

---Maps an action using (n)vim-like syntax.
---
---This function allows you to map a key or a combination of keys to a specific action,
---using a syntax similar to that of (n)vim. The mapped keys and actions are inserted
---into the provided table.
---
---@param lhs string key or key combination to map.
---@param rhs string|table valid `wezterm.action.<action>` to execute upon keypress.
---@param tbl table table in which to insert the keymaps.
---
---@usage
---
---~~~lua
----- Example usage
---local key = require("utils.key")
---local keymaps = {}
---key.map("<leader>a", wezterm.action.ActivateTab(1), keymaps)
---key.map("<C-a>", wezterm.action.ActivateTab(2), keymaps)
---key.map("b", wezterm.action.SendString("hello"), keymaps)
---~~~
M.key.map = function(lhs, rhs, tbl)
  M.key.__check(lhs, rhs, tbl)

  ---Inserts the given keymap in the table
  ---@param mods? table modifiers. defaults to `""`
  ---@param key string key to press.
  local function __map(key, mods)
    tbl[#tbl + 1] = { key = key, mods = tconcat(mods or {}, "|"), action = rhs }
  end

  ---initialize the modifiers table
  local mods = {}

  ---dont'parse a single key
  if #lhs == 1 then
    return __map(lhs, mods)
  end

  local aliases, modifiers = M.key.aliases, M.key.modifiers
  lhs = M.key.__has_leader(lhs, mods)

  if not M.key.__has(lhs, "%b<>") then
    return __map(lhs, mods)
  end

  lhs = sgsub(lhs, "(%b<>)", function(str)
    return ssub(str, 2, -2)
  end)

  local keys = M.str.split(lhs, "%-")

  if #keys == 1 then
    return __map(aliases[keys[1]] or keys[1], mods)
  end

  local k = keys[#keys]
  if modifiers[k] then
    return M.key.log:error "keymap cannot end with modifier!"
  else
    keys[#keys] = nil
  end
  k = aliases[k] or k

  for i = 1, #keys do
    mods[#mods + 1] = modifiers[keys[i]]
  end

  return __map(k, mods)
end --~~ }}}

--~ }}}

--~ {{{1 Utils.Fn.Maths

---@class Utils.Fn.Maths
M.mt = {}

--~~ {{{2 M.mt.round(number: number) -> integer

---Rounds the given number to the nearest integer
---@param number number
---@return integer result closest integer number
M.mt.round = function(number)
  return mfloor(number + 0.5)
end --~~ }}}

--~~ {{{2 M.mt.mround(number: number, multiple: number) -> number

---Rounds the given number to the nearest multiple given.
---@param number number Any number.
---@param multiple number Any number.
---@return number result floating point number rounded to the closest multiple.
M.mt.mround = function(number, multiple)
  local remainder = number % multiple
  return number - remainder + (remainder > multiple * 0.5 and multiple or 0)
end --~~ }}}

--~~ {{{2 M.mt.toint(number: number, increment?: number) -> integer

---Converts a float into an integer.
---@param number number
---@param increment? number
---@return integer result
M.mt.toint = function(number, increment)
  if increment then
    return mfloor(number / increment) * increment
  end
  return number >= 0 and mfloor(number + 0.5) or mceil(number - 0.5)
end --~~ }}}

--~ }}}

--~ {{{1 Utils.Fn.String

---@class Utils.Fn.String
M.str = {}

M.str.width = wt_col_width

--~~ {{{2 M.str.pad(s: string, padding?: integer) -> string

---Returns a padded string and ensures that it's not shorter than 2 chars.
---@param s string input string
---@param padding? integer left/right padding. defaults to 1
---@return string s the padded string
M.str.pad = function(s, padding)
  s = type(s) ~= "string" and tostring(s) or s
  padding = padding or 1

  local pad = srep(" ", padding)
  return sformat("%s%s%s", pad, s, pad)
end --~~ }}}

--~~ {{{2 M.str.padl(s: string, padding?: integer) -> string

---Returns a padded string and ensures that it's not shorter than 2 chars.
---@param s string input string
---@param padding? integer left padding. defaults to 1
---@return string s the padded string
M.str.padl = function(s, padding)
  s = type(s) ~= "string" and tostring(s) or s
  padding = padding or 1

  local pad = srep(" ", padding)
  return sformat("%s%s", pad, s)
end --~~ }}}

--~~ {{{2 M.str.padr(s: string, padding?: integer) -> string

---Returns a padded string and ensures that it's not shorter than 2 chars.
---@param s string input string
---@param padding? integer right padding. defaults to 1
---@return string s the padded string
M.str.padr = function(s, padding)
  s = type(s) ~= "string" and tostring(s) or s
  padding = padding or 1

  local pad = srep(" ", padding)
  return sformat("%s%s", s, pad)
end --~~ }}}

--~~ {{{2 M.str.trim(s: string) -> string

---Trims leading and trailing whitespace from the given string
---@param s string input string
---@return string s the trimmed string
M.str.trim = function(s)
  return (sgsub(s, "^%s*(.-)%s*$", "%1"))
end --~~ }}}

--~~ {{{2 M.str.gsplit(s: string, sep: string, opts?: table|nil) -> fun(): string

---Splits a string into an iterator of substrings based on a separator pattern.
---
---This function returns an iterator that yields substrings from the input string `s`
---separated by the specified pattern `sep`. It supports optional parameters to treat
---the separator as plain text and to trim empty segments.
---
---@usage
---~~~lua
---for segment in M.gsplit("a,b,c", ",") do
---  print(segment)  -- Outputs: "a", "b", "c"
---end
---~~~
---
---@param s string The input string to split.
---@param sep string The separator pattern to split the string by.
---@param opts? table|nil Optional parameters: `plain` (boolean): If true, treats the separator as plain text. `trimempty` (boolean): If true, trims empty segments from the start and end.
---@return fun(): string|nil f An iterator function that returns the next substring on each call.
---
M.str.gsplit = function(s, sep, opts)
  local plain, trimempty
  opts = opts or {}
  plain, trimempty = opts.plain, opts.trimempty

  local start = 1
  local done = false

  -- For `trimempty`: queue of collected segments, to be emitted at next pass.
  local segs = {}
  local empty_start = true -- Only empty segments seen so far.

  local function _pass(i, j, ...)
    if i then
      assert(j + 1 > start, "Infinite loop detected")
      local seg = ssub(s, start, i - 1)
      start = j + 1
      return seg, ...
    else
      done = true
      return ssub(s, start)
    end
  end

  return function()
    if trimempty and #segs > 0 then
      -- trimempty: Pop the collected segments.
      return tremove(segs)
    elseif done or (s == "" and sep == "") then
      return nil
    elseif sep == "" then
      if start == #s then
        done = true
      end
      return _pass(start + 1, start)
    end

    local seg = _pass(sfind(s, sep, start, plain))

    -- Trim empty segments from start/end.
    if trimempty and seg ~= "" then
      empty_start = false
    elseif trimempty and seg == "" then
      while not done and seg == "" do
        segs[1] = ""
        seg = _pass(sfind(s, sep, start, plain))
      end
      if done and seg == "" then
        return nil
      elseif empty_start then
        empty_start = false
        segs = {}
        return seg
      end
      if seg ~= "" then
        segs[1] = seg
      end
      return tremove(segs)
    end

    return seg
  end
end --~~ }}}

--~~ {{{2 M.str.split(s: string, sep: string, opts? table|nil) -> table

---Splits a string into a table of substrings based on a separator pattern.
---
---This function splits the input string `s` into substrings separated by the specified
---pattern `sep` and returns these substrings in a table. It supports optional parameters
---to treat the separator as plain text and to trim empty segments.
---
---@usage
---~~~lua
---local result = M.split("a,b,c", ",")
---for _, segment in ipairs(result) do
---  print(segment)  -- Outputs: "a", "b", "c"
---end
---~~~
---
---@param s string The input string to split.
---@param sep string The separator pattern to split the string by.
---@param opts? table|nil Optional parameters: `plain` (boolean): If true, treats the separator as plain text. `trimempty` (boolean): If true, trims empty segments from the start and end.
---@return table t A table containing the substrings.
M.str.split = function(s, sep, opts)
  local key = s .. ":" .. sep .. ":" .. tconcat(opts or {}, "-")
  CACHE["split"] = CACHE["split"] or {}
  if CACHE["split"][key] then
    return CACHE["split"][key]
  end

  local t = {}
  for c in M.str.gsplit(s, sep, opts) do
    t[#t + 1] = c
  end

  CACHE["split"][key] = t
  return CACHE["split"][key]
end --~~ }}}

--~~ {{{2 M.str.format_tab_title(pane: wt.Pane, title: string, Config: table, max_width: integer)

M.str.format_tab_title = function(pane, title, config, max_width)
  title = sgsub(title, "^Copy mode: ", "")
  local process, other = smatch(title, "^(%S+)%s*%-?%s*%s*(.*)$")

  if Icon.Progs[process] then
    title = Icon.Progs[process] .. " " .. (other or "")
  end

  local proc = pane.foreground_process_name or pane:get_foreground_process_name() or ""
  if sfind(proc, "nvim") then
    proc = ssub(proc, sfind(proc, "nvim") or 1)
  end
  local is_truncation_needed = true
  if proc == "nvim" then
    ---full title truncation is not necessary since the dir name will be truncated
    is_truncation_needed = false
    local full_cwd = pane.current_working_dir and pane.current_working_dir.file_path
      or pane:get_current_working_dir().file_path
    local cwd = M.fs.basename(full_cwd)

    ---instead of truncating the whole title, truncate to length the cwd to ensure that the
    ---right parenthesis always closes.
    if max_width == config.tab_max_width then
      cwd = wt_truncate_rx(cwd, max_width - 14) .. "..."
    end

    title = ("%s (%s %s)"):format(Icon.Progs[proc], Icon.Folder, cwd)
  end

  title = sgsub(title, M.fs.basename(M.fs.home()), "󰋜 ")

  ---truncate the tab title when it overflows the maximum available space, then concatenate
  ---some dots to indicate the occurred truncation
  if is_truncation_needed and max_width == config.tab_max_width then
    title = wt_truncate_rx(title, max_width - 8) .. "..."
  end

  return title
end --~~ }}}

--~ }}}

--~ {{{1 Utils.Fn.Color

---@class Utils.Fn.Color
---
---The `Utils.Color` class provides functionality for managing and applying color
---schemes in a Lua-based environment. It includes methods for dynamically loading color
---schemes, determining the appropriate scheme based on the user interface's appearance,
---and applying these schemes to visual elements like tabs and configuration settings.
---
---
---**Example Usage**:
---
---~~~lua
---local Config = {}
---local color = require("utils.color")
---
----- Load all available color schemes
---local schemes = color.get_schemes()
---for name, scheme in pairs(schemes) do
---  print("Loaded scheme:", name)
---end
---
----- Automatically select a color scheme based on GUI appearance
---Config.color_scheme = color.get_scheme()
---
----- Style Tab Buttons
---local theme = {
---  tab_bar = {
---    new_tab = { bg_color = "#000000", fg_color = "#FFFFFF", intensity = "Bold" },
---    new_tab_hover = { bg_color = "#222222", fg_color = "#CCCCCC", italic = true },
---    background = "#111111",
---  },
---}
---color.set_tab_button(Config, theme)
---
----- Set a color scheme and configure the appearance
---local theme = {
---  background = "#1e1e2e",
---  brights = {
---    "#a6adc8", "#f38ba8", "#fab387", "#f9e2af",
---    "#94e2d5", "#89b4fa", "#cba6f7", "#f5e0dc",
---  },
---}
---color.set_scheme(Config, theme, "kanagawa-wave")
---~~~
M.color = {}

---@package
M.color.log = Logger:new "Utils.Fn.Color"

--~~ {{{2 M.color.get_schemes() -> table[]

---Loads and returns all available color schemes.
---
---This function scans a predefined directory for Lua files representing color schemes,
---loads them dynamically, and returns a table of color schemes indexed by their names.
---If the directory cannot be read, it logs an error and returns an empty table.
---
---@return table schemes table of colorschemes.
---
---@usage
---~~~lua
-----Example usage
---local Config = {}
---Config.color_schemes = require("utils.color").get_schemes()
---~~~
M.color.get_schemes = function()
  local dir = M.fs.pathconcat(wt_cfg_dir, "picker", "assets", "colorschemes")
  local files = M.fs.ls_dir(dir)
  if not files then
    M.color.log:error("Unable to read from directory: '%s'", M.fs.basename(dir))
    return {}
  end

  local schemes = {}
  for i = 1, #files do
    local name = M.fs.basename(files[i]:gsub("%.lua$", ""))
    schemes[name] = require("picker.assets.colorschemes." .. name).scheme
    M.color.log:debug("loaded %s colorscheme", name)
  end
  return schemes
end --~~}}}

--~~ {{{2 M.color.get_scheme() -> "kanagawa-wave"|"kanagawa-lotus"

---Determines and returns the appropriate color scheme based on the GUI appearance.
---
---This function checks the current GUI appearance (e.g., light or dark mode)
---and returns a predefined color scheme name accordingly.  If the appearance is
---detected as "Dark," it returns `"kanagawa-wave"`.  Otherwise, it defaults to
---`"kanagawa-lotus"`.
---
---@return "kanagawa-wave"|"kanagawa-lotus" colorscheme
---
---@usage
---~~~lua
-----Example usage
---local Config = {}
---Config.color_scheme = require("utils.color").get_scheme()
---return Config
---~~~
M.color.get_scheme = function()
  if sfind((wt_gui and wt_gui.get_appearance() or ""), "Dark") then
    return "kanagawa-wave"
  end
  return "kanagawa-lotus"
end --~~}}}

--~~ {{{2 M.color.set_tab_button(Config: table, theme: table)

---Sets the tab button style in the configuration based on the specified theme.
---
---This function updates the `config` object to set the style for the tab buttons
---(`new_tab` and `new_tab_hover`) using the color scheme provided in the `theme` object.
---It constructs the button layout with appropriate colors, separators, and text attributes.
---
---@usage
---~~~lua
---local config = {}
---local theme = {
---  tab_bar = {
---    new_tab = { bg_color = "#000000", fg_color = "#FFFFFF", intensity = "Bold" },
---    new_tab_hover = { bg_color = "#111111", fg_color = "#EEEEEE", italic = true },
---    background = "#222222"
---  }
---}
---require("utils.color").set_tab_button(config, theme)
---~~~
---
---@param Config table The configuration object to be updated with tab button styles.
---@param theme table The theme object containing color schemes for different tab states.
M.color.set_tab_button = function(Config, theme)
  Config.tab_bar_style = {}
  local sep = Icon.Sep.tb

  local states = { "new_tab", "new_tab_hover" }
  for i = 1, #states do
    local state = states[i]
    local style = theme.tab_bar[state]
    local sep_bg, sep_fg = style.bg_color, theme.tab_bar.background

    local bl = require("utils.class.layout"):new "ButtonLayout"
    local attributes = {
      style.intensity
        or (style.italic and "Italic")
        or (style.strikethrough and "Strikethrough")
        or (style.underline ~= "None" and style.underline),
    }

    bl:append(sep_bg, sep_fg, sep.right, attributes)
    bl:append(sep_bg, style.fg_color, " + ", attributes)
    bl:append(sep_bg, sep_fg, sep.left, attributes)

    Config.tab_bar_style[state] = bl:format()
  end
end --~~}}}

--~~ {{{2 M.color.set_scheme(Config: table, theme: table, name: string)

--- Configures the color scheme and related visual settings.
---
---This function sets the color scheme and applies various color-related configurations
---such as background, character selection colors, and command palette colors, based on
---the provided theme and scheme name.  Additionally, it updates the tab button styling
---using the `Utils.Color.set_tab_button()` function.
---
---@param Config table configuration to update with the new color scheme and settings.
---@param theme table valid colorscheme.
---@param name string name of the color scheme to apply.
---
---@usage
---~~~lua
-----Example usage
---local theme = {
---  background = "#1e1e2e",
---  brights = {
---    "#a6adc8", "#f38ba8", "#fab387", "#f9e2af",
---    "#94e2d5", "#89b4fa", "#cba6f7", "#f5e0dc",
---  },
---}
---Color.set_scheme(Config, theme, "kanagawa-wave")
---~~~
---
---@note
---* The `Config` table is modified in-place to apply the settings.
---* The `wezterm.GLOBAL.opacity` global variable is used to determine background opacity.
---  If it is `nil`, the opacity defaults to `1`.
M.color.set_scheme = function(Config, theme, name)
  Config.color_scheme = name
  Config.char_select_bg_color = theme.brights[6]
  Config.char_select_fg_color = theme.background
  Config.command_palette_bg_color = theme.brights[6]
  Config.command_palette_fg_color = theme.background
  Config.background = {
    {
      source = { Color = theme.background },
      width = "100%",
      height = "100%",
      opacity = G.opacity or 1,
    },
  }
  M.color.set_tab_button(Config, theme)
end --~~}}}

--~ }}}

return M

-- vim: fdm=marker fdl=0

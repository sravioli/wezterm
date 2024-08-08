---Various utility functions
---
---@module "utils.fn"
---@author sravioli
---@license GNU-GPLv3

local wt = require "wezterm"
local G = wt.GLOBAL ---@diagnostic disable-line: undefined-field

local Icon = require("utils").class.icon
local Logger = require("utils").class.logger

local wcwidth, codes = require "utils.external.wcwidth", require("utf8").codes
local floor, ceil = math.floor, math.ceil

---User defined utility functions
---@class Utils.Fn
---@field fs    Utils.Fn.FileSystem
---@field mt    Utils.Fn.Maths
---@field str   Utils.Fn.String
---@field key   Utils.Fn.Keymap
---@field color Utils.Fn.Color
local M = {}

---Merges two tables
---@param t1 table
---@param ... table[] one or more tables to merge
---@return table t1 modified t1 table
M.tbl_merge = function(t1, ...)
  local tables = { ... }

  for i = 1, #tables do
    local t2 = tables[i]
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

---Memoize the function return value in the given `wezterm.GLOBAL` key
---@param key string key in which to memoize fn return value
---@param value any function to memoize
---@return any value function that returns the cached value
M.gmemoize = function(key, value)
  local is_fn = type(value) == "function"
  if G[key] == nil then
    G[key] = is_fn and value() or value
  end
  return is_fn and function()
    return G[key]
  end or value
end

-- {{{1 Utils.Fn.FileSystem

---@class Utils.Fn.FileSystem
---@field private target_triple string
M.fs = {}

M.fs.target_triple = M.gmemoize("target_triple", wt.target_triple)

-- {{{2 META

---@class Utils.Fn.FileSystem.Platform
---@field os "windows"|"linux"|"mac"|"unknown" The operating system name
---@field is_win boolean Whether the platform is Windows.
---@field is_linux boolean Whether the platform is Linux.
---@field is_mac boolean Whether the platform is Mac.

-- }}}

---Determines the platform based on the target triple.
---
---This function checks the target triple string to determine if the platform is Windows,
---Linux, or macOS.
---
---@return Utils.Fn.FileSystem.Platform platform
M.fs.platform = M.gmemoize("plaftorm", function()
  local is_win = M.fs.target_triple:find "windows" ~= nil
  local is_linux = M.fs.target_triple:find "linux" ~= nil
  local is_mac = M.fs.target_triple:find "apple" ~= nil
  local os = is_win and "windows" or is_linux and "linux" or is_mac and "mac" or "unknown"
  return { os = os, is_win = is_win, is_linux = is_linux, is_mac = is_mac }
end)

local is_win = M.fs.platform().is_win

---Gets the user home directory.
---
---This function retrieves the home directory path from environment variables or fallback
---sources and replaces backslashes with forward slashes.
---
---@return string home The path to the user home directory.
M.fs.home = M.gmemoize("home", function()
  return ((os.getenv "USERPROFILE" or os.getenv "HOME" or wt.home or ""):gsub("\\", "/"))
end)

---Path separator based on the platform.
---
---This variable holds the appropriate path separator character for the current platform.
M.fs.path_separator = M.gmemoize("path_separator", is_win and "\\" or "/")

---Equivalent to POSIX `basename(3)`.
---
---This function extracts the base name (the final component) from a given path.
---
---@param path string Any string representing a path.
---@return string str The base name of the path.
M.fs.basename = function(path)
  local trimmed_path = path:gsub("[/\\]*$", "")
  local index = trimmed_path:find "[^/\\]*$"
  return index and trimmed_path:sub(index) or trimmed_path
end

---Searches for the git project root directory of the given directory path.
---
---This function traverses up the directory tree to find the `.git` directory, indicating
---the root of a git project.
---
---@param directory string The directory path to start searching from.
---@return string|nil git_root If found, the `git_root`, else `nil`.
M.fs.find_git_dir = function(directory)
  directory = directory:gsub("~", M.fs.home())

  while directory do
    local handle = io.open(directory .. "/.git/HEAD", "r")
    if handle then
      handle:close()
      directory = directory:gsub(M.fs.home(), "~")
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
---
---This function retrieves the current working directory and the hostname from the
---provided pane object. Optionally, it can search for the git root instead.
---
---@param pane table The wezterm pane object.
---@param search_git_root_instead? boolean Whether to search for the git root instead.
---@return string cwd The current working directory.
---@return string hostname The hostname.
---@see Utils.Fn.FileSystem.find_git_dir
M.fs.get_cwd_hostname = function(pane, search_git_root_instead)
  local cwd, hostname = "", ""
  local cwd_uri = pane:get_current_working_dir()

  if cwd_uri then
    if type(cwd_uri) == "userdata" then
      cwd = cwd_uri.file_path
      hostname = cwd_uri.host or wt.hostname()
    else
      cwd_uri = cwd_uri:sub(8)
      local slash = cwd_uri:find "/"
      if slash then
        hostname = cwd_uri:sub(1, slash - 1)
        cwd = cwd_uri:gsub("%%(%x%x)", function(hex)
          return string.char(tonumber(hex, 16))
        end)
      end
    end

    local dot = hostname:find "[.]"
    if dot then
      hostname = hostname:sub(1, dot - 1)
    end
    if hostname == "" then
      hostname = wt.hostname()
    end
    hostname = hostname:gsub("^%l", string.upper)
  end

  if is_win then
    cwd = cwd:gsub("/" .. M.fs.home() .. "(.-)$", "~%1")
  else
    cwd = cwd:gsub(M.fs.home() .. "(.-)$", "~%1")
  end

  if search_git_root_instead then
    local git_root = M.fs.find_git_dir(cwd)
    cwd = git_root or cwd
  end

  return cwd, hostname
end

---Shortens the given path.
---
---This function truncates each component of a given path to a specified length.
---
---@param path string The path to shorten.
---@param len number The maximum length for each component of the path.
---@return string short_path
M.fs.pathshortener = function(path, len)
  local splitted_path = M.str.split(path, M.fs.path_separator)
  local short_path = ""
  for i = 1, #splitted_path do
    local dir = splitted_path[i]
    local short_dir = dir:sub(1, len)
    if short_dir == "" then
      break
    end
    short_path = short_path
      .. (short_dir == "." and dir:sub(1, len + 1) or short_dir)
      .. M.fs.path_separator
  end
  return short_path
end

---Concatenates a vararg list of values to a single string
---@vararg string
---@return string path The concatenated path
M.fs.pathconcat = function(...)
  local paths = { ... }
  return table.concat(paths, M.fs.path_separator)
end

---Reads the contents of a directory and returns a list of absolute filenames.
---@param directory string absolute path to the directory to read.
---@return table|nil files list of files present in the directory. nil if not accessible.
---
---@usage
---~~~lua
---local directory = "/path/to/your/directory"
---local files = M.fs.read_dir(directory)
---for _, file in ipairs(files) do
---  print(file)
---end
---~~~
M.fs.read_dir = function(directory)
  if G.dirs_read and G.dirs_read[directory] then
    return G.dirs_read[directory]
  end

  local filename = M.fs.basename(directory) .. ".txt"
  local cmd = "find %s -maxdepth 1 -type f > %s"
  local tempfile = M.fs.pathconcat("/tmp", filename)
  if is_win then
    cmd = 'cmd /C "dir %s /B /S > %s"'
    tempfile = M.fs.pathconcat(os.getenv "TEMP", filename)
  end
  cmd = cmd:format(directory, tempfile)

  local files = {}
  local file = io.open(tempfile, "r")
  if file then
    for line in file:lines() do
      files[#files + 1] = line
    end
    file:close()
  else
    local success = os.execute(cmd)
    if not success then
      return wt.log_error "Unable to create temp file."
    end
    file = io.open(tempfile, "r")
    if file then
      for line in file:lines() do
        files[#files + 1] = line
      end
      file:close()
    end
  end

  G.dirs_read = { [directory] = files }
  return G.dirs_read[directory]
end
-- }}}

-- {{{1 Utils.Fn.Maths

---@class Utils.Fn.Maths
M.mt = {}

---Rounds the given number to the nearest integer
---@param number number
---@return integer result closest integer number
M.mt.round = function(number)
  return floor(number + 0.5)
end

---Rounds the given number to the nearest multiple given.
---@param number number Any number.
---@param multiple number Any number.
---@return number result floating point number rounded to the closest multiple.
M.mt.mround = function(number, multiple)
  local remainder = number % multiple
  return number - remainder + (remainder > multiple * 0.5 and multiple or 0)
end

---Converts a float into an integer.
---@param number number
---@param increment? number
---@return integer result
M.mt.toint = function(number, increment)
  if increment then
    return floor(number / increment) * increment
  end
  return number >= 0 and floor(number + 0.5) or ceil(number - 0.5)
end

-- }}}

-- {{{1 Utils.Fn.String

---@class Utils.Fn.String
M.str = {}

---Calculate the printable length of first "num" characters of string "str" on a
---terminal. Returns the number of cells or -1 if the string contains non-printable
---characters. Raises an error on invalid UTF8 input.
---@param str string input string
---@param num? integer
---@return number|-1
M.str.strwidth = function(str, num)
  local cells = 0
  if num then
    local count = 0
    for _, rune in codes(str) do
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
    for _, rune in codes(str) do
      local w = wcwidth(rune)
      if w < 0 then
        return -1
      end
      cells = cells + w
    end
  end
  return cells
end

---Returns a padded string and ensures that it's not shorter than 2 chars.
---@param s string input string
---@param padding? integer left/right padding. defaults to 1
---@return string s the padded string
M.str.pad = function(s, padding)
  s = type(s) ~= "string" and tostring(s) or s
  padding = padding or 1

  local pad = (" "):rep(padding)
  return ("%s%s%s"):format(pad, s, pad)
end

---Splits a string into an iterator of substrings based on a separator pattern.
---
---This function returns an iterator that yields substrings from the input string `s`
---separated by the specified pattern `sep`. It supports optional parameters to treat
---the separator as plain text and to trim empty segments.
---
---@usage
---~~~lua
---for segment in M.str.gsplit("a,b,c", ",") do
---  print(segment)  -- Outputs: "a", "b", "c"
---end
---~~~
---
---@param s string The input string to split.
---@param sep string The separator pattern to split the string by.
---@param opts? table|nil Optional parameters: `plain` (boolean): If true, treats the separator as plain text. `trimempty` (boolean): If true, trims empty segments from the start and end.
---@return function f An iterator function that returns the next substring on each call.
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
        segs[1] = ""
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
        segs[1] = seg
      end
      return table.remove(segs)
    end

    return seg
  end
end

---Splits a string into a table of substrings based on a separator pattern.
---
---This function splits the input string `s` into substrings separated by the specified
---pattern `sep` and returns these substrings in a table. It supports optional parameters
---to treat the separator as plain text and to trim empty segments.
---
---@usage
---~~~lua
---local result = M.str.split("a,b,c", ",")
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
  local t = {}
  for c in M.str.gsplit(s, sep, opts) do
    t[#t + 1] = c
  end
  return t
end

M.str.format_tab_title = function(tab, config, max_width)
  local pane = tab.active_pane

  local title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title
    or tab.active_pane.title

  title = title:gsub("^Copy mode: ", "")
  local process, other = title:match "^(%S+)%s*%-?%s*%s*(.*)$"

  if Icon.Progs[process] then
    title = Icon.Progs[process] .. " " .. (other or "")
  end

  local proc = pane.foreground_process_name
  if proc:find "nvim" then
    proc = proc:sub(proc:find "nvim")
  end
  local is_truncation_needed = true
  if proc == "nvim" then
    ---full title truncation is not necessary since the dir name will be truncated
    is_truncation_needed = false
    local cwd = M.fs.basename(pane.current_working_dir.file_path)

    ---instead of truncating the whole title, truncate to length the cwd to ensure that the
    ---right parenthesis always closes.
    if max_width == config.tab_max_width then
      cwd = wt.truncate_right(cwd, max_width - 14) .. "..."
    end

    title = ("%s ( %s)"):format(Icon.Progs[proc], cwd)
  end

  title = title:gsub(M.fs.basename(M.fs.home()), "󰋜 ")

  ---truncate the tab title when it overflows the maximum available space, then concatenate
  ---some dots to indicate the occurred truncation
  if is_truncation_needed and max_width == config.tab_max_width then
    title = wt.truncate_right(title, max_width - 8) .. "..."
  end

  return title
end

-- }}}

-- {{{1 Utils.Fn.Keymap

---@class Utils.Fn.Keymap
---@field private aliases   table
---@field private modifiers table
M.key = {
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

  modifiers = { C = "CTRL", S = "SHIFT", W = "SUPER", M = "ALT" },
}

---@private
---nil checks the given parameters.
---@param log Utils.Class.Logger logger object to log to console
---@param lhs string? keymap
---@param rhs (string|table)? keymap action
---@param tbl table? table to fill with keymap
---@return nil
M.key.__check = function(log, lhs, rhs, tbl)
  if not lhs then
    return log:error("cannot map %s without lhs!", rhs)
  elseif not rhs then
    return log:error("cannot map %s to a nil action!", lhs)
  elseif not tbl then
    return log:error "cannot add keymaps! No table given"
  end
end

---@private
---
---Check if the given keymap contains the given pattern
---@param lhs string
---@param pattern string
---@return boolean
M.key.__has = function(lhs, pattern)
  return lhs:find(pattern) ~= nil
end

---@private
---
---Checks if the given keymap contains the `<leader>` prefix.
---
---If `^<leader>` is found it gets removed from the keymap and added to the mods table.
---
---@param lhs string keymap to check
---@param mods table modifiers table that gets eventually filled with the `"LEADER"` mod
---@return string lhs keymap with `^<leader>` removed (if found)
---@nodiscard
M.key.__has_leader = function(lhs, mods)
  if M.key.__has(lhs, "^<leader>") then ---leader should always be the fist keymap
    lhs = (lhs:gsub("^<leader>", ""))
    mods[#mods + 1] = "LEADER"
  end
  return lhs
end

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
---**Example usage*+
---
---~~~lua
---local keymaps = {}
---M.key.map("<leader>a", wezterm.action.ActivateTab(1), keymaps)
---M.key.map("<C-a>", wezterm.action.ActivateTab(2), keymaps)
---M.key.map("b", wezterm.action.SendString("hello"), keymaps)
---~~~
M.key.map = function(lhs, rhs, tbl)
  local log = Logger:new "key.map()"
  M.key.__check(log, lhs, rhs, tbl)

  ---Inserts the given keymap in the table
  ---@param mods? table modifiers. defaults to `""`
  ---@param key string key to press.
  local function __map(key, mods)
    tbl[#tbl + 1] = { key = key, mods = table.concat(mods or {}, "|"), action = rhs }
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

  lhs = lhs:gsub("(%b<>)", function(str)
    return str:sub(2, -2)
  end)

  local keys = M.str.split(lhs, "%-")

  if #keys == 1 then
    return __map(aliases[keys[1]] or keys[1], mods)
  end

  local k = keys[#keys]
  if modifiers[k] then
    return log:error "keymap cannot end with modifier!"
  else
    keys[#keys] = nil
  end
  k = aliases[k] or k

  for i = 1, #keys do
    mods[#mods + 1] = modifiers[keys[i]]
  end

  return __map(k, mods)
end

-- }}}

-- {{{1 Utils.Fn.Color

---@class Utils.Fn.Color
M.color = {}

---Retrieves all the customs colorschemes
---@return table schemes Full colorschemes table
M.color.get_schemes = function()
  local schemes = {}

  local dir = M.fs.pathconcat(wt.config_dir, "picker", "assets", "colorschemes")
  local files = M.fs.read_dir(dir)
  if not files then
    return wt.log_error(
      ("Unable to read from directory: '%s'"):format(M.fs.basename(dir))
    )
  end

  for i = 1, #files do
    local name = M.fs.basename(files[i]:gsub("%.lua$", ""))
    schemes[name] = require("picker.assets.colorschemes." .. name).scheme
  end
  return schemes
end

---Returns the colorscheme name absed on the system appearance
---@return '"kanagawa-wave"'|'"kanagawa-lotus"' colorscheme name of the colorscheme
M.color.get_scheme = function()
  if (wt.gui and wt.gui.get_appearance() or ""):find "Dark" then
    return "kanagawa-wave"
  end
  return "kanagawa-lotus"
end

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
---M.color.set_tab_button(config, theme)
---~~~
---
---@param config table The configuration object to be updated with tab button styles.
---@param theme table The theme object containing color schemes for different tab states.
M.color.set_tab_button = function(config, theme)
  config.tab_bar_style = {}
  local sep = require("utils.class.icon").Sep.tb

  for _, state in ipairs { "new_tab", "new_tab_hover" } do
    local style = theme.tab_bar[state]
    local sep_bg, sep_fg = style.bg_color, theme.tab_bar.background

    local ButtonLayout = require("utils.class.layout"):new()
    local attributes = {
      style.intensity
        or (style.italic and "Italic")
        or (style.strikethrough and "Strikethrough")
        or (style.underline ~= "None" and style.underline),
    }

    ButtonLayout:push(sep_bg, sep_fg, sep.right, attributes)
    ButtonLayout:push(sep_bg, style.fg_color, " + ", attributes)
    ButtonLayout:push(sep_bg, sep_fg, sep.left, attributes)

    config.tab_bar_style[state] = ButtonLayout:format()
  end
end

M.color.set_scheme = function(Config, theme, name)
  Config.color_scheme = name
  Config.char_select_bg_color = theme.brights[6]
  Config.char_select_fg_color = theme.background
  Config.command_palette_bg_color = theme.brights[6]
  Config.command_palette_fg_color = theme.background
  Config.background = {
    { source = { Color = theme.background }, width = "100%", height = "100%" },
  }
  M.color.set_tab_button(Config, theme)
end

-- }}}

return M

-- vim: fdm=marker fdl=0

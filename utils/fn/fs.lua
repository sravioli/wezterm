---@module 'utils.fn.fs'

local cache = require "utils.fn.cache" ---@class Fn.Cache
local str = require "utils.fn.str" ---@class Fn.String

local ioclose, ioopen = io.close, io.open
local oexec, ogetenv = os.execute, os.getenv
local tconcat = table.concat

local schar, sfind, sformat, sgsub, smatch, ssub =
  string.char, string.find, string.format, string.gsub, string.match, string.sub

local wt = require "wezterm" ---@class Wezterm

local wt_home, wt_hostname, wt_triple = wt.home, wt.hostname, wt.target_triple

---@class Fn.FileSystem
---@field log             Logger  Logger instance.
---@field target_triple   string  WezTerm target triple string.
---@field is_win          boolean Static boolean indicating if running on Windows.
---@field path_separator  string  Platform-specific path separator (`\` or `/`).
local M = {}

---@package
---
---Class logger
M.log = require("utils.logger"):new "Fn.FileSystem"

---@package
M.target_triple = cache.memoize("fs.target-triple", wt_triple)

---Get platform information.
---
---Identifies OS based on target triple. Memoized for performance.
---
---@return Fn.FileSystem.Platform platform Platform details (OS name, boolean flags).
M.platform = cache.memoize("fs.platform", function()
  local is_win = sfind(M.target_triple, "windows") ~= nil
  local is_linux = sfind(M.target_triple, "linux") ~= nil
  local is_mac = sfind(M.target_triple, "apple") ~= nil
  local os = is_win and "windows" or is_linux and "linux" or is_mac and "mac" or "unknown"
  return { os = os, is_win = is_win, is_linux = is_linux, is_mac = is_mac }
end)

M.is_win = cache.memoize("fs.is-win", M.platform().is_win)

---Get user home directory.
---
---Resolves via `USERPROFILE`, `HOME`, or WezTerm API. Normalizes backslashes to forward
---slashes.
---
---@return string home Normalized home directory path.
M.home = cache.memoize("fs.home", function()
  return (sgsub((ogetenv "USERPROFILE" or ogetenv "HOME" or wt_home or ""), "\\", "/"))
end)

M.path_separator = cache.memoize("fs.path-separator", M.is_win and "\\" or "/")

---Extract base name from path.
---
---Equivalent to POSIX `basename(3)`. Returns the final component of the path.
---Uses a simple direct-lookup cache to avoid generic cache machinery overhead.
---
---@param path string File path.
---@return string basename Final component of the path.
local _basename_cache = {}
M.basename = function(path)
  local cached = _basename_cache[path]
  if cached then
    return cached
  end
  local trimmed_path = sgsub(path, "[/\\]*$", "")
  local index = sfind(trimmed_path, "[^/\\]*$")
  local result = index and ssub(trimmed_path, index) or trimmed_path
  _basename_cache[path] = result
  return result
end

---Find git project root.
---
---Traverses up the directory tree looking for a `.git` directory.
---
---@param directory string Starting directory path.
---@return string|nil git_root Root directory of the git repo, or nil if not found.
M.find_git_dir = function(directory)
  return cache.compute_cached("fs.find-git-dir", function()
    directory = sgsub(directory, "~", M.home())
    while directory do
      local handle = ioopen(directory .. "/.git/HEAD", "r")
      if handle then
        ioclose(handle)
        return (directory:gsub(M.home(), "~"))
      elseif directory == "/" or directory == "" then
        break
      else
        directory = smatch(directory, "(.+)/[^/]*")
      end
    end

    return nil
  end, directory)
end

---Get the hostname associated with the given pane.
---
---Parses the pane's current working directory URI to extract the host field.
---Falls back to `wezterm.hostname()` when the URI carries no host information.
---Strips any domain suffix and title-cases the result.
---
---@param  pane Pane WezTerm pane object.
---@return string hostname
M.get_hostname = function(pane)
  local hostname = ""
  local cwd_uri = pane:get_current_working_dir()

  if cwd_uri then
    if type(cwd_uri) == "userdata" then
      hostname = cwd_uri.host or wt_hostname() ---@diagnostic disable-line: undefined-field
    else
      local uri = ssub(cwd_uri, 8)
      local slash = sfind(uri, "/")
      if slash then
        hostname = ssub(uri, 1, slash - 1)
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

  return hostname
end

---Get the current working directory from the given pane.
---
---Parses the pane's current working directory URI.
---Normalises the home directory to `~`.
---Optionally resolves the git root instead of the literal CWD.
---
---@param  pane                    Pane    WezTerm pane object.
---@param  search_git_root_instead boolean If true, returns git root instead of CWD.
---@return string cwd
M.get_cwd = function(pane, search_git_root_instead)
  local cwd = ""
  local cwd_uri = pane:get_current_working_dir()

  if cwd_uri then
    if type(cwd_uri) == "userdata" then
      cwd = cwd_uri.file_path ---@diagnostic disable-line: undefined-field
    else
      local uri = ssub(cwd_uri, 8)
      local slash = sfind(uri, "/")
      if slash then
        cwd = ssub(uri, slash)
        cwd = sgsub(cwd, "%%(%x%x)", function(hex)
          return schar(tonumber(hex, 16))
        end)
      end
    end
  end

  if M.is_win then
    cwd = sgsub(cwd, "/" .. M.home() .. "(.-)$", "~%1")
  else
    cwd = sgsub(cwd, M.home() .. "(.-)$", "~%1")
  end

  if search_git_root_instead then
    local git_root = M.find_git_dir(cwd)
    cwd = git_root or cwd
  end

  return cwd
end

---@deprecated Use `get_cwd` and `get_hostname` separately.
---Kept for backwards compatibility; delegates to the two focused functions.
---
---@param  pane                    Pane    WezTerm pane object.
---@param  search_git_root_instead boolean If true, returns git root instead of CWD.
---@return string cwd
---@return string hostname
M.get_cwd_hostname = function(pane, search_git_root_instead)
  return M.get_cwd(pane, search_git_root_instead), M.get_hostname(pane)
end

---Abbreviate path by shortening intermediate components to specified length.
---
---Useful for creating compact path representations while preserving full component names
---for the final directory.
---
---@param path string File or directory path.
---@param len integer  Number of characters to keep per component.
---@return string shortened Abbreviated path.
M.shorten_path = function(path, len)
  -- key must include both arguments so different inputs don't collide
  return cache.compute_cached("fs.shorten_path", function()
    local sep = M.path_separator
    local root_path = path:sub(1, 1) == sep
    if root_path then
      path = path:sub(2)
    end

    local parts = str.split(path, sep)
    local last = #parts
    local result = {}

    for i = 1, last do
      local part = parts[i]
      if i == last then
        result[i] = part
      else
        local short = ssub(part, 1, len)
        if short == "" then
          break
        end
        result[i] = short
      end
    end

    local short_path = table.concat(result, sep)
    if root_path then
      short_path = sep .. short_path
    end
    return short_path
  end, path, len) -- path and len are the cache key discriminators
end

--- Keep n chars from each end with an ellipsis in the middle.
--- n is always the largest value that fits the budget, maximising readability.
---
---@param s      string
---@param budget integer  available columns
---@return string
local function truncate_middle(s, budget)
  if str.column_width(s) <= budget then
    return s
  end

  local ellipsis = "…"
  local ew = str.column_width(ellipsis)
  if budget <= ew then
    return ellipsis
  end

  local remaining = budget - ew
  local left_n = math.ceil(remaining / 2)
  local right_n = math.floor(remaining / 2)

  local left = wt.truncate_right(s, left_n)

  -- Collect codepoints so we can take exactly right_n columns from the end
  local cps = {}
  for cp in s:gmatch "[^\128-\191][\128-\191]*" do
    cps[#cps + 1] = cp
  end

  local right_parts, w = {}, 0
  for i = #cps, 1, -1 do
    local cpw = wt.column_width(cps[i])
    if w + cpw > right_n then
      break
    end
    table.insert(right_parts, 1, cps[i])
    w = w + cpw
  end

  return left .. ellipsis .. table.concat(right_parts)
end

M.shorten_path_to_fit = function(path, max_len)
  local sep = M.path_separator
  path = path:gsub("/+$", "")

  local last = path:match "([^/]+)$" or path
  local last_w = str.column_width(last)
  local prefix = path:sub(1, -(#last + 1)) -- everything up to and including the final sep

  local _, sep_count = path:gsub(sep, "")
  local is_rooted = path:sub(1, 1) == sep
  local dir_count = is_rooted and (sep_count - 1) or sep_count
  local sep_w = sep_count * str.column_width(sep)

  -- No directory prefix: middle-truncate the bare name
  if dir_count <= 0 then
    return truncate_middle(last, max_len)
  end

  -- Happy path: last component fits in full; shorten dir components as needed
  local dir_budget = max_len - sep_w - last_w
  if dir_budget >= dir_count then -- at least 1 col per dir component
    local per = math.floor(dir_budget / dir_count)
    return M.shorten_path(path, per)
  end

  -- Dirs at minimum (1 char each); give the rest to the last component via
  -- middle-truncation so the path shape is preserved and stays readable.
  local last_budget = math.max(3, max_len - sep_w - dir_count)
  local truncated_last = truncate_middle(last, last_budget)
  return M.shorten_path(prefix .. truncated_last, 1)
end

---Concatenate path components.
---
---Joins arguments using the platform-specific path separator.
---
---@param ... string Path components to join.
---@return string path Joined path string.
M.join_path = function(...)
  return tconcat({ ... }, M.path_separator)
end

return M

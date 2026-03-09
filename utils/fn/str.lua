local sfind, sformat, sgsub, ssub, srep =
  string.find, string.format, string.gsub, string.sub, string.rep

local tremove, tinsert, tconcat = table.remove, table.insert, table.concat

local cache = require "utils.fn.cache" ---@class Fn.Cache
local wt = require "wezterm" ---@class Wezterm

---@class Fn.String
local M = {}

M.width = require("wezterm").column_width

---Pad string on both sides.
---
---Converts input to string if necessary and adds specified amount of whitespace
---to both left and right sides.
---
---@param s       string|any         Input value to pad.
---@param padding (integer|table)?   Number of spaces to add per side. Defaults to 1.
---@return string padded Resulting padded string.
M.pad = function(s, padding)
  s = type(s) ~= "string" and tostring(s) or s
  if type(padding) == "table" then
    return M.padd(s, padding)
  else
    padding = padding or 0

    local pad = srep(" ", padding)
    return sformat("%s%s%s", pad, s, pad)
  end
end

---Pad string on both sides.
---
---Converts input to string if necessary and adds specified amount of whitespace
---
---@param s       string|any                       Input value to pad.
---@param padding {left: number?, right: number?}? Number of spaces to add per side.
---@return string padded Resulting padded string.
M.padd = function(s, padding)
  s = type(s) ~= "string" and tostring(s) or s
  padding = padding or { left = 0, right = 0 }
  padding.left = padding.left or 0
  padding.right = padding.right or 0

  local l = srep(" ", padding.left)
  local r = srep(" ", padding.right)

  return sformat("%s%s%s", l, s, r)
end

---Pad string on left side.
---
---@param s       string|any Input value to pad.
---@param padding integer?   Number of spaces to add. Defaults to 1.
---@return string padded     Resulting left-padded string.
M.padl = function(s, padding)
  s = type(s) ~= "string" and tostring(s) or s
  padding = padding or 1

  local pad = srep(" ", padding)
  return sformat("%s%s", pad, s)
end

---Pad string on right side.
---
---@param s       string|any Input value to pad.
---@param padding integer?   Number of spaces to add. Defaults to 1.
---@return string padded     Resulting right-padded string.
M.padr = function(s, padding)
  s = type(s) ~= "string" and tostring(s) or s
  padding = padding or 1

  local pad = srep(" ", padding)
  return sformat("%s%s", s, pad)
end

---Remove leading and trailing whitespace.
---
---@param s string Input string.
---@return string trimmed Trimmed string.
M.trim = function(s)
  return (sgsub(s, "^%s*(.-)%s*$", "%1"))
end

---Iterate over substrings separated by pattern.
---
---Returns iterator yielding substrings from input `s` separated by `sep`.
---
---@param s     string          Input string to split.
---@param sep   string          Separator pattern.
---@param opts? SplitOpts|table Optional splitting behavior.
---@return fun(): string|nil iterator Iterator returning next substring or nil.
M.gsplit = function(s, sep, opts)
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
end

---Split string into list of substrings.
---
---Uses `gsplit` internally and caches the result.
---
---@param s     string          Input string to split.
---@param sep   string          Separator pattern.
---@param opts? SplitOpts|table Optional splitting behavior.
---@return string[] parts       List of substrings.
M.split = function(s, sep, opts)
  return cache.compute_cached("str.split", function()
    local t = {}
    for c in M.gsplit(s, sep, opts) do
      t[#t + 1] = c
    end
    return t
  end, s, sep, opts)
end

---Strip ANSI/VT escape sequences from a string.
---@param s string raw rendered string, may contain ANSI colour codes
---@return string s
M.strip_ansi = function(s)
  return (s:gsub("\27%[[\32-\63]*[\64-\126]", ""))
end

---Calculate visible string width.
---
---Strips any ANSI escape sequences (otherwise they would contribute to the width) and then
---call the WezTerm internal `column_width()` function.
---
---@param s string input string
---@return number column_width
M.column_width = function(s)
  return wt.column_width(M.strip_ansi(s))
end

---@alias TruncateMode "left" | "right" | "middle"

-- local ELLIPSIS = "…"
local ELLIPSIS = require("utils.icons").Ellipsis
local ELLIPSIS_W = M.column_width(ELLIPSIS)

--- Take up to `budget` visible columns from the *left* of `s`.
--- No ellipsis is added.
---@param  s      string
---@param  budget integer
---@return string
---@return integer columns consumed
local function take_left(s, budget)
  local parts, w = {}, 0
  for cp in s:gmatch "[^\128-\191][\128-\191]*" do
    local cpw = M.column_width(cp)
    if w + cpw > budget then
      break
    end
    parts[#parts + 1] = cp
    w = w + cpw
  end
  return tconcat(parts), w
end

--- Take up to `budget` visible columns from the *right* of `s`.
--- No ellipsis is added.
---@param  s      string
---@param  budget integer
---@return string
---@return integer columns consumed
local function take_right(s, budget)
  local cps = {}
  for cp in s:gmatch "[^\128-\191][\128-\191]*" do
    cps[#cps + 1] = cp
  end

  local parts, w = {}, 0
  for i = #cps, 1, -1 do
    local cpw = M.column_width(cps[i])
    if w + cpw > budget then
      break
    end
    tinsert(parts, 1, cps[i])
    w = w + cpw
  end
  return tconcat(parts), w
end

---Return whether `s` already fits within `budget` visible columns.
---
---@param  s      string
---@param  budget integer
---@return boolean
M.fits = function(s, budget)
  return M.column_width(s) <= budget
end

---Truncate from the **right**, appending an ellipsis.
---`"plasma-csd-generator.rebupk"` → `"plasma-csd-gen…"`
---
---@param  s      string
---@param  budget integer  total columns available (including the ellipsis)
---@return string
M.truncate_right = function(s, budget)
  if M.fits(s, budget) then
    return s
  end
  if budget <= ELLIPSIS_W then
    return ELLIPSIS
  end
  return take_left(s, budget - ELLIPSIS_W) .. ELLIPSIS
end

---Truncate from the **left**, prepending an ellipsis.
---`"plasma-csd-generator.rebupk"` → `"…ator.rebupk"`
---
---@param  s      string
---@param  budget integer  total columns available (including the ellipsis)
---@return string
M.truncate_left = function(s, budget)
  if M.fits(s, budget) then
    return s
  end
  if budget <= ELLIPSIS_W then
    return ELLIPSIS
  end
  return ELLIPSIS .. take_right(s, budget - ELLIPSIS_W)
end

---Truncate from the **middle**, keeping both ends readable.
---The left side gets the extra column when the budget is odd.
---`"plasma-csd-generator.rebupk"` → `"plasma-c…rebupk"`
---
---@param  s      string
---@param  budget integer  total columns available (including the ellipsis)
---@return string
M.truncate_middle = function(s, budget)
  if M.fits(s, budget) then
    return s
  end
  if budget <= ELLIPSIS_W then
    return ELLIPSIS
  end

  local remaining = budget - ELLIPSIS_W
  local left_n = math.ceil(remaining / 2)
  local right_n = math.floor(remaining / 2)

  return take_left(s, left_n) .. ELLIPSIS .. take_right(s, right_n)
end

---Truncate `s` to fit within `budget` columns using the specified strategy.
---
---@param  s      string
---@param  budget integer
---@param  mode   TruncateMode
---@return string
M.truncate = function(s, budget, mode)
  if mode == "left" then
    return M.truncate_left(s, budget)
  end
  if mode == "middle" then
    return M.truncate_middle(s, budget)
  end
  return M.truncate_right(s, budget)
end

return M

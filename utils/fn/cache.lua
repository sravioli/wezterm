---@module 'utils.fn.cache'

local Logger = require "utils.logger" --- @class Logger
local wt = require "wezterm" --- @class Wezterm

-- selene: allow(incorrect_standard_library_use)
local tconcat, tinsert, tunpack = table.concat, table.insert, table.unpack or unpack

---@class Fn.Cache
---@field log Logger Logger instance for cache operations.
local M = {}
M.log = Logger:new "Fn.Cache"

--~ {{{1 private functions

-- Normalize a cache key into an array of path segments
---@param key CacheKey
---@return string[]|nil
local function normalize_key(key)
  local tkey = type(key)
  if tkey == "table" then
    return key
  end
  if tkey == "string" then
    local path = {}
    for part in key:gmatch "[^%.]+" do
      tinsert(path, part)
    end
    return path
  end
  return M.log:error "cache key must be string or table"
end

-- Flatten a key path to a dot-separated string
---@param path string[]|nil
---@return string
local function flatten_key(path)
  return tconcat(path or {}, ".")
end

-- Serialize a value for deterministic cache keys (cycle-safe)
---@param v any
---@param seen table<any, boolean>|nil
---@return string
local function stable_hash(v, seen)
  seen = seen or {}
  local t = type(v)

  if t == "nil" then
    return "nil"
  elseif t == "boolean" then
    return v and "b:true" or "b:false"
  elseif t == "number" then
    return "n:" .. v
  elseif t == "string" then
    return "s:" .. v
  elseif t == "function" then
    return "f:" .. tostring(v)
  elseif t == "thread" then
    return "thread:" .. tostring(v)
  elseif t == "userdata" then
    return "ud:" .. tostring(v)
  end

  if t == "table" then
    if seen[v] then
      return "t:cycle"
    end
    seen[v] = true

    local out, keys = {}, {}
    for k in pairs(v) do
      tinsert(keys, k)
    end
    table.sort(keys, function(a, b)
      return tostring(a) < tostring(b)
    end)

    for i = 1, #keys do
      local k = keys[i]
      out[i] = stable_hash(k, seen) .. "=" .. stable_hash(v[k], seen)
    end
    return "t:{" .. tconcat(out, ",") .. "}"
  end

  return t .. ":" .. tostring(v)
end

-- Generate a unique cache key from a name and parameters
---@param name string
---@param ... any
---@return string
local function make_cache_key(name, ...)
  local n = select("#", ...)

  -- Fast path: all args are strings or numbers (the common case)
  local all_simple = true
  for i = 1, n do
    local t = type(select(i, ...))
    if t ~= "string" and t ~= "number" then
      all_simple = false
      break
    end
  end

  if all_simple then
    local parts = { name }
    for i = 1, n do
      parts[#parts + 1] = tostring(select(i, ...))
    end
    return tconcat(parts, "|")
  end

  -- Slow path: full serialisation for tables/functions
  local parts = { name }
  for i = 1, n do
    tinsert(parts, stable_hash(select(i, ...)))
  end
  return tconcat(parts, "|")
end
--~ }}}

---Ensure table structure exists in `wt.GLOBAL`.
---
---Recursively merges the template into the global table at the specified key.
---
---@param key      string Top-level key in `wt.GLOBAL`.
---@param template table  Table defining required subtables/fields.
---@return table result Initialized table reference.
M.ensure_global_tbl = function(key, template)
  wt.GLOBAL[key] = wt.GLOBAL[key] or {}
  local t = wt.GLOBAL[key]

  local function fill(target, tpl)
    for k, v in pairs(tpl) do
      if type(v) == "table" then
        target[k] = target[k] or {}
        fill(target[k], v)
      else
        target[k] = target[k] or v
      end
    end
  end

  fill(t, template)
  return t
end

local CACHE = M.ensure_global_tbl("__cache", {})

---Memoize value or function result.
---
---If `value` is a function, returns a wrapper that caches the result of the function call.
---If `value` is data, stores it directly in the cache and returns it.
---
---@param key   CacheKey                Key for storing/retrieving value.
---@param value any|fun(...: any): any  Value or function to cache.
---@return any|fun(...: any): any cached Cached value or memoized function wrapper.
function M.memoize(key, value)
  local path = normalize_key(key)
  local flat_key = flatten_key(path)

  local function set_entry(val)
    CACHE[flat_key] = val
    return val
  end

  local function get_entry()
    return M.get(flat_key)
  end

  if type(value) == "function" then
    return function(...)
      local cached = get_entry()
      if cached ~= nil then
        return cached
      end
      local ok, res = pcall(value, ...)
      if not ok then
        error(res)
      end
      return set_entry(res)
    end
  else
    if value ~= nil then
      set_entry(value)
    end
    return get_entry()
  end
end

---Execute function and cache result using argument-based key.
---
---Generates a unique key from `name` + serialised arguments, checks the cache
---first, and only executes the function on a miss.  Previous implementation
---always evaluated `fn(...)` before consulting the cache — defeating the
---purpose entirely.
---
---@param name string              Namespace or context identifier for the key.
---@param fn   fun(...: any): any  Function to execute.
---@param ...  any                 Arguments passed to the function.
---@return any result              Cached or freshly computed result.
function M.compute_cached(name, fn, ...)
  local key = make_cache_key(name, ...)
  local flat = flatten_key(normalize_key(key))
  local cached = CACHE[flat]
  if cached ~= nil then
    return cached
  end
  local ok, res = pcall(fn, ...)
  if not ok then
    error(res)
  end
  CACHE[flat] = res
  return res
end

---Retrieve cached value by key.
---
---@param key CacheKey Key to look up.
---@return any value Cached value or nil.
function M.get(key)
  local flat_key = flatten_key(normalize_key(key))
  return CACHE[flat_key]
end

---Delete cached value by key.
---
---@param key CacheKey Key to remove.
function M.delete(key)
  local flat_key = flatten_key(normalize_key(key))
  CACHE[flat_key] = nil
end

---Clear all cached entries.
function M.clear()
  for k in pairs(CACHE) do
    CACHE[k] = nil
  end
  wt.GLOBAL.__cache = nil
  CACHE = nil
  CACHE = M.ensure_global_tbl("__cache", {})
end

---Forget specific key or clear entire cache.
---
---@param key? CacheKey Key to delete. If nil, clears entire cache.
function M.forget(key)
  if key then
    M.delete(key)
  else
    M.clear()
  end
end

---Check if cache entry exists for given key.
---
---@param key CacheKey Key to check.
---@return boolean exists True if key exists in cache.
function M.has(key)
  return M.get(key) ~= nil
end

return M

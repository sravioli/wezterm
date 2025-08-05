---@module "utils.perf"
---@author sravioli
---@license GNU-GPLv3

---Performance optimization utilities for WezTerm configuration

local wt = require "wezterm"

---@class Utils.Perf
local M = {}

-- Initialize cache if not present
if not wt.GLOBAL.cache then
  wt.GLOBAL.cache = {}
end
if not wt.GLOBAL.cache.perf then
  wt.GLOBAL.cache.perf = {}
end

local CACHE = wt.GLOBAL.cache.perf

---Debounce function calls to reduce frequency
---@param func function function to debounce
---@param delay number delay in milliseconds
---@return function debounced_func
M.debounce = function(func, delay)
  local timer_id = nil
  return function(...)
    local args = { ... }
    if timer_id then
      wt.timer.cancel(timer_id)
    end
    timer_id = wt.timer.call_after(delay / 1000, function()
      func(unpack(args))
      timer_id = nil
    end)
  end
end

---Throttle function calls to limit frequency
---@param func function function to throttle
---@param interval number minimum interval between calls in milliseconds
---@return function throttled_func
M.throttle = function(func, interval)
  local last_call = 0
  return function(...)
    local now = wt.time.now()
    -- Convert Time object to milliseconds since epoch
    local now_ms = now:format("%s") * 1000
    if now_ms - last_call >= interval then
      last_call = now_ms
      return func(...)
    end
  end
end

---Cache expensive computations with TTL
---@param key string cache key
---@param compute_fn function function to compute value
---@param ttl? number time to live in seconds (default: 60)
---@return any cached_value
M.cached_compute = function(key, compute_fn, ttl)
  ttl = ttl or 60
  local now = wt.time.now()
  -- Convert Time object to seconds since epoch
  local now_seconds = tonumber(now:format("%s"))
  local cached = CACHE[key]

  if cached and (now_seconds - cached.timestamp) < ttl then
    return cached.value
  end

  local value = compute_fn()
  CACHE[key] = {
    value = value,
    timestamp = now_seconds
  }

  return value
end

---Lazy loader for expensive modules
---@param module_path string path to module
---@return function loader_function
M.lazy_require = function(module_path)
  local module = nil
  return function()
    if not module then
      module = require(module_path)
    end
    return module
  end
end

---Batch operations to reduce function call overhead
---@param operations table list of operations to batch
---@param batch_size? number size of each batch (default: 10)
---@return function batch_processor
M.batch_process = function(operations, batch_size)
  batch_size = batch_size or 10
  local index = 1

  return function()
    local batch = {}
    for i = index, math.min(index + batch_size - 1, #operations) do
      batch[#batch + 1] = operations[i]
    end
    index = index + batch_size
    return batch, index <= #operations
  end
end

---Clear performance cache
---@param pattern? string optional pattern to match keys for selective clearing
M.clear_cache = function(pattern)
  if pattern then
    for key in pairs(CACHE) do
      if key:match(pattern) then
        CACHE[key] = nil
      end
    end
  else
    CACHE = {}
    wt.GLOBAL.cache.perf = CACHE
  end
end

---Get cache statistics
---@return table stats cache statistics
M.get_cache_stats = function()
  local count = 0
  local memory_estimate = 0

  for key, value in pairs(CACHE) do
    count = count + 1
    -- Rough memory estimation
    memory_estimate = memory_estimate + #key + (type(value) == "string" and #value or 100)
  end

  return {
    entries = count,
    estimated_memory_kb = math.ceil(memory_estimate / 1024)
  }
end

return M

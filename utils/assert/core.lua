---@module 'utils.assert'

---@class Assert
local M = {}

---Create new assertion utility instance.
---
---Initialize assertion groups and configure error handling behavior based on provided options.
---
---@param config? Assert.Config Configuration options.
---@return Assert assert Configured assertion utility instance.
function M.new(config)
  config = config or {}

  local self = setmetatable({}, { __index = M })
  self._errors = {}
  self._config = config
  self._accumulate = config.accumulate or false
  self._fail_fast = config.fail_fast or false
  self._has_failed = false
  self._type_cache = config.cache_type_checks and {} or nil
  self._stats = config.metrics
      and {
        total = 0,
        passed = 0,
        failed = 0,
        by_group = {},
      }
    or nil

  self._handler = config.handler
    or {
      handle = function(message, level)
        error(message, level + 1)
      end,
    }

  -- Initialize assertion groups
  self.cmp = setmetatable({}, { __index = M._cmp })
  self.nul = setmetatable({}, { __index = M._nul })
  self.type = setmetatable({}, { __index = M._type })
  self.tbl = setmetatable({}, { __index = M._tbl })
  self.num = setmetatable({}, { __index = M._num })
  self.str = setmetatable({}, { __index = M._str })

  -- Store reference to parent for nested calls
  self.cmp._parent = self
  self.cmp._group = "cmp"
  self.nul._parent = self
  self.nul._group = "nul"
  self.type._parent = self
  self.type._group = "type"
  self.tbl._parent = self
  self.tbl._group = "tbl"
  self.num._parent = self
  self.num._group = "num"
  self.str._parent = self
  self.str._group = "str"

  return self
end

---Create value holder for chained assertions.
---
---Enable assertion chaining without repeating the value parameter. Lazily initialize
---assertion group proxies when accessed to minimize overhead.
---
---@param value any Value to validate.
---@return Assert.Value holder Value holder with assertion methods.
---
---### Example
---~~~lua
---assert:that(email).str
---  :not_empty()
---  :matches("@")
---  :min_length(5)
---~~~
function M:that(value)
  local holder = { value = value, parent = self }

  setmetatable(holder, {
    __index = function(t, key)
      -- Only create group proxies when accessed
      if
        key == "str"
        or key == "num"
        or key == "tbl"
        or key == "type"
        or key == "nul"
        or key == "cmp"
      then
        local proxy = setmetatable({ _value = value, _parent = self, _group = key }, {
          __index = function(p, method)
            return function(_, ...)
              M["_" .. key][method](p, p._value, ...)
              return p
            end
          end,
        })
        rawset(t, key, proxy)
        return proxy
      end
      return rawget(t, key)
    end,
  })

  return holder
end

---Format error message with all configured options.
---
---Apply prefix, context, group labels, stack traces, and message length truncation
---based on configuration.
---
---@param message string Raw error message.
---@param group? string Assertion group name.
---@return string formatted Formatted error message.
function M:_format_message(message, group)
  local config = self._config
  local formatted = message

  -- Add prefix
  if config.prefix then
    formatted = config.prefix .. formatted
  end

  -- Add context
  if config.context then
    local ctx = type(config.context) == "string" and config.context
      or string.format("[%s]", table.concat(config.context, ", "))
    formatted = ctx .. " " .. formatted
  end

  -- Add group if enabled
  if config.group_errors and group then
    formatted = string.format("[%s] %s", group, formatted)
  end

  -- Add stack trace
  if config.show_stack_trace then
    local trace = debug.traceback("", 4)
    formatted = formatted .. "\n" .. trace
  end

  -- Truncate if needed
  if config.max_message_length and #formatted > config.max_message_length then
    formatted = formatted:sub(1, config.max_message_length) .. "..."
  end

  return formatted
end

---Update metrics if enabled.
---
---Track assertion pass/fail counts globally and per assertion group. Invoke external
---metrics recorder if configured.
---
---@param passed boolean Whether assertion passed.
---@param group? string Assertion group name.
function M:_update_metrics(passed, group)
  if not self._stats then
    return
  end

  self._stats.total = self._stats.total + 1

  if passed then
    self._stats.passed = self._stats.passed + 1
  else
    self._stats.failed = self._stats.failed + 1
  end

  if group then
    self._stats.by_group[group] = self._stats.by_group[group]
      or { passed = 0, failed = 0 }
    if passed then
      self._stats.by_group[group].passed = self._stats.by_group[group].passed + 1
    else
      self._stats.by_group[group].failed = self._stats.by_group[group].failed + 1
    end
  end

  if self._config.metrics and self._config.metrics.record then
    self._config.metrics.record(passed and "assertion_passed" or "assertion_failed")
  end
end

---Internal assertion handler.
---
---Core assertion logic handling condition evaluation, error formatting, metrics tracking,
---and error handling strategy (immediate, accumulate, silent, etc.).
---
---@param condition boolean Condition to check.
---@param message string Error message if condition fails.
---@param level? number Stack level for error reporting (default: 2).
---@param group? string Assertion group name.
---@return boolean condition Condition value (pass-through).
function M:_check(condition, message, level, group)
  level = level or 2

  -- Lazy eval: skip if already failed
  if self._config.lazy_eval and self._has_failed then
    return condition
  end

  -- Update metrics
  self:_update_metrics(condition, group)

  if not condition then
    self._has_failed = true

    local formatted = self:_format_message(message, group)

    -- Create error object
    local err = {
      message = formatted,
      level = level,
      group = group,
      timestamp = os.time(),
    }

    -- Custom formatter
    if self._config.format_error then
      err.message = self._config.format_error.format(err, self._config)
    end

    -- On error callback
    if self._config.on_error then
      self._config.on_error(err)
    end

    -- Logger integration
    if self._config.logger and self._config.logger.error then
      self._config.logger.error(err.message)
    end

    -- Silent mode: track but don't call handler
    if self._config.silent then
      table.insert(self._errors, err)
      return condition
    end

    -- Strict mode: always error
    if self._config.strict_mode then
      error(err.message, level + 1)
    end

    -- Accumulate mode
    if self._accumulate then
      table.insert(self._errors, err)

      -- Fail fast in accumulate mode
      if self._fail_fast then
        self:throw()
      end
    else
      self._handler.handle(err.message, level)
    end
  end

  return condition
end

---Get cached type or compute and cache it.
---
---Use tostring as cache key for performance. Only active when cache_type_checks is enabled.
---
---@param value any Value to get type of.
---@return string type_name Type name.
function M:_get_type(value)
  if not self._type_cache then
    return type(value)
  end

  -- Use tostring as cache key (not perfect but fast)
  local key = tostring(value)
  if not self._type_cache[key] then
    self._type_cache[key] = type(value)
  end

  return self._type_cache[key]
end

---Throw all accumulated errors.
---
---Concatenate all error messages and invoke handler. Clear error list after throwing.
---No-op if no errors accumulated.
function M:throw()
  if #self._errors == 0 then
    return
  end

  local messages = {}
  for i = 1, #self._errors do
    messages[i] = self._errors[i].message
  end

  local combined = table.concat(messages, "\n")
  self._errors = {}
  self._handler.handle(combined, 2)
end

---Clear accumulated errors without throwing.
---
---Reset error list and failed state flag.
function M:clear()
  self._errors = {}
  self._has_failed = false
end

---Get accumulated error count.
---
---@return number count Number of accumulated errors.
function M:count()
  return #self._errors
end

---Get accumulated errors.
---
---@return Assert.Error[] errors List of error objects with messages, levels, and metadata.
function M:get_errors()
  return self._errors
end

---Get assertion statistics.
---
---@return table? stats Statistics table with total, passed, failed counts and per-group breakdown, or nil if metrics disabled.
function M:get_stats()
  return self._stats
end

-- Comparison Assertions
M._cmp = {}

---Assert values are equal.
---
---@param actual any Actual value.
---@param expected any Expected value.
---@param message? string Custom error message.
---@return boolean result True if values are equal.
function M._cmp:equal(actual, expected, message)
  message = message
    or string.format("Expected %s, got: %s", tostring(expected), tostring(actual))
  return self._parent:_check(actual == expected, message, 3, self._group)
end

---Assert values are not equal.
---
---@param actual any Actual value.
---@param expected any Value that should differ.
---@param message? string Custom error message.
---@return boolean result True if values differ.
function M._cmp:not_equal(actual, expected, message)
  message = message
    or string.format("Expected value different from: %s", tostring(expected))
  return self._parent:_check(actual ~= expected, message, 3, self._group)
end

---Assert value is truthy.
---
---@param value any Value to check.
---@param message? string Custom error message.
---@return boolean result True if value is truthy.
function M._cmp:truthy(value, message)
  message = message or string.format("Expected truthy value, got: %s", tostring(value))
  return self._parent:_check(not not value, message, 3, self._group)
end

---Assert value is falsy.
---
---@param value any Value to check.
---@param message? string Custom error message.
---@return boolean result True if value is falsy.
function M._cmp:falsy(value, message)
  message = message or string.format("Expected falsy value, got: %s", tostring(value))
  return self._parent:_check(not value, message, 3, self._group)
end

-- Nil Check Assertions
M._nul = {}

---Assert value is nil.
---
---@param value any Value to check.
---@param message? string Custom error message.
---@return boolean result True if value is nil.
function M._nul:is_nil(value, message)
  message = message or string.format("Expected nil, got: %s", tostring(value))
  return self._parent:_check(value == nil, message, 3, self._group)
end

---Assert value is not nil.
---
---@param value any Value to check.
---@param message? string Custom error message.
---@return boolean result True if value is not nil.
function M._nul:not_nil(value, message)
  message = message or "Expected non-nil value"
  return self._parent:_check(value ~= nil, message, 3, self._group)
end

-- Type Check Assertions
M._type = {}

---Assert value matches expected type.
---
---Use cached type check if cache_type_checks enabled.
---
---@param value any Value to check.
---@param expected_type string Expected type name.
---@param message? string Custom error message.
---@return boolean result True if type matches.
function M._type:is_type(value, expected_type, message)
  local actual_type = self._parent:_get_type(value)
  message = message
    or string.format("Expected type %s, got: %s", expected_type, actual_type)
  return self._parent:_check(actual_type == expected_type, message, 3, self._group)
end

-- Table Assertions
M._tbl = {}

---Assert table contains key.
---
---@param tbl table Table to check.
---@param key any Key to find.
---@param message? string Custom error message.
---@return Assert.Table self For method chaining.
function M._tbl:has_key(tbl, key, message)
  message = message or string.format("Table missing key: %s", tostring(key))
  self._parent:_check(tbl[key] ~= nil, message, 3, self._group)
  return self
end

---Assert table is empty.
---
---@param tbl table Table to check.
---@param message? string Custom error message.
---@return Assert.Table self For method chaining.
function M._tbl:is_empty(tbl, message)
  message = message or "Expected empty table"
  self._parent:_check(next(tbl) == nil, message, 3, self._group)
  return self
end

---Assert table is not empty.
---
---@param tbl table Table to check.
---@param message? string Custom error message.
---@return Assert.Table self For method chaining.
function M._tbl:not_empty(tbl, message)
  message = message or "Expected non-empty table"
  self._parent:_check(next(tbl) ~= nil, message, 3, self._group)
  return self
end

---Assert table contains all specified keys.
---
---@param tbl table Table to check.
---@param keys any[] List of keys to verify.
---@param message? string Custom error message.
---@return Assert.Table self For method chaining.
function M._tbl:has_keys(tbl, keys, message)
  for _, key in ipairs(keys) do
    local msg = message or string.format("Table missing key: %s", tostring(key))
    self._parent:_check(tbl[key] ~= nil, msg, 3, self._group)
  end
  return self
end

-- Number Assertions
M._num = {}

---Assert number is within range (inclusive).
---
---@param value number Value to check.
---@param min number Minimum value (inclusive).
---@param max number Maximum value (inclusive).
---@param message? string Custom error message.
---@return Assert.Number self For method chaining.
function M._num:in_range(value, min, max, message)
  message = message
    or string.format("Expected value in range [%s, %s], got: %s", min, max, value)
  self._parent:_check(value >= min and value <= max, message, 3, self._group)
  return self
end

---Assert number exceeds threshold.
---
---@param value number Value to check.
---@param threshold number Threshold value (exclusive).
---@param message? string Custom error message.
---@return Assert.Number self For method chaining.
function M._num:greater_than(value, threshold, message)
  message = message or string.format("Expected value > %s, got: %s", threshold, value)
  self._parent:_check(value > threshold, message, 3, self._group)
  return self
end

---Assert number is below threshold.
---
---@param value number Value to check.
---@param threshold number Threshold value (exclusive).
---@param message? string Custom error message.
---@return Assert.Number self For method chaining.
function M._num:less_than(value, threshold, message)
  message = message or string.format("Expected value < %s, got: %s", threshold, value)
  self._parent:_check(value < threshold, message, 3, self._group)
  return self
end

---Assert number is positive.
---
---@param value number Value to check.
---@param message? string Custom error message.
---@return Assert.Number self For method chaining.
function M._num:positive(value, message)
  message = message or string.format("Expected positive number, got: %s", value)
  self._parent:_check(value > 0, message, 3, self._group)
  return self
end

---Assert number is negative.
---
---@param value number Value to check.
---@param message? string Custom error message.
---@return Assert.Number self For method chaining.
function M._num:negative(value, message)
  message = message or string.format("Expected negative number, got: %s", value)
  self._parent:_check(value < 0, message, 3, self._group)
  return self
end

-- String Assertions
M._str = {}

---Assert string matches Lua pattern.
---
---@param str string String to check.
---@param pattern string Lua pattern to match.
---@param message? string Custom error message.
---@return Assert.String self For method chaining.
function M._str:matches(str, pattern, message)
  message = message
    or string.format("String '%s' does not match pattern '%s'", str, pattern)
  self._parent:_check(string.match(str, pattern) ~= nil, message, 3, self._group)
  return self
end

---Assert string starts with prefix.
---
---@param str string String to check.
---@param prefix string Expected prefix.
---@param message? string Custom error message.
---@return Assert.String self For method chaining.
function M._str:starts_with(str, prefix, message)
  message = message or string.format("String '%s' does not start with '%s'", str, prefix)
  self._parent:_check(str:sub(1, #prefix) == prefix, message, 3, self._group)
  return self
end

---Assert string ends with suffix.
---
---@param str string String to check.
---@param suffix string Expected suffix.
---@param message? string Custom error message.
---@return Assert.String self For method chaining.
function M._str:ends_with(str, suffix, message)
  message = message or string.format("String '%s' does not end with '%s'", str, suffix)
  self._parent:_check(str:sub(-#suffix) == suffix, message, 3, self._group)
  return self
end

---Assert string contains substring.
---
---@param str string String to check.
---@param substring string Expected substring.
---@param message? string Custom error message.
---@return Assert.String self For method chaining.
function M._str:contains(str, substring, message)
  message = message or string.format("String '%s' does not contain '%s'", str, substring)
  self._parent:_check(str:find(substring, 1, true) ~= nil, message, 3, self._group)
  return self
end

---Assert string is not empty.
---
---@param str string String to check.
---@param message? string Custom error message.
---@return Assert.String self For method chaining.
function M._str:not_empty(str, message)
  message = message or "String cannot be empty"
  self._parent:_check(str ~= "", message, 3, self._group)
  return self
end

---Assert string length is at least specified value.
---
---@param str string String to check.
---@param len number Minimum length.
---@param message? string Custom error message.
---@return Assert.String self For method chaining.
function M._str:min_length(str, len, message)
  message = message or string.format("String must be at least %d characters", len)
  self._parent:_check(#str >= len, message, 3, self._group)
  return self
end

---Assert string length does not exceed specified value.
---
---@param str string String to check.
---@param len number Maximum length.
---@param message? string Custom error message.
---@return Assert.String self For method chaining.
function M._str:max_length(str, len, message)
  message = message or string.format("String must be at most %d characters", len)
  self._parent:_check(#str <= len, message, 3, self._group)
  return self
end

return M

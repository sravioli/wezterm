---@module 'utils.fn.tbl'

-- selene: allow(incorrect_standard_library_use)
local tunpack = unpack or table.unpack

---@class Fn.Table
local M = {}

---Check if a table is a list (consecutive integer keys starting from 1).
---A table is considered a list if all its keys are consecutive integers starting
---from 1, with no gaps or non-integer keys.
---
---@param tbl table The table to check.
---@return boolean `true` if the table is a list, `false` otherwise.
M.is_list = function(tbl)
  local i = 0
  for _ in pairs(tbl) do
    i = i + 1
    if tbl[i] == nil then
      return false
    end
  end
  return true
end

---Append items from one list into another, skipping duplicates.
---
---@param tbl table The base list to append items into.
---@param other table The list whose items will be appended.
local function combine_list(tbl, other)
  for _, item in ipairs(other) do
    local found = false
    for _, existing in ipairs(tbl) do
      if existing == item then
        found = true
        break
      end
    end
    if not found then
      table.insert(tbl, item)
    end
  end
end

---Handle a conflict when a key exists in both the base and incoming table.
---Raises an error for `"error"` behavior, skips for `"keep"`, and overwrites for `"force"`.
---No-ops when the key does not exist in the base table for `"keep"` and `"error"` behaviors.
---
---@param tbl table The base table.
---@param key any The conflicting key.
---@param value any The incoming value.
---@param behavior string The conflict resolution behavior.
local function handle_conflict(tbl, key, value, behavior)
  if tbl[key] ~= nil and behavior == "error" then
    error(string.format("Key '%s' found in multiple tables", key))
  end
  if tbl[key] == nil or behavior == "force" then
    tbl[key] = value
  end
end

---Recurse into a nested table or overwrite the existing value, depending on
---whether both the base and incoming values are non-empty, non-list tables.
---
---@param opts Tbl.MergeOpts Merge options.
---@param tbl table The base table.
---@param key any The key being merged.
---@param value table The incoming table value.
---@param other_tbl table The full incoming table (used for recursion).
local function recurse_or_overwrite(opts, tbl, key, value, other_tbl)
  local should_recurse = next(value) ~= nil
    and not M.is_list(value)
    and type(tbl[key] or false) == "table"

  if should_recurse then
    M.merge(opts, tbl[key], other_tbl[key])
  else
    handle_conflict(tbl, key, value, opts.behavior or "keep")
  end
end

---Merge a single table value into the base table at the given key.
---If `opts.combine` is enabled and both values are lists, the incoming list is
---appended to the base list without duplicates. Otherwise, recurse or overwrite.
---
---@param opts Tbl.MergeOpts Merge options.
---@param tbl table The base table.
---@param key any The key being merged.
---@param value table The incoming table value.
---@param other_tbl table The full incoming table (used for recursion).
local function merge_table_value(opts, tbl, key, value, other_tbl)
  if opts.combine and M.is_list(value) and type(tbl[key]) == "table" then
    combine_list(tbl[key], value)
  else
    recurse_or_overwrite(opts, tbl, key, value, other_tbl)
  end
end

---Merge a single key-value pair into the base table.
---Raises an error early for `"error"` behavior, then delegates to
---`merge_table_value` for table values or `handle_conflict` for scalar values.
---
---@param opts Tbl.MergeOpts Merge options.
---@param tbl table The base table.
---@param key any The key being merged.
---@param value any The incoming value.
---@param other_tbl table The full incoming table (used for recursion).
local function merge_value(opts, tbl, key, value, other_tbl)
  local behavior = opts.behavior or "keep"

  if tbl[key] ~= nil and behavior == "error" then
    error(string.format("Key '%s' found in multiple tables", key))
  end

  if type(value) == "table" then
    merge_table_value(opts, tbl, key, value, other_tbl)
  else
    handle_conflict(tbl, key, value, behavior)
  end
end

---Perform deep recursive merge of tables.
---
---Merges content of subsequent tables into the base table recursively.
---Non-empty, non-list tables are merged recursively. Lists (tables indexed by
---consecutive integers starting from 1) are treated as literals and overwritten,
---unless `opts.combine` is enabled, in which case they are concatenated without
---duplicates.
---
---@param opts Tbl.MergeOpts|"error"|"keep"|"force" Merge opts, or behavior string shorthand.
---@param tbl table The base table to merge values into.
---@param ... table One or more tables whose contents will be merged into `tbl`.
---@return table tbl Base table modified in-place with merged values.
M.merge = function(opts, tbl, ...)
  if type(opts) == "string" then
    opts = { behavior = opts }
  end

  local behavior = opts.behavior or "keep"
  assert(
    behavior == "error" or behavior == "keep" or behavior == "force",
    'Invalid behavior: expected "error", "keep", or "force"'
  )

  local tables = { ... }
  for i = 1, #tables do
    local other_tbl = tables[i]
    for key, value in pairs(other_tbl) do
      merge_value(opts, tbl, key, value, other_tbl)
    end
  end

  return tbl
end

---Compute Cartesian product of multiple tables.
---
---Returns table containing all possible combinations of elements from the input tables.
---
---@param sets table Table containing sub-tables (sets) for the product calculation.
---@return table cartesian Table of all possible combinations.
M.cartesian = function(sets)
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
end

---Reverse array elements of table.
---
---Creates a new table containing the array part of the input table in reverse order.
---
---@param tbl table Table to reverse.
---@return table reversed New table with reversed array elements.
M.reverse = function(tbl)
  local reversed = {}
  for i = #tbl, 1, -1 do
    reversed[#reversed + 1] = tbl[i]
  end
  return reversed
end

M.is_empty = function(tbl)
  return not tbl or #tbl == 0
end

return M

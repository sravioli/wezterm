---@module 'utils.fn.tbl'
---
---Custom deep merge with in-place mutation and `combine` support.
---For standard table utilities use `warp.table` / `warp.list` directly.

local warp = require "plugs.warp" ---@class Warp.Api
local is_list = warp.table.islist

---@class Fn.Table
local M = {}

-- ── merge ──────────────────────────────────────────────────────────────

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

---Recurse into a nested table or overwrite the existing value.
---
---@param opts Tbl.MergeOpts Merge options.
---@param tbl table The base table.
---@param key any The key being merged.
---@param value table The incoming table value.
---@param other_tbl table The full incoming table (used for recursion).
local function recurse_or_overwrite(opts, tbl, key, value, other_tbl)
  local should_recurse = next(value) ~= nil
    and not is_list(value)
    and type(tbl[key] or false) == "table"

  if should_recurse then
    M.merge(opts, tbl[key], other_tbl[key])
  else
    handle_conflict(tbl, key, value, opts.behavior or "keep")
  end
end

---Merge a single table value into the base table at the given key.
---
---@param opts Tbl.MergeOpts Merge options.
---@param tbl table The base table.
---@param key any The key being merged.
---@param value table The incoming table value.
---@param other_tbl table The full incoming table (used for recursion).
local function merge_table_value(opts, tbl, key, value, other_tbl)
  if opts.combine and is_list(value) and type(tbl[key]) == "table" then
    combine_list(tbl[key], value)
  else
    recurse_or_overwrite(opts, tbl, key, value, other_tbl)
  end
end

---Merge a single key-value pair into the base table.
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

return M

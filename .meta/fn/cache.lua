---@meta fn.Cache
error "cannot require a meta file!"

---@alias CacheKey string|string[] Dot-separated string or array of strings representing a key.

---@class Fn.Cache
---@field ensure_global_tbl  fun(key: string, template: table): table  Ensure table structure in `wt.GLOBAL`.
---@field memoize            fun(key: CacheKey, value: any|fun(...): any): any|fun(...): any  Memoize value or function result.
---@field compute_cached     fun(name: string, fn: fun(...): any, ...): any  Execute and cache result by argument key.
---@field get                fun(key: CacheKey): any  Retrieve cached value.
---@field delete             fun(key: CacheKey)  Delete cached value.
---@field clear              fun()  Clear all cached entries.
---@field forget             fun(key?: CacheKey)  Forget specific key or clear all.
---@field has                fun(key: CacheKey): boolean  Check if cache entry exists.
---@field sync_to_global     fun(target: table, source: table)  Recursively assign data into a `wt.GLOBAL`-backed table.
---@field clear_global       fun(target: table)  Remove all keys from a `wt.GLOBAL`-backed table.

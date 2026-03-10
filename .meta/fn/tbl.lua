---@meta fn.Tbl
error "cannot require a meta file!"

-- luacheck: push ignore 631 (line is too long)

---@class Tbl.MergeOpts
---@field public behavior? "error"|"keep"|"force" Decides what to do if a key exists in multiple tables:
--- - `"error"`: raise an error if a key is found in more than one table
--- - `"keep"`: use the value from the leftmost (base) table (default)
--- - `"force"`: use the value from the rightmost table; empty tables (`{}`) overwrite instead of merging
---@field public combine?  boolean                If `true`, list values are concatenated into the base list without duplicates
--- rather than overwriting it. Applies regardless of `behavior`. Defaults to `false`.

-- luacheck: pop

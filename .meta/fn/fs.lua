---@meta Fn.FileSystem
error "cannot require a meta file!"

---@alias OsType "windows"|"linux"|"mac"|"unknown"

---@class Fn.FileSystem.Platform
---@field public os       OsType  Operating system name.
---@field public is_win   boolean Whether the platform is Windows.
---@field public is_linux boolean Whether the platform is Linux.
---@field public is_mac   boolean Whether the platform is macOS.

---@class Fn.FileSystem
---@field log             Logger  Logger instance.
---@field target_triple   string  WezTerm target triple string.
---@field is_win          boolean Static boolean indicating if running on Windows.
---@field path_separator  string  Platform-specific path separator (`\` or `/`).

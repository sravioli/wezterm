---@meta Fn.FileSystem
error "cannot require a meta file!"

---@alias OsType "windows"|"linux"|"mac"|"unknown"

---@class Fn.FileSystem.Platform
---@field os       OsType  Operating system name.
---@field is_win   boolean Whether the platform is Windows.
---@field is_linux boolean Whether the platform is Linux.
---@field is_mac   boolean Whether the platform is macOS.

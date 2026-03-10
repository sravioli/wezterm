---@meta Fn.FileSystem
error "cannot require a meta file!"

---@alias OsType "windows"|"linux"|"mac"|"unknown"

---@class Fn.FileSystem.Platform
---@field public os       OsType  Operating system name.
---@field public is_win   boolean Whether the platform is Windows.
---@field public is_linux boolean Whether the platform is Linux.
---@field public is_mac   boolean Whether the platform is macOS.

---@meta Opts.TabTitle
error "cannot require a meta file!"

---@alias Opts.TabTitle.TruncateMode "left"|"middle"|"right"

---@class Opts.TabTitle
---@field public truncate? Opts.TabTitle.Truncate Truncation mode per title kind.

---@class Opts.TabTitle.Truncate
---@field public copilot_idle? Opts.TabTitle.TruncateMode Copilot idle pane cwd.
---@field public copilot_chat? Opts.TabTitle.TruncateMode Copilot chat/session title.
---@field public shell?        Opts.TabTitle.TruncateMode Shell cwd.
---@field public neovim?       Opts.TabTitle.TruncateMode Neovim cwd.
---@field public default?      Opts.TabTitle.TruncateMode Any other title.

---@module 'opts.tabtitle'

---@class Opts.TabTitle
local M = {
  ---Truncation mode per title kind: `"left"`, `"middle"`, or `"right"`.
  truncate = {
    copilot_idle = "right",
    copilot_chat = "right",
    shell = "right",
    neovim = "right",
    default = "right",
  },
}

return M

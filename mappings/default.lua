local act = require("wezterm").action
local fun = require "utils.fun" ---@class Fun

---@class Config
local Config = {}

Config.disable_default_key_bindings = true
Config.leader = { key = "\\", mods = "", timeout_milliseconds = 1000 }

local keys = {
  ["<leader>\\"] = act.SendKey { key = "\\" }, ---send key on <leader><leader>
  ["<C-Tab>"] = act.ActivateTabRelative(1),
  ["<C-S-Tab>"] = act.ActivateTabRelative(-1),
  ["<M-CR>"] = act.ToggleFullScreen,
  ["<C-S-c>"] = act.CopyTo "Clipboard",
  ["<C-S-v>"] = act.PasteFrom "Clipboard",
  ["<C-S-f>"] = act.Search "CurrentSelectionOrEmptyString",
  ["<C-S-k>"] = act.ClearScrollback "ScrollbackOnly",
  ["<C-S-l>"] = act.ShowDebugOverlay,
  ["<C-S-n>"] = act.SpawnWindow,
  ["<C-S-p>"] = act.ActivateCommandPalette,
  ["<C-S-r>"] = act.ReloadConfiguration,
  ["<C-S-t>"] = act.SpawnTab "CurrentPaneDomain",
  ["<C-S-u>"] = act.CharSelect {
    copy_on_select = true,
    copy_to = "ClipboardAndPrimarySelection",
  },
  ["<C-S-w>"] = act.CloseCurrentTab { confirm = true },
  ["<C-S-z>"] = act.TogglePaneZoomState,
  ["<PageUp>"] = act.ScrollByPage(-1),
  ["<PageDown>"] = act.ScrollByPage(1),
  ["<C-S-Insert>"] = act.PasteFrom "PrimarySelection",
  ["<C-Insert>"] = act.CopyTo "PrimarySelection",
  ["<C-S-Space>"] = act.QuickSelect,

  ---quick split
  ['<C-S-">'] = act.SplitHorizontal { domain = "CurrentPaneDomain" },
  ["<C-S-%>"] = act.SplitVertical { domain = "CurrentPaneDomain" },

  ---key tables
  ["<leader>w"] = act.ActivateKeyTable { name = "window_mode", one_shot = false },
  ["<leader>f"] = act.ActivateKeyTable { name = "font_mode", one_shot = false },
  ["<leader>c"] = act.ActivateCopyMode,
  ["<leader>s"] = act.Search "CurrentSelectionOrEmptyString",
}

for i = 1, 10 do
  keys["<S-F" .. i .. ">"] = act.ActivateTab(i - 1)
end

Config.keys = {}
for lhs, rhs in pairs(keys) do
  fun.map(lhs, rhs, Config.keys)
end

return Config


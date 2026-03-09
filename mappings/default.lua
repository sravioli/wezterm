---@module "mappings.default"
---@author sravioli
---@license GNU-GPLv3

---@diagnostic disable-next-line: undefined-field
local act = require("wezterm").action
local key = require "utils.keymapper" ---@class Keymapper

-- selene: allow(incorrect_standard_library_use)
local tunpack = unpack or table.unpack

local Config = {}

Config.disable_default_key_bindings = false
Config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

-- ── Tab activation via F-keys (F1–F24) ───────────────────────────────────────
-- Built programmatically and merged into the mappings table below so that
-- key.maps() can process everything in a single call.
local fkey_mappings = {}
for i = 1, 24 do
  fkey_mappings[i] = { "<S-F" .. i .. ">", act.ActivateTab(i - 1), "activate tab " .. i }
end

key.maps(Config, {
  -- ── Global navigation ───────────────────────────────────────────────────
  { "<C-Tab>", act.ActivateTabRelative(1), "next tab" },
  { "<C-S-Tab>", act.ActivateTabRelative(-1), "prev tab" },
  { "<M-CR>", act.ToggleFullScreen, "fullscreen" },

  -- ── Clipboard ───────────────────────────────────────────────────────────
  { "<C-S-c>", act.CopyTo "Clipboard", "copy" },
  { "<C-S-v>", act.PasteFrom "Clipboard", "paste" },
  { "<C-S-Insert>", act.PasteFrom "PrimarySelection", "" },
  { "<C-Insert>", act.CopyTo "PrimarySelection", "" },

  -- ── UI ──────────────────────────────────────────────────────────────────
  { "<C-S-f>", act.Search "CurrentSelectionOrEmptyString", "search" },
  { "<C-S-k>", act.ClearScrollback "ScrollbackOnly", "clear scrollback" },
  { "<C-S-l>", act.ShowDebugOverlay, "debug overlay" },
  { "<C-S-p>", act.ActivateCommandPalette, "command palette" },
  { "<C-S-r>", act.ReloadConfiguration, "reload config" },
  { "<C-S-z>", act.TogglePaneZoomState, "toggle zoom" },
  { "<C-S-Space>", act.QuickSelect, "quick select" },
  { "<PageUp>", act.ScrollByPage(-1), "" },
  { "<PageDown>", act.ScrollByPage(1), "" },

  -- ── Windows / tabs ──────────────────────────────────────────────────────
  { "<C-S-n>", act.SpawnWindow, "new window" },
  { "<C-S-t>", act.SpawnTab "CurrentPaneDomain", "new pane" },
  { "<C-S-w>", act.CloseCurrentTab { confirm = true }, "close tab" },
  {
    "<S-M-t>",
    act.ShowLauncherArgs { title = "  Search:", flags = "FUZZY|LAUNCH_MENU_ITEMS|DOMAINS" },
    "launcher",
  },
  {
    "<C-S-u>",
    act.CharSelect { copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" },
    "char select",
  },

  -- ── Quick split and pane navigation ─────────────────────────────────────
  { '<C-S-">', act.SplitHorizontal { domain = "CurrentPaneDomain" }, "vsplit" },
  { "<C-S-%>", act.SplitVertical { domain = "CurrentPaneDomain" }, "hsplit" },
  { "<C-M-h>", act.ActivatePaneDirection "Left", "move left" },
  { "<C-M-j>", act.ActivatePaneDirection "Down", "move down" },
  { "<C-M-k>", act.ActivatePaneDirection "Up", "move up" },
  { "<C-M-l>", act.ActivatePaneDirection "Right", "move right" },

  -- ── Key-table entry points ───────────────────────────────────────────────
  {
    "<leader>h",
    act.ActivateKeyTable { name = "help_mode", one_shot = true },
    "help",
  },
  {
    "<leader>w",
    act.ActivateKeyTable { name = "window_mode", one_shot = false },
    "window mode",
  },
  {
    "<leader>f",
    act.ActivateKeyTable { name = "font_mode", one_shot = false },
    "font mode",
  },
  {
    "<leader>c",
    act.ActivateCopyMode,
    "copy mode",
  },
  {
    "<leader>s",
    act.Search "CurrentSelectionOrEmptyString",
    "search mode",
  },
  {
    "<leader>p",
    act.ActivateKeyTable { name = "pick_mode" },
    "pick mode",
  },

  -- ── F-key tab activation (F1–F24) ────────────────────────────────────────
  tunpack(fkey_mappings),
})

return Config

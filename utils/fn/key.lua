---@module 'utils.fn.key'

local str = require "utils.fn.str" ---@class Fn.String

local sgsub, ssub, smatch, sformat = string.gsub, string.sub, string.match, string.format
local tconcat = table.concat

---@class Fn.Keymap
---@field aliases   table
---@field modifiers table
local M = {
  ---@package
  aliases = {
    -- Vim-style aliases mapped to WezTerm key names
    CR = "Enter",
    BS = "Backspace",
    ESC = "Escape",
    Bar = "|",
    Space = " ",
    Tab = "Tab",
    -- Arrow keys
    Up = "UpArrow",
    Down = "DownArrow",
    Left = "LeftArrow",
    Right = "RightArrow",
    -- Numpad
    k0 = "Numpad0",
    k1 = "Numpad1",
    k2 = "Numpad2",
    k3 = "Numpad3",
    k4 = "Numpad4",
    k5 = "Numpad5",
    k6 = "Numpad6",
    k7 = "Numpad7",
    k8 = "Numpad8",
    k9 = "Numpad9",
    lt = "<",
    gt = ">",
    PageUp = "PageUp",
    PageDown = "PageDown",
    F1 = "F1",
    F2 = "F2",
    F3 = "F3",
    F4 = "F4",
    F5 = "F5",
    F6 = "F6",
    F7 = "F7",
    F8 = "F8",
    F9 = "F9",
    F10 = "F10",
    F11 = "F11",
    F12 = "F12",
  },

  ---@package
  modifiers = {
    C = "CTRL",
    S = "SHIFT",
    A = "ALT",
    M = "ALT",
    W = "SUPER",
  },
}

---@package
---
---Class logger
M._log = require("utils.logger"):new "Utils.Fn.Key"

---@package
---
---Nil checks the given parameters.
---@param lhs string? keymap
---@param rhs (string|table)? keymap action
---@param tbl table? table to fill with keymap
---@return boolean success
M.__check = function(lhs, rhs, tbl)
  if not lhs then
    M._log:error("cannot map %s without lhs!", rhs)
    return false
  elseif not rhs then
    M._log:error("cannot map %s to a nil action!", lhs)
    return false
  elseif not tbl then
    M._log:error "cannot add keymaps! No table given"
    return false
  end
  return true
end

---@package
---
---Checks if the given keymap contains the `<leader>` prefix.
---
---If `^<leader>` is found it gets removed from the keymap and added to the mods table.
---
---@param lhs string keymap to check
---@param mods table modifiers table that gets eventually filled with the `"LEADER"` mod
---@return string lhs keymap with `^<leader>` removed (if found)
M.__has_leader = function(lhs, mods)
  if smatch(lhs, "^<[Ll][Ee][Aa][Dd][Ee][Rr]>") then
    lhs = sgsub(lhs, "^<[Ll][Ee][Aa][Dd][Ee][Rr]>", "")
    mods[#mods + 1] = "LEADER"
  end
  return lhs
end

---Validates a keymap without mapping it.
---
---Useful for testing configurations and catching errors early.
---
---@param lhs string keymap to validate
---@return boolean valid true if the keymap is valid
---@return string? error error message if invalid
---
---@usage
---~~~lua
---local key = require("utils.key")
---local valid, err = key.validate("<C-X-a>")
---if not valid then
---  print("Invalid keymap: " .. err)
---end
---~~~
M.validate = function(lhs)
  if not lhs or type(lhs) ~= "string" then
    return false, "keymap must be a non-empty string"
  end

  if #lhs == 1 then
    return true
  end

  local test_lhs = lhs
  if smatch(test_lhs, "^<[Ll][Ee][Aa][Dd][Ee][Rr]>") then
    test_lhs = sgsub(test_lhs, "^<[Ll][Ee][Aa][Dd][Ee][Rr]>", "")
  end

  if not test_lhs:match "%b<>" then
    return true
  end

  local normalized = sgsub(test_lhs, "(%b<>)", function(s)
    return ssub(s, 2, -2)
  end)

  local keys = str.split(normalized, "%-")

  if #keys == 1 then
    return true
  end

  local k = keys[#keys]
  if M.modifiers[k] then
    return false, "keymap cannot end with modifier!"
  end

  for i = 1, #keys - 1 do
    if not M.modifiers[keys[i]] then
      return false, sformat("unknown modifier: %s", keys[i])
    end
  end

  return true
end

---Maps an action using (n)vim-like syntax to WezTerm format.
---
---This function allows you to map a key or a combination of keys to a specific action,
---using a syntax similar to that of (n)vim. The mapped keys and actions are inserted
---into the provided table in WezTerm's expected format.
---
---Supports:
--- - Single keys: "a", "1", etc.
--- - Modified keys: "<C-a>", "<S-F1>", etc.
--- - Leader key: "<leader>a", "<leader><C-S-a>", etc.
--- - Special keys: "<CR>", "<BS>", "<ESC>", "<Space>", etc.
--- - Case-insensitive modifiers: "<c-a>" and "<C-a>" are equivalent
---
---@param lhs string key or key combination to map.
---@param rhs string|table valid `wezterm.action.<action>` to execute upon keypress.
---@param tbl table table in which to insert the keymaps.
---
---@usage
---
---~~~lua
----- Example usage
---local key = require("utils.key")
---local wezterm = require("wezterm")
---local act = wezterm.action
---local keymaps = {}
---
----- Basic mappings
---key.map("<leader>a", act.ActivateTab(1), keymaps)
---key.map("<C-a>", act.ActivateTab(2), keymaps)
---key.map("b", act.SendString("hello"), keymaps)
---
----- Complex examples
---key.map("<leader><C-S-a>", act.SplitPane{direction="Right"}, keymaps)
---key.map("<C-Bar>", act.SplitHorizontal{domain="CurrentPaneDomain"}, keymaps)
---key.map("<C-CR>", act.SendKey{key="Enter", mods="CTRL"}, keymaps)
---key.map("<c-a>", act.ActivateTab(3), keymaps)  -- Case insensitive
---
----- Arrow keys and function keys
---key.map("<C-Up>", act.ScrollByLine(-1), keymaps)
---key.map("<S-F5>", act.ReloadConfiguration, keymaps)
---
----- Numpad keys
---key.map("<C-k1>", act.ActivateTab(0), keymaps)
---~~~
M.map = function(lhs, rhs, tbl)
  if not M.__check(lhs, rhs, tbl) then
    return
  end

  ---Inserts the given keymap in the table
  ---@param key string key to press.
  ---@param mods? table modifiers. defaults to `""`
  local function __map(key, mods)
    local mods_str = tconcat(mods or {}, "|")
    tbl[#tbl + 1] = {
      key = key,
      mods = mods_str ~= "" and mods_str or nil,
      action = rhs,
    }
  end

  ---initialize the modifiers table
  local mods = {}

  ---don't parse a single key
  if #lhs == 1 then
    return __map(lhs, mods)
  end

  local aliases, modifiers = M.aliases, M.modifiers
  lhs = M.__has_leader(lhs, mods)

  if not smatch(lhs, "%b<>") then
    return __map(lhs, mods)
  end

  lhs = sgsub(lhs, "(%b<>)", function(s)
    return ssub(s, 2, -2)
  end)

  local keys = str.split(lhs, "%-")

  if #keys == 1 then
    return __map(aliases[keys[1]] or keys[1], mods)
  end

  local k = keys[#keys]
  if modifiers[k] then
    M._log:error("keymap cannot end with modifier! Got: %s", lhs)
    return
  else
    keys[#keys] = nil
  end
  k = aliases[k] or k

  for i = 1, #keys do
    local mod = modifiers[keys[i]]
    if not mod then
      M._log:error("unknown modifier: '%s' in keymap '%s'", keys[i], lhs)
      return
    end
    mods[#mods + 1] = mod
  end

  return __map(k, mods)
end

---Maps multiple actions at once using a table of mappings.
---
---@param mappings table array of {lhs, rhs} pairs
---@param tbl table table in which to insert the keymaps
---
---@usage
---~~~lua
---local key = require("utils.key")
---local wezterm = require("wezterm")
---local act = wezterm.action
---local keymaps = {}
---
---key.map_batch({
---  {"<leader>a", act.ActivateTab(1)},
---  {"<C-a>", act.ActivateTab(2)},
---  {"<leader><C-S-h>", act.ActivatePaneDirection("Left")},
---  {"<leader><C-S-l>", act.ActivatePaneDirection("Right")},
---}, keymaps)
---~~~
M.map_batch = function(mappings, tbl)
  if not mappings then
    M._log:error "cannot batch map: no mappings provided"
    return
  end
  if not tbl then
    M._log:error "cannot batch map: no table provided"
    return
  end

  local success_count = 0
  local error_count = 0

  for idx, mapping in ipairs(mappings) do
    if type(mapping) == "table" and #mapping >= 2 then
      M.map(mapping[1], mapping[2], tbl)
      success_count = success_count + 1
    else
      M._log:error(
        "invalid mapping format at index %d: expected {lhs, rhs}, got %s",
        idx,
        type(mapping)
      )
      error_count = error_count + 1
    end
  end

  M._log:debug("batch map complete: %d succeeded, %d failed", success_count, error_count)
end

---Creates a key table mapping (for use with ActivateKeyTable action).
---
---Key tables allow you to create modal key bindings in WezTerm.
---
---@param mappings table array of {lhs, rhs} pairs
---@return table key_table table of key bindings in WezTerm format
---
---@usage
---~~~lua
---local key = require("utils.key")
---local wezterm = require("wezterm")
---local act = wezterm.action
---
---config.key_tables = {
---  resize_pane = key.table({
---    {"h", act.AdjustPaneSize{"Left", 1}},
---    {"j", act.AdjustPaneSize{"Down", 1}},
---    {"k", act.AdjustPaneSize{"Up", 1}},
---    {"l", act.AdjustPaneSize{"Right", 1}},
---    {"<ESC>", "PopKeyTable"},
---  }),
---}
---~~~
M.table = function(mappings)
  local key_table = {}
  if not mappings then
    M._log:error "cannot create key table: no mappings provided"
    return key_table
  end

  M.map_batch(mappings, key_table)
  return key_table
end

return M

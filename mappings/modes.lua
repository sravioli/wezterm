---@module "mappings.modes"
---@author sravioli
---@license GNU-GPLv3

---@diagnostic disable-next-line: undefined-field
local act = require("wezterm").action
local icon = require("plugs.sigil").symbol "Modes"
local key = require "plugs.chord" ---@class Chord
local lantern = require "plugs.lantern" ---@class Lantern

local M = {}

local function hint_page(direction)
  return act.Multiple {
    key.hint_action(nil, direction),
    act.EmitEvent "chord-hint-page-changed",
  }
end

local function native_mode(name, enter, spec)
  local mode = key.mode(name, spec)

  function mode.activate(_, lhs, desc)
    return key.key(lhs, enter(), desc)
  end

  return mode
end

-- {{{1 COPY MODE
M.copy = native_mode("copy_mode", function()
  return act.ActivateCopyMode
end, function(theme)
  return {
    meta = { i = icon.copy, txt = "COPY", bg = theme.brights[3], pad = 5 },
    keys = {
      { "<ESC>", act.CopyMode "Close", "exit" },
      { "<C-S-A-Left>", hint_page(-1), "" },
      { "<C-S-A-Right>", hint_page(1), "" },
      {
        "y",
        act.Multiple {
          { CopyTo = "ClipboardAndPrimarySelection" },
          { CopyMode = "Close" },
        },
        "copy selection",
      },

      ---motion
      { "h", act.CopyMode "MoveLeft", "left" },
      { "j", act.CopyMode "MoveDown", "down" },
      { "k", act.CopyMode "MoveUp", "up" },
      { "l", act.CopyMode "MoveRight", "right" },
      { "b", act.CopyMode "MoveBackwardWord", "word ←" },
      { "e", act.CopyMode "MoveForwardWordEnd", "word end" },
      { "w", act.CopyMode "MoveForwardWord", "word →" },
      { "<Tab>", act.CopyMode "MoveForwardWord", "forward" },
      { "<S-Tab>", act.CopyMode "MoveBackwardWord", "backward" },
      { "<CR>", act.CopyMode "MoveToStartOfNextLine", "next line" },
      { "0", act.CopyMode "MoveToStartOfLine", "line start" },
      { "<S-$>", act.CopyMode "MoveToEndOfLineContent", "line end" },
      { "^", act.CopyMode "MoveToStartOfLineContent", "" },
      { "G", act.CopyMode "MoveToScrollbackBottom", "bot" },
      { "g", act.CopyMode "MoveToScrollbackTop", "top" },
      { "H", act.CopyMode "MoveToViewportTop", "view top" },
      { "M", act.CopyMode "MoveToViewportMiddle", "view mid" },
      { "L", act.CopyMode "MoveToViewportBottom", "view bot" },
      { "<C-d>", act.CopyMode { MoveByPage = 0.5 }, "scroll ↓" },
      { "<C-u>", act.CopyMode { MoveByPage = -0.5 }, "scroll ↑" },

      ---jump
      { ",", act.CopyMode "JumpReverse", "repeat ←" },
      { ";", act.CopyMode "JumpAgain", "repeat" },
      { "F", act.CopyMode { JumpBackward = { prev_char = false } }, "" },
      { "f", act.CopyMode { JumpForward = { prev_char = false } }, "" },
      { "T", act.CopyMode { JumpBackward = { prev_char = true } }, "" },
      { "t", act.CopyMode { JumpForward = { prev_char = true } }, "" },

      ---selection
      { "<Space>", act.CopyMode { SetSelectionMode = "Cell" }, "" },
      { "V", act.CopyMode { SetSelectionMode = "Line" }, "line mode" },
      { "v", act.CopyMode { SetSelectionMode = "Cell" }, "cell mode" },
      { "<C-v>", act.CopyMode { SetSelectionMode = "Block" }, "block mode" },
      { "O", act.CopyMode "MoveToSelectionOtherEndHoriz", "other end h" },
      { "o", act.CopyMode "MoveToSelectionOtherEnd", "other end" },
    },
  }
end) -- }}}

-- {{{1 SEARCH MODE
M.search = native_mode("search_mode", function()
  return act.Search "CurrentSelectionOrEmptyString"
end, function(theme)
  return {
    meta = { i = icon.search, txt = "SEARCH", bg = theme.brights[4], pad = 5 },
    keys = {
      { "<ESC>", act.CopyMode "Close", "exit" },
      { "<C-S-A-Left>", hint_page(-1), "" },
      { "<C-S-A-Right>", hint_page(1), "" },
      { "<C-n>", act.CopyMode "NextMatch", "next" },
      { "<C-N>", act.CopyMode "PriorMatch", "prev" },
      { "<C-r>", act.CopyMode "CycleMatchType", "cycle type" },
      { "<C-u>", act.CopyMode "ClearPattern", "clear" },
      { "<PageUp>", act.CopyMode "PriorMatchPage", "prev page" },
      { "<PageDown>", act.CopyMode "NextMatchPage", "next page" },
      { "<Up>", act.CopyMode "PriorMatch", "prev" },
      { "<Down>", act.CopyMode "NextMatch", "next" },
    },
  }
end) -- }}}

-- {{{1 FONT MODE
M.font = key.mode("font_mode", function(theme)
  return {
    meta = { i = icon.font, txt = "FONT", bg = theme.ansi[7], pad = 4 },
    keys = {
      { "<ESC>", "PopKeyTable", "exit" },
      { "<C-S-A-Left>", hint_page(-1), "" },
      { "<C-S-A-Right>", hint_page(1), "" },
      { "+", act.IncreaseFontSize, "increase size" },
      { "-", act.DecreaseFontSize, "decrease size" },
      { "0", act.ResetFontSize, "reset size" },
    },
  }
end) -- }}}

-- {{{1 WINDOW MODE
M.window = key.mode("window_mode", function(theme)
  return {
    meta = { i = icon.window, txt = "WINDOW", bg = theme.ansi[6], pad = 4 },
    keys = {
      { "<ESC>", "PopKeyTable", "exit" },
      { "<C-S-A-Left>", hint_page(-1), "" },
      { "<C-S-A-Right>", hint_page(1), "" },
      { "q", act.CloseCurrentPane { confirm = true }, "close" },

      ---pane navigation
      { "h", act.ActivatePaneDirection "Left", "left" },
      { "j", act.ActivatePaneDirection "Down", "down" },
      { "k", act.ActivatePaneDirection "Up", "up" },
      { "l", act.ActivatePaneDirection "Right", "right" },
      { "<Left>", act.ActivatePaneDirection "Left", "" },
      { "<Down>", act.ActivatePaneDirection "Down", "" },
      { "<Up>", act.ActivatePaneDirection "Up", "" },
      { "<Right>", act.ActivatePaneDirection "Right", "" },

      ---splits
      { "v", act.SplitHorizontal { domain = "CurrentPaneDomain" }, "vsplit" },
      { "s", act.SplitVertical { domain = "CurrentPaneDomain" }, "hsplit" },

      ---pane management
      { "p", act.PaneSelect, "pick" },
      { "x", act.PaneSelect { mode = "SwapWithActive" }, "swap" },
      { "o", act.TogglePaneZoomState, "toggle zoom" },

      ---resize
      { "<", act.AdjustPaneSize { "Left", 2 }, "resize ←" },
      { "<S->>", act.AdjustPaneSize { "Right", 2 }, "resize →" },
      { "+", act.AdjustPaneSize { "Up", 2 }, "resize ↑" },
      { "-", act.AdjustPaneSize { "Down", 2 }, "resize ↓" },
    },
  }
end) -- }}}

-- {{{1 HELP MODE
M.help = key.mode("help_mode", function(theme)
  return {
    meta = { i = icon.help, txt = "NORMAL", bg = theme.ansi[5], pad = 5 },
    keys = {
      { "<ESC>", "PopKeyTable", "exit" },
      { "<C-S-A-Left>", hint_page(-1), "" },
      { "<C-S-A-Right>", hint_page(1), "" },

      ---tabs
      { "<C-Tab>", act.ActivateTabRelative(1), "next tab" },
      { "<C-S-Tab>", act.ActivateTabRelative(-1), "prev tab" },

      ---clipboard
      { "<C-S-c>", act.CopyTo "Clipboard", "copy" },
      { "<C-S-v>", act.PasteFrom "Clipboard", "paste" },

      ---UI
      { "<C-S-f>", act.Search "CurrentSelectionOrEmptyString", "search" },
      { "<C-S-k>", act.ClearScrollback "ScrollbackOnly", "clear scrollback" },
      { "<C-S-l>", act.ShowDebugOverlay, "debug overlay" },
      { "<C-S-n>", act.SpawnWindow, "new window" },
      { "<C-S-p>", act.ActivateCommandPalette, "command palette" },
      { "<C-S-r>", act.ReloadConfiguration, "reload config" },
      { "<C-S-t>", act.SpawnTab "CurrentPaneDomain", "new pane" },
      {
        "<C-S-u>",
        act.CharSelect {
          copy_on_select = true,
          copy_to = "ClipboardAndPrimarySelection",
        },
        "char select",
      },
      { "<C-S-w>", act.CloseCurrentTab { confirm = true }, "close tab" },
      { "<C-S-z>", act.TogglePaneZoomState, "toggle zoom" },
      { "<PageUp>", act.ScrollByPage(-1), "" },
      { "<PageDown>", act.ScrollByPage(1), "" },
      { "<C-S-Insert>", act.PasteFrom "PrimarySelection", "" },
      { "<C-Insert>", act.CopyTo "PrimarySelection", "" },
      { "<C-S-Space>", act.QuickSelect, "quick select" },

      ---quick split and nav
      { '<C-S-">', act.SplitHorizontal { domain = "CurrentPaneDomain" }, "vsplit" },
      { "<C-S-%>", act.SplitVertical { domain = "CurrentPaneDomain" }, "hsplit" },
      { "<C-M-h>", act.ActivatePaneDirection "Left", "move left" },
      { "<C-M-j>", act.ActivatePaneDirection "Down", "move down" },
      { "<C-M-k>", act.ActivatePaneDirection "Up", "move up" },
      { "<C-M-l>", act.ActivatePaneDirection "Right", "move right" },

      ---key-table entry points
      M.help:activate("<leader>h", "help", { one_shot = true }),
      M.window:activate("<leader>w", "window mode"),
      M.font:activate("<leader>f", "font mode"),
      M.copy:activate("<leader>c", "copy mode"),
      M.search:activate("<leader>s", "search mode"),
    },
  }
end) -- }}}

-- {{{1 LANTERN MODE
M.lantern = key.mode("lantern_mode", function(theme)
  return {
    meta = { i = icon.lantern, txt = "LANTERN", bg = theme.ansi[2], pad = 3 },
    keys = {
      { "<ESC>", "PopKeyTable", "exit" },
      { "<C-S-A-Left>", hint_page(-1), "" },
      { "<C-S-A-Right>", hint_page(1), "" },
      { "c", lantern.light.colorscheme(), "colorscheme" },
      { "f", lantern.light.font(), "font" },
      { "s", lantern.light.font_size(), "font size" },
      { "l", lantern.light.font_leading(), "line height" },
      { "g", lantern.light.gpu(), "GPU" },
      { "o", lantern.light.window_opacity(), "window opacity" },
      { "p", lantern.light.window_padding(), "window padding" },
      { "u", lantern.light.cursor_style(), "cursor style" },
      { "i", lantern.light.inactive_pane_opacity(), "inactive pane opacity" },
      { "a", lantern.light.font_ligatures(), "font ligatures" },
      { "t", lantern.light.tab_bar_style(), "tab bar style" },
    },
  }
end) -- }}}

function M.all()
  return {
    M.copy,
    M.search,
    M.font,
    M.window,
    M.help,
    M.lantern,
  }
end

function M.config()
  local Config = {}

  key.tables(Config, M.all())

  return Config
end

return M

---@module "mappings.modes"
---@author sravioli
---@license GNU-GPLv3

---@diagnostic disable-next-line: undefined-field
local act = require("wezterm").action
local key = require "utils.keymapper" ---@class Keymapper
local icon = require("utils.icons").Modes

local Config = {}

key.tables(Config, {
  -- {{{1 COPY MODE
  copy_mode = function(theme)
    return {
      meta = { i = icon.copy, txt = "COPY", bg = theme.brights[3], pad = 5 },
      keys = {
        { "<ESC>", act.CopyMode "Close", "exit" },
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
  end, -- }}}

  -- {{{1 SEARCH MODE
  search_mode = function(theme)
    return {
      meta = { i = icon.search, txt = "SEARCH", bg = theme.brights[4], pad = 5 },
      keys = {
        { "<ESC>", act.CopyMode "Close", "exit" },
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
  end, -- }}}

  -- {{{1 FONT MODE
  font_mode = function(theme)
    return {
      meta = { i = icon.font, txt = "FONT", bg = theme.ansi[7], pad = 4 },
      keys = {
        { "<ESC>", "PopKeyTable", "exit" },
        { "+", act.IncreaseFontSize, "increase size" },
        { "-", act.DecreaseFontSize, "decrease size" },
        { "0", act.ResetFontSize, "reset size" },
      },
    }
  end, -- }}}

  -- {{{1 WINDOW MODE
  window_mode = function(theme)
    return {
      meta = { i = icon.window, txt = "WINDOW", bg = theme.ansi[6], pad = 4 },
      keys = {
        { "<ESC>", "PopKeyTable", "exit" },
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
  end, -- }}}

  -- {{{1 HELP MODE
  help_mode = function(theme)
    return {
      meta = { i = icon.help, txt = "NORMAL", bg = theme.ansi[5], pad = 5 },
      keys = {
        { "<ESC>", "PopKeyTable", "exit" },

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
        {
          "<C-M-h>",
          act.ActivatePaneDirection "Left",
          "move left",
        },
        {
          "<C-M-j>",
          act.ActivatePaneDirection "Down",
          "move down",
        },
        {
          "<C-M-k>",
          act.ActivatePaneDirection "Up",
          "move up",
        },
        {
          "<C-M-l>",
          act.ActivatePaneDirection "Right",
          "move right",
        },

        ---key-table entry points
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
      },
    }
  end, -- }}}

  -- {{{1 PICK MODE
  pick_mode = function(theme)
    return {
      meta = { i = icon.pick, txt = "PICK", bg = theme.ansi[2], pad = 5 },
      keys = {
        { "<ESC>", "PopKeyTable", "exit" },
        { "c", require("picker.colorscheme"):pick(), "colorscheme" },
        { "f", require("picker.font"):pick(), "font" },
        { "s", require("picker.font-size"):pick(), "font size" },
        { "l", require("picker.font-leading"):pick(), "line height" },
      },
    }
  end, -- }}}
})

return Config

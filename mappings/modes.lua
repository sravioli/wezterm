---@module "mappings.modes"
---@author sravioli
---@license GNU-GPLv3

---@diagnostic disable-next-line: undefined-field
local act = require("wezterm").action
local key = require("utils.fn").key

local Config = {}

local key_tables = {
  -- {{{1 COPY MODE (copy_mode)
  copy_mode = {
    { "<ESC>", act.CopyMode "Close", "exit" },
    {
      "y",
      act.Multiple {
        { CopyTo = "ClipboardAndPrimarySelection" },
        { CopyMode = "Close" },
      },
      "copy selection",
    },
    { "h", act.CopyMode "MoveLeft", "left" },
    { "j", act.CopyMode "MoveDown", "up" },
    { "k", act.CopyMode "MoveUp", "down" },
    { "l", act.CopyMode "MoveRight", "right" },
    { "b", act.CopyMode "MoveBackwardWord", "word backward" },
    { "e", act.CopyMode "MoveForwardWordEnd", "word end" },
    { "w", act.CopyMode "MoveForwardWord", "word forward" },
    { "<Tab>", act.CopyMode "MoveForwardWord", "forward" },
    { "<S-Tab>", act.CopyMode "MoveBackwardWord", "backward" },
    { "<CR>", act.CopyMode "MoveToStartOfNextLine", "next line" },
    { "<Space>", act.CopyMode { SetSelectionMode = "Cell" }, "" },
    { "0", act.CopyMode "MoveToStartOfLine", "line start" },
    { "<S-$>", act.CopyMode "MoveToEndOfLineContent", "line end" },
    { "^", act.CopyMode "MoveToStartOfLineContent", "" },
    { ",", act.CopyMode "JumpReverse", "repeat back" },
    { ";", act.CopyMode "JumpAgain", "repeat" },
    { "F", act.CopyMode { JumpBackward = { prev_char = false } }, "" },
    { "f", act.CopyMode { JumpForward = { prev_char = false } }, "" },
    { "T", act.CopyMode { JumpBackward = { prev_char = true } }, "" },
    { "t", act.CopyMode { JumpForward = { prev_char = true } }, "" },
    { "G", act.CopyMode "MoveToScrollbackBottom", "bot" },
    { "g", act.CopyMode "MoveToScrollbackTop", "top" },
    { "H", act.CopyMode "MoveToViewportTop", "viewport top" },
    { "M", act.CopyMode "MoveToViewportMiddle", "viewport middle" },
    { "L", act.CopyMode "MoveToViewportBottom", "viewport bot" },
    { "V", act.CopyMode { SetSelectionMode = "Line" }, "line mode" },
    { "v", act.CopyMode { SetSelectionMode = "Cell" }, "cell mode" },
    { "<C-v>", act.CopyMode { SetSelectionMode = "Block" }, "block mode" },
    { "O", act.CopyMode "MoveToSelectionOtherEndHoriz", "selection other end" },
    { "o", act.CopyMode "MoveToSelectionOtherEnd", "selection end" },
    { "<C-d>", act.CopyMode { MoveByPage = 0.5 }, "scroll down" },
    { "<C-u>", act.CopyMode { MoveByPage = -0.5 }, "scroll up" },
  }, -- }}}

  -- {{{1 SEARCH MODE (search_mode)
  search_mode = {
    { "<ESC>", act.CopyMode "Close", "exit" },
    { "<C-n>", act.CopyMode "NextMatch", "next" },
    { "<C-N>", act.CopyMode "PriorMatch", "prev" },
    { "<C-r>", act.CopyMode "CycleMatchType", "cycle type" },
    { "<C-u>", act.CopyMode "ClearPattern", "clear pattern" },
    { "<PageUp>", act.CopyMode "PriorMatchPage", "prev page" },
    { "<PageDown>", act.CopyMode "NextMatchPage", "next page" },
    { "<UpArrow>", act.CopyMode "PriorMatch", "next" },
    { "<DownArrow>", act.CopyMode "NextMatch", "prev" },
  }, -- }}}

  -- {{{1 FONT MODE (font_mode)
  font_mode = {
    { "<ESC>", "PopKeyTable", "exit" },
    { "+", act.IncreaseFontSize, "increase size" },
    { "-", act.DecreaseFontSize, "decrease size" },
    { "0", act.ResetFontSize, "reset size" },
  }, -- }}}

  -- {{{1 WINDOW MODE (window_mode)
  window_mode = {
    { "<ESC>", "PopKeyTable", "exit" },
    { "q", act.CloseCurrentPane { confirm = true }, "close" },
    { "h", act.ActivatePaneDirection "Left", "left" },
    { "j", act.ActivatePaneDirection "Down", "down" },
    { "k", act.ActivatePaneDirection "Up", "up" },
    { "l", act.ActivatePaneDirection "Right", "right" },
    { "v", act.SplitHorizontal { domain = "CurrentPaneDomain" }, "vsplit" },
    { "s", act.SplitVertical { domain = "CurrentPaneDomain" }, "hsplit" },
    { "p", act.PaneSelect, "pick" },
    { "x", act.PaneSelect { mode = "SwapWithActive" }, "swap" },
    { "o", act.TogglePaneZoomState, "toggle zoom" },
    { "<LeftArrow>", act.ActivatePaneDirection "Left", "" },
    { "<DownArrow>", act.ActivatePaneDirection "Down", "" },
    { "<UpArrow>", act.ActivatePaneDirection "Up", "" },
    { "<RightArrow>", act.ActivatePaneDirection "Right", "" },
    { "<", act.AdjustPaneSize { "Left", 2 }, "resize left" },
    { "<S->>", act.AdjustPaneSize { "Right", 2 }, "resize right" },
    { "+", act.AdjustPaneSize { "Up", 2 }, "resize top" },
    { "-", act.AdjustPaneSize { "Down", 2 }, "resize bot" },
  }, -- }}}

  -- {{{1 HELP MODE (help_mode)
  help_mode = {
    { "<ESC>", "PopKeyTable", "exit" },
    { "<C-Tab>", act.ActivateTabRelative(1), "next tab" },
    { "<C-S-Tab>", act.ActivateTabRelative(-1), "prev tab" },
    { "<C-S-c>", act.CopyTo "Clipboard", "copy" },
    { "<C-S-v>", act.PasteFrom "Clipboard", "paste" },
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
    { "<C-M-j>", act.ActivatePaneDirection "Down", "mode down" },
    { "<C-M-k>", act.ActivatePaneDirection "Up", "move up" },
    { "<C-M-l>", act.ActivatePaneDirection "Right", "move right" },

    ---key tables
    { "<leader>h", act.ActivateKeyTable { name = "help_mode", one_shot = true }, "help" },
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
    { "<leader>c", act.ActivateCopyMode, "copy mode" },
    { "<leader>s", act.Search "CurrentSelectionOrEmptyString", "search mode" },
  },
  -- }}}

  -- {{{1 PICK MODE (pick_mode)
  pick_mode = {
    { "<ESC>", "PopKeyTable", "exit" },
    { "c", require("picker.colorscheme"):pick(), "colorscheme" },
    { "f", require("picker.font"):pick(), "font" },
    { "s", require("picker.font-size"):pick(), "font size" },
    { "l", require("picker.font-leading"):pick(), "line height" },
  }, -- }}}
}

Config.key_tables = {}
for mode, mode_table in pairs(key_tables) do
  Config.key_tables[mode] = {}
  for _, map_tbl in ipairs(mode_table) do
    key.map(map_tbl[1], map_tbl[2], Config.key_tables[mode])
  end
end

return { Config, key_tables }

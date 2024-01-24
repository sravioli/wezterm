local wez = require "wezterm" ---@class WezTerm
local act = wez.action

local fun = require "utils.fun" ---@class Fun

---@class Config
local Config = {}

local key_tables = {
  -- {{{1 COPY MODE (copy_mode)
  copy_mode = {
    ["<ESC>"] = act.CopyMode "Close",
    ["<q>"] = act.CopyMode "Close",
    ["<Tab>"] = act.CopyMode "MoveForwardWord",
    ["<S-Tab>"] = act.CopyMode "MoveBackwardWord",
    ["<CR>"] = act.CopyMode "MoveToStartOfNextLine",
    ["<Space>"] = act.CopyMode { SetSelectionMode = "Cell" },
    ["0"] = act.CopyMode "MoveToStartOfLine",
    ["<S-$>"] = act.CopyMode "MoveToEndOfLineContent",
    ["^"] = act.CopyMode "MoveToStartOfLineContent",
    [","] = act.CopyMode "JumpReverse",
    [";"] = act.CopyMode "JumpAgain",
    ["F"] = act.CopyMode { JumpBackward = { prev_char = false } },
    ["f"] = act.CopyMode { JumpForward = { prev_char = false } },
    ["T"] = act.CopyMode { JumpBackward = { prev_char = true } },
    ["t"] = act.CopyMode { JumpForward = { prev_char = true } },
    ["G"] = act.CopyMode "MoveToScrollbackBottom",
    ["g"] = act.CopyMode "MoveToScrollbackTop",
    ["h"] = act.CopyMode "MoveLeft",
    ["j"] = act.CopyMode "MoveDown",
    ["k"] = act.CopyMode "MoveUp",
    ["l"] = act.CopyMode "MoveRight",
    ["H"] = act.CopyMode "MoveToViewportTop",
    ["L"] = act.CopyMode "MoveToViewportBottom",
    ["M"] = act.CopyMode "MoveToViewportMiddle",
    ["V"] = act.CopyMode { SetSelectionMode = "Line" },
    ["v"] = act.CopyMode { SetSelectionMode = "Cell" },
    ["<C-v>"] = act.CopyMode { SetSelectionMode = "Block" },
    ["O"] = act.CopyMode "MoveToSelectionOtherEndHoriz",
    ["o"] = act.CopyMode "MoveToSelectionOtherEnd",
    ["b"] = act.CopyMode "MoveBackwardWord",
    ["e"] = act.CopyMode "MoveForwardWordEnd",
    ["w"] = act.CopyMode "MoveForwardWord",
    ["<C-d>"] = act.CopyMode { MoveByPage = 0.5 },
    ["<C-u>"] = act.CopyMode { MoveByPage = -0.5 },
    ["y"] = act.Multiple {
      { CopyTo = "ClipboardAndPrimarySelection" },
      {
        CopyMode = "Close",
      },
    },
  }, -- }}}

  -- {{{1 SEARCH MODE (search_mode)
  search_mode = {
    ["<ESC>"] = act.CopyMode "Close",
    ["<q>"] = act.CopyMode "Close",
    ["<CR>"] = act.CopyMode "PriorMatch",
    ["<C-n>"] = act.CopyMode "NextMatch",
    ["<C-N>"] = act.CopyMode "PriorMatch",
    ["<C-r>"] = act.CopyMode "CycleMatchType",
    ["<C-u>"] = act.CopyMode "ClearPattern",
    ["<PageUp>"] = act.CopyMode "PriorMatchPage",
    ["<PageDown>"] = act.CopyMode "NextMatchPage",
    ["<UpArrow>"] = act.CopyMode "PriorMatch",
    ["<DownArrow>"] = act.CopyMode "NextMatch",
  }, -- }}}

  -- {{{1 FONT MODE (font_mode)
  font_mode = {
    ["+"] = act.IncreaseFontSize,
    ["-"] = act.DecreaseFontSize,
    ["0"] = act.ResetFontSize,
  }, -- }}}

  -- {{{1 WINDOW MODE (window_mode)
  window_mode = {
    ["p"] = act.PaneSelect,
    ["x"] = act.PaneSelect { mode = "SwapWithActive" },
    ["q"] = act.CloseCurrentPane { confirm = true },
    ["o"] = act.TogglePaneZoomState,
    ["v"] = act.SplitHorizontal { domain = "CurrentPaneDomain" },
    ["s"] = act.SplitVertical { domain = "CurrentPaneDomain" },
    ["<LeftArrow>"] = act.ActivatePaneDirection "Left",
    ["<DownArrow>"] = act.ActivatePaneDirection "Down",
    ["<UpArrow>"] = act.ActivatePaneDirection "Up",
    ["<RightArrow>"] = act.ActivatePaneDirection "Right",
    ["h"] = act.ActivatePaneDirection "Left",
    ["j"] = act.ActivatePaneDirection "Down",
    ["k"] = act.ActivatePaneDirection "Up",
    ["l"] = act.ActivatePaneDirection "Right",
    ["<"] = act.AdjustPaneSize { "Left", 2 },
    ["<S->>"] = act.AdjustPaneSize { "Right", 2 },
    ["+"] = act.AdjustPaneSize { "Up", 2 },
    ["-"] = act.AdjustPaneSize { "Down", 2 },
  }, -- }}}

  -- {{{1 LOCK MODE (lock_mode)
  lock_mode = {
    ["<C-g>"] = "PopKeyTable",
  },
  -- }}}
}

Config.key_tables = {}
for mode, key_table in pairs(key_tables) do
  Config.key_tables[mode] = {}
  fun.map("<ESC>", "PopKeyTable", Config.key_tables[mode])
  fun.map("<C-q>", "PopKeyTable", Config.key_tables[mode])
  for lhs, rhs in pairs(key_table) do
    fun.map(lhs, rhs, Config.key_tables[mode])
  end
end

return Config


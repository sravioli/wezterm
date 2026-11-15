---@module "plugs.chord"
---@author sravioli
---@license GNU-GPLv3

local wt = require "wezterm" ---@class Wezterm
local act = wt.action
local chord = wt.plugin.require "https://github.com/sravioli/chord.wz"

chord.setup {
  hints = {
    separator = " / ",
    page_cache_prefix = "chord_hint_page",
  },

  command = {
    key = "<leader><Space>",
    desc = "key search",
    title = "Commands",
    fuzzy = true,
    description = "Select command.",
    fuzzy_description = "Search: ",
    include_registered = true,
    include_keys = true,
    include_key_tables = true,
    include_defaults = true,
    include_undocumented = false,
    dedupe = true,
    style = {
      enabled = true,
      formatter = "ribbon",
      color_by = "mode",
      include_source = true,
      include_table = true,
      mode_fg = "#1a1b26",
    },
  },

  log = {
    enabled = true,
    threshold = "warn",
  },
}

local palette_config
local leader_hints

local function active_theme(config)
  if type(config) ~= "table" or type(config.color_schemes) ~= "table" then
    return nil
  end

  return config.color_schemes[config.color_scheme]
end

local function with_theme(config, opts)
  opts = opts or {}
  opts.theme = active_theme(config)
  return opts
end

local function rename_tab_action()
  return act.PromptInputLine {
    description = "Enter new name for tab",
    action = wt.action_callback(function(window, _, line)
      if line then
        window:active_tab():set_title(line)
      end
    end),
  }
end

local function invalidate_cache_action()
  return wt.action_callback(function(_, _, _)
    require("plugs.memo").cache.clear()
  end)
end

---Config commands, shared by Chord's command picker and WezTerm's palette.
---@return table[]
local function commands()
  local lantern = require "plugs.lantern" ---@class Lantern

  return {
    {
      id = "rename-tab",
      icon = "md_rename_box",
      label = "Rename tab",
      action = rename_tab_action(),
    },
    {
      id = "lantern-colorscheme",
      icon = "md_palette",
      label = "Lantern: colorscheme",
      action = lantern.light.colorscheme(),
    },
    {
      id = "lantern-font",
      icon = "md_format_font",
      label = "Lantern: font",
      action = lantern.light.font(),
    },
    {
      id = "lantern-font-size",
      icon = "md_format_font_size_decrease",
      label = "Lantern: font size",
      action = lantern.light.font_size(),
    },
    {
      id = "lantern-font-leading",
      icon = "fa_text_height",
      label = "Lantern: line height",
      action = lantern.light.font_leading(),
    },
    {
      id = "lantern-gpu",
      icon = "md_expansion_card",
      label = "Lantern: GPU",
      action = lantern.light.gpu(),
    },
    {
      id = "lantern-window-opacity",
      icon = "md_opacity",
      label = "Lantern: window opacity",
      action = lantern.light.window_opacity(),
    },
    {
      id = "lantern-window-padding",
      icon = "md_dock_window",
      label = "Lantern: window padding",
      action = lantern.light.window_padding(),
    },
    {
      id = "lantern-cursor-style",
      icon = "md_cursor_text",
      label = "Lantern: cursor style",
      action = lantern.light.cursor_style(),
    },
    {
      id = "lantern-inactive-pane-opacity",
      icon = "md_blur_on",
      label = "Lantern: inactive pane opacity",
      action = lantern.light.inactive_pane_opacity(),
    },
    {
      id = "lantern-font-ligatures",
      icon = "md_format_text",
      label = "Lantern: font ligatures",
      action = lantern.light.font_ligatures(),
    },
    {
      id = "lantern-tab-bar-style",
      icon = "md_tab",
      label = "Lantern: tab bar style",
      action = lantern.light.tab_bar_style(),
    },
    {
      id = "invalidate-cache",
      icon = "md_cached",
      label = "Invalidate cache",
      action = invalidate_cache_action(),
    },
  }
end

local function register_commands()
  chord.command.clear()
  chord.command.register_many(commands())
end

local function command_palette_options()
  return {
    prefix = "Chord: ",
    sources = { "keys", "key_table" },
    include_defaults = false,
  }
end

local function report_conflicts(config)
  for _, conflict in ipairs(chord.conflicts(config)) do
    wt.log_warn(
      ("[Chord] duplicate binding %s in %s (%d entries)"):format(
        conflict.lhs,
        conflict.scope,
        #conflict.entries
      )
    )
  end
end

register_commands()

function chord.apply(config)
  chord.command.apply(config, with_theme(config))
  palette_config = config
  leader_hints = nil
  report_conflicts(config)

  return config
end

---Leader bindings with a description, as `{ lhs, desc, mode? }` without the
---`<leader>` prefix (`w window mode`, not `<leader>w window mode`). `mode` is
---the name of a binding described as "<name> mode".
---@return { lhs: string, desc: string, mode?: string }[]
local function leader_items()
  if leader_hints then
    return leader_hints
  end
  leader_hints = {}
  for _, entry in ipairs((palette_config or {}).keys or {}) do
    local mods = entry.mods or ""
    if mods:find("LEADER", 1, true) and entry.desc and entry.desc ~= "" then
      local copy = { key = entry.key, mods = mods:gsub("LEADER|?", ""):gsub("|$", "") }
      leader_hints[#leader_hints + 1] = {
        lhs = chord.__entry_lhs(copy),
        desc = entry.desc,
        mode = entry.desc:match "^(.-) mode$",
      }
    end
  end
  return leader_hints
end

---Leader bindings as one right-aligned hint line, without paging: the
---leader is one-shot, so a paging key would end it.
---
---Modes come first as mnemonics (`modes: [w]indow [f]ont`); the other
---bindings follow, separated by " / ". Those start as their key alone and
---gain their description's first word, then the full description, in order,
---while the line still fits.
---@param width integer columns available
---@param theme table resolved colour scheme
---@param accent string key colour
---@return table ribbon layout
function chord.leader_hint_layout(width, theme, accent)
  local ribbon = require "plugs.ribbon"
  local bg, fg = tostring(theme.tab_bar.background), tostring(theme.foreground)
  local dim = theme.brights and tostring(theme.brights[1]) or fg
  accent = tostring(accent)
  local cw = wt.column_width
  local sep, group_gap, prefix = " / ", " │ ", "modes:"

  local modes, others = {}, {}
  for _, item in ipairs(leader_items()) do
    if item.mode then
      modes[#modes + 1] = item
    else
      others[#others + 1] = item
    end
  end

  -- ── Modes: "[w]indow" when the key starts the name, else "[p] lantern".
  local function mnemonic(item)
    if item.mode:sub(1, #item.lhs):lower() == item.lhs:lower() then
      return item.mode:sub(#item.lhs + 1), cw(item.mode) + 2
    end
    return " " .. item.mode, cw(item.lhs) + 3 + cw(item.mode)
  end
  local mode_parts, used = {}, 0
  if #modes > 0 then
    local full = cw(prefix)
    for _, item in ipairs(modes) do
      local _, w = mnemonic(item)
      full = full + 1 + w
    end
    local bracket = full <= width
    used = cw(prefix)
    for _, item in ipairs(modes) do
      local rest, w = mnemonic(item)
      if not bracket then
        rest, w = nil, cw(item.lhs)
      end
      if used + 1 + w > width then
        break
      end
      mode_parts[#mode_parts + 1] = { lhs = item.lhs, rest = rest, bracket = bracket }
      used = used + 1 + w
    end
    if #mode_parts == 0 then
      used = 0
    end
  end

  -- ── Other bindings, upgraded in order while they fit.
  local function label(item, level)
    if level == 1 then
      return item.desc
    elseif level == 2 then
      return item.desc:match "^%S+" or item.desc
    end
    return nil
  end
  local function cost(item, level)
    local desc = label(item, level)
    return cw(item.lhs) + (desc and (1 + cw(desc)) or 0)
  end
  local shown = {}
  for _, item in ipairs(others) do
    local gap = #shown > 0 and sep or (used > 0 and group_gap or "")
    local need = cw(gap) + cost(item, 3)
    if used + need > width then
      break
    end
    shown[#shown + 1] = { item = item, level = 3, gap = gap }
    used = used + need
  end
  for _, level in ipairs { 2, 1 } do
    for _, entry in ipairs(shown) do
      local delta = cost(entry.item, level) - cost(entry.item, entry.level)
      if used + delta > width then
        break
      end
      entry.level, used = level, used + delta
    end
  end

  -- ── Render.
  local layout = ribbon:new("LeaderHints", true)
  local function key(lhs)
    if lhs:sub(1, 1) == "<" and lhs:sub(-1) == ">" then
      layout:append(bg, fg, "<", "Bold")
      layout:append(bg, accent, lhs:sub(2, -2), "Normal")
      layout:append(bg, fg, ">", "Bold")
    else
      layout:append(bg, accent, lhs, "Bold")
    end
  end
  if used < width then
    layout:append(bg, fg, string.rep(" ", width - used))
  end
  if #mode_parts > 0 then
    layout:append(bg, dim, prefix, "Normal")
    for _, part in ipairs(mode_parts) do
      layout:append(bg, fg, " ", "Normal")
      if part.bracket then
        layout:append(bg, fg, "[", "Bold")
        key(part.lhs)
        layout:append(bg, fg, "]", "Bold")
        layout:append(bg, fg, part.rest, "Italic")
      else
        key(part.lhs)
      end
    end
  end
  for _, entry in ipairs(shown) do
    if entry.gap ~= "" then
      layout:append(bg, dim, entry.gap, "Normal")
    end
    key(entry.item.lhs)
    local desc = label(entry.item, entry.level)
    if desc then
      layout:append(bg, fg, " " .. desc, "Italic")
    end
  end
  return layout
end

---Config commands as WezTerm command-palette entries (with icons).
---@return table[]
function chord.palette_commands()
  local entries = {}
  for _, cmd in ipairs(commands()) do
    entries[#entries + 1] = { brief = cmd.label, icon = cmd.icon, action = cmd.action }
  end
  return entries
end

function chord.palette(opts)
  return chord.command.palette(
    palette_config or {},
    with_theme(palette_config, opts or command_palette_options())
  )
end

function chord.use_harbor_status_hints()
  local harbor = require "plugs.harbor"
  harbor.set_picker_adapter {
    keys = chord.table {
      { "<C-S-A-Left>", chord.hint_action(nil, -1), "previous hints" },
      { "<C-S-A-Right>", chord.hint_action(nil, 1), "next hints" },
    },
    open = function(window, pane, session)
      return chord.temporary.begin(window, pane, {
        name = session.key_table,
        keys = session.bindings,
        meta = function(theme)
          return { i = wt.nerdfonts.md_anchor, txt = "HARBOR", bg = theme.ansi[5] }
        end,
      })
    end,
  }
end

return chord

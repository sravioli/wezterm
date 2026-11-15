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
    desc = "command picker",
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

  overlay = {
    key = "<leader>?",
    desc = "key help",
    title = "Key bindings",
    fuzzy = true,
    description = "Select binding.",
    fuzzy_description = "Search: ",
    sources = { "registered", "keys", "key_table" },
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
  chord.overlay.apply(config)
  palette_config = config
  leader_hints = nil
  report_conflicts(config)

  return config
end

---Leader bindings with a description, as `{ lhs, desc }` without the
---`<leader>` prefix (`w window mode`, not `<leader>w window mode`).
---@return { lhs: string, desc: string }[]
local function leader_items()
  if leader_hints then
    return leader_hints
  end
  leader_hints = {}
  for _, entry in ipairs((palette_config or {}).keys or {}) do
    local mods = entry.mods or ""
    if mods:find("LEADER", 1, true) and entry.desc and entry.desc ~= "" then
      local copy = { key = entry.key, mods = mods:gsub("LEADER|?", ""):gsub("|$", "") }
      leader_hints[#leader_hints + 1] =
        { lhs = chord.__entry_lhs(copy), desc = entry.desc }
    end
  end
  return leader_hints
end

---Leader bindings as one right-aligned hint line, without paging: the
---leader is one-shot, so a paging key would end it. Labels shrink to fit
---(full description, then its first word, then keys only).
---@param width integer columns available
---@param theme table resolved colour scheme
---@param accent string key colour
---@return table ribbon layout
function chord.leader_hint_layout(width, theme, accent)
  local ribbon = require "plugs.ribbon"
  local bg, fg = tostring(theme.tab_bar.background), tostring(theme.foreground)
  local dim = theme.brights and tostring(theme.brights[1]) or fg
  accent = tostring(accent)
  local sep = " / "
  local items = leader_items()

  local tiers = {
    function(item)
      return item.desc
    end,
    function(item)
      return item.desc:match "^%S+" or item.desc
    end,
    function()
      return nil
    end,
  }

  local labels, used
  for i, tier in ipairs(tiers) do
    local gap = i == #tiers and " " or sep
    labels, used = {}, 0
    for j, item in ipairs(items) do
      local desc = tier(item)
      local need = wt.column_width(item.lhs) + (desc and (1 + wt.column_width(desc)) or 0)
      if j > 1 then
        need = need + wt.column_width(gap)
      end
      if used + need > width then
        if i < #tiers then
          labels = nil
        end
        break
      end
      labels[#labels + 1] = { lhs = item.lhs, desc = desc, gap = j > 1 and gap or nil }
      used = used + need
    end
    if labels then
      break
    end
  end

  local layout = ribbon:new("LeaderHints", true)
  if used < width then
    layout:append(bg, fg, string.rep(" ", width - used))
  end
  for _, label in ipairs(labels) do
    if label.gap then
      layout:append(bg, dim, label.gap, "Normal")
    end
    local lhs = label.lhs
    if lhs:sub(1, 1) == "<" and lhs:sub(-1) == ">" then
      layout:append(bg, fg, "<", "Bold")
      layout:append(bg, accent, lhs:sub(2, -2), "Normal")
      layout:append(bg, fg, ">", "Bold")
    else
      layout:append(bg, accent, lhs, "Bold")
    end
    if label.desc then
      layout:append(bg, fg, " " .. label.desc, "Italic")
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

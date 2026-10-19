---@module "plugs.chord"
---@author sravioli
---@license GNU-GPLv3

local wt = require "wezterm" ---@class Wezterm
local act = wt.action
local chord = require "chord.api"

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

local function register_commands()
  local lantern = require "plugs.lantern" ---@class Lantern

  chord.command.clear()
  chord.command.register_many {
    {
      id = "rename-tab",
      label = "Rename tab",
      action = rename_tab_action(),
    },
    {
      id = "lantern-colorscheme",
      label = "Lantern: colorscheme",
      action = lantern.light.colorscheme(),
    },
    {
      id = "lantern-font",
      label = "Lantern: font",
      action = lantern.light.font(),
    },
    {
      id = "lantern-font-size",
      label = "Lantern: font size",
      action = lantern.light.font_size(),
    },
    {
      id = "lantern-font-leading",
      label = "Lantern: line height",
      action = lantern.light.font_leading(),
    },
    {
      id = "lantern-gpu",
      label = "Lantern: GPU",
      action = lantern.light.gpu(),
    },
    {
      id = "lantern-window-opacity",
      label = "Lantern: window opacity",
      action = lantern.light.window_opacity(),
    },
    {
      id = "lantern-window-padding",
      label = "Lantern: window padding",
      action = lantern.light.window_padding(),
    },
    {
      id = "lantern-cursor-style",
      label = "Lantern: cursor style",
      action = lantern.light.cursor_style(),
    },
    {
      id = "lantern-inactive-pane-opacity",
      label = "Lantern: inactive pane opacity",
      action = lantern.light.inactive_pane_opacity(),
    },
    {
      id = "lantern-font-ligatures",
      label = "Lantern: font ligatures",
      action = lantern.light.font_ligatures(),
    },
    {
      id = "lantern-tab-bar-style",
      label = "Lantern: tab bar style",
      action = lantern.light.tab_bar_style(),
    },
    {
      id = "invalidate-cache",
      label = "Invalidate cache",
      action = invalidate_cache_action(),
    },
  }
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
  report_conflicts(config)

  return config
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
          return { i = "H", txt = "HARBOR", bg = theme.ansi[5] }
        end,
      })
    end,
  }
end

return chord

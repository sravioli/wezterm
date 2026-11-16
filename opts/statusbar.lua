---@module 'opts.statusbar'

-- Status bar options, passed to mosaic.setup() by plugs/mosaic.lua.
-- The powerline preset supplies the built-in modules; chord's mosaic
-- integrations supply `mode` and `hints`. plugs.chord is required lazily
-- because plugs.mosaic reads this file while loading.

---@type Mosaic.Options
return {
  enabled = true,
  position = "bottom",
  preset = "powerline",
  fit = "exhaustive",

  layout = {
    left = { "leader", "zoomed", "workspace", "harbor.session", "mode" },
    center = { "notice" },
    right = { "hints", "beacon.update", { "cwd", "hostname", "clock", "battery" } },
  },

  -- mosaic draws the tabs in the preset's style; utils/tab-title.lua supplies
  -- the title text (Copilot, shells, Neovim rules).
  tabs = {
    title = function(tab, max_cells)
      return require "utils.tab-title"(tab, max_cells)
    end,
    content = { "progress", "title" },
    badges = true,
  },

  -- beacon's update count stays plain text, outside the powerline gradient.
  style = { raw = { "beacon.update" } },

  -- chord's mosaic integrations fill the preset's `mode` and `hints` slots.
  modules = { mode = "chord.mode", hints = "chord.hints" },

  options = {
    ["chord.hints"] = {
      -- Leader held: list the leader bindings (modes, pickers, ...).
      leader = function(width, theme)
        return require("plugs.chord").leader_hint_layout(width, theme, theme.ansi[2])
      end,
    },
  },
}

-- ---@module "events.update-status"
--
-- local wt = require "wezterm" ---@class Wezterm
-- local Opts = require("opts").statusbar ---@class Opts.StatusBar
-- local sbr = require "utils.renderer" ---@class Renderer
-- local cleared = false
--
-- wt.on("update-status", function(window, pane)
--   if not Opts.enabled then
--     if not cleared then
--       window:set_left_status ""
--       window:set_right_status ""
--     end
--     return
--   end
--
--   local Config, Overrides = window:effective_config(), window:get_config_overrides() or {}
--   local theme = Config.color_schemes[Overrides.color_scheme or Config.color_scheme]
--   sbr.init(Config, window, pane, theme)
--
--   window:set_left_status(sbr.render_layout(Opts.layout.left))
--   window:set_right_status(sbr.render_layout(Opts.layout.right))
-- end)

---@module "events.update-status"

local wt = require "wezterm" ---@class Wezterm
local Opts = require("opts").statusbar ---@class Opts.StatusBar
local sbr = require "utils.renderer" ---@class Renderer
local tab_bar = require "utils.tab-bar"

local cleared = false

wt.on("update-status", function(window, pane)
  -- ── Disabled ─────────────────────────────────────────────────────────────
  if not Opts.enabled then
    if not cleared then
      window:set_left_status ""
      window:set_right_status ""
      cleared = true
    end
    return
  end
  cleared = false

  local Config = window:effective_config()
  local Overrides = window:get_config_overrides() or {}
  local theme = Config.color_schemes[Overrides.color_scheme or Config.color_scheme]

  -- ── Left status ──────────────────────────────────────────────────────────
  -- Render with the full terminal width so every module gets a fair shot at
  -- the flexible fallback chain.  We measure what was actually consumed
  -- afterwards.
  sbr.init(Config, window, pane, theme)

  local total_cols = sbr.width.available -- save before second init()
  local left = sbr.render_layout(Opts.layout.left)
  local left_used = sbr.width.used

  -- ── Right status (width-constrained) ─────────────────────────────────────
  -- Actual tab-bar column usage comes from `format-tab-title` via the shared
  -- `tab_bar` module — no duplicated formatting logic here.
  --
  --   available = total_cols − left_status_cols − tab_bar_cols
  --
  -- floor at 0 so the renderer never receives a negative budget.
  local right_avail = math.max(0, total_cols - left_used - tab_bar.total_width())
  right_avail = right_avail - (Config.show_new_tab_button_in_tab_bar and 8 or 0)

  sbr.init(Config, window, pane, theme, right_avail)
  local right = sbr.render_layout(Opts.layout.right)

  window:set_left_status(left)
  sbr.commit_left()
  window:set_right_status(right)
end)

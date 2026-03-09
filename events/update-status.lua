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
local budget = require "utils.bar-budget" ---@class BarBudget

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

  -- Seed the tab count so the cold-start estimator in `budget.total_width()`
  -- has the real count even if `format-tab-title` hasn't fired yet.
  budget.set_count(#window:mux_window():tabs())

  -- ── Single init: full terminal width ─────────────────────────────────────
  sbr.init(Config, window, pane, theme)

  -- ── Left status ──────────────────────────────────────────────────────────
  local left = sbr.render_layout(Opts.layout.left)

  -- ── Phase transition ─────────────────────────────────────────────────────
  -- Publishes _left_used and _new_tab_button, then recalculates the right-
  -- status budget from `budget.right_available()`.  No second init() needed.
  sbr.commit_left()

  -- ── Right status ─────────────────────────────────────────────────────────
  local right = sbr.render_layout(Opts.layout.right)

  window:set_left_status(left)
  window:set_right_status(right)
end)

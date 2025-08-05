---@module "events.format-tab-title"
---@author sravioli
---@license GNU-GPLv3

---@diagnostic disable: undefined-field

local wt = require "wezterm"

local Utils = require "utils"
local str = Utils.fn.str
local Icon = Utils.class.icon
local tabicons = Icon.Sep.tb

wt.on("format-tab-title", function(tab, _, _, config, hover, max_width)
  if config.use_fancy_tab_bar or not config.enable_tab_bar then
    return
  end

  -- Cache expensive lookups
  local cache_key = config.color_scheme .. "_theme"
  local theme = wt.GLOBAL.cache and wt.GLOBAL.cache[cache_key]
  if not theme then
    theme = config.color_schemes[config.color_scheme]
    if wt.GLOBAL.cache then
      wt.GLOBAL.cache[cache_key] = theme
    end
  end

  local bg = theme.tab_bar.background
  local fg
  local tab_idx = tab.tab_index
  local attributes = {}

  -- Set colors based on states (most expensive operations first)
  if tab.is_active then
    fg = theme.ansi[5]
    attributes = { "Bold" }
  elseif hover then
    fg = theme.tab_bar.inactive_tab_hover.bg_color
  else
    fg = theme.brights[1]
  end

  -- Early exit pattern - check for unseen output only when needed
  local unseen_output = false
  if tab.panes then
    for i = 1, #tab.panes do
      if tab.panes[i].has_unseen_output then
        unseen_output = true
        break
      end
    end
  end

  local Title = Utils.class.layout:new "TabTitle"

  local pane = tab.active_pane
  local tab_title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or pane.title
  local title = str.format_tab_title(pane, tab_title, config, max_width)

  -- Build title components efficiently
  Title:append(bg, fg, tab_idx == 0 and tabicons.leftmost or tabicons.left, attributes)
  Title:append(
    fg,
    bg,
    (unseen_output and Icon.Notification or Icon.Nums[tab_idx + 1] or "") .. " ",
    attributes
  )
  Title:append(fg, bg, title, attributes)
  Title:append(bg, fg, Icon.Sep.block .. tabicons.right, attributes)

  return Title
end)

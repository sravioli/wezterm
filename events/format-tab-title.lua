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

  local theme = config.color_schemes[config.color_scheme]
  local bg = theme.tab_bar.background
  local fg

  local Title = Utils.class.layout:new "TabTitle"

  local tab_idx = tab.tab_index
  local attributes = {}

  ---set colors based on states
  if tab.is_active then
    fg = theme.ansi[5]
    attributes = { "Bold" }
  elseif hover then
    fg = theme.tab_bar.inactive_tab_hover.bg_color
  else
    fg = theme.brights[1]
  end

  ---Check if any pane has unseen output
  local unseen_output = false
  for _, p in ipairs(tab.panes) do
    if p.has_unseen_output then
      unseen_output = true
      break
    end
  end

  local pane = tab.active_pane
  local tab_title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or pane.title
  local title = str.format_tab_title(pane, tab_title, config, max_width)

  ---add the either the leftmost element or the normal left separator. This is done to
  ---esure a bit of space from the left margin.
  Title:append(bg, fg, tab_idx == 0 and tabicons.leftmost or tabicons.left, attributes)

  ---add the tab number. can be substituted by the `has_unseen_output` notification
  Title:append(
    fg,
    bg,
    (unseen_output and Icon.Notification or Icon.Nums[tab_idx + 1] or "") .. " ",
    attributes
  )

  ---the formatted tab title
  Title:append(fg, bg, title, attributes)

  ---the right tab bar separator
  Title:append(bg, fg, Icon.Sep.block .. tabicons.right, attributes)

  return Title
end)

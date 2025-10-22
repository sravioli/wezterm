-- balance-panes.lua
-- Based on: https://gist.github.com/fcpg/eb3c05be5b480f4cad767199dac5cecd

local wezterm = require("wezterm")
local module = {}

--- Walk panes that are on the same axis as the tab's active pane
local function walk_siblings(axis, tab, window, pane, do_func)
  local initial_pane = pane
  local siblings = { (do_func and do_func(initial_pane) or initial_pane) }
  local prev_dir = axis == "x" and "Left" or "Up"
  local next_dir = axis == "x" and "Right" or "Down"
  local max_iter = 20 -- prevent infinite loops

  local initial_pane_idx = 1
  local panes_info = tab:panes_with_info()
  for _, pi in ipairs(panes_info) do
    if pi.is_active then
      initial_pane_idx = pi.index
    end
  end

  -- Loop on siblings backward and forward, starting from initial pane
  for _, step_dir in ipairs { "prev", "next" } do
    local last_pane = tab:active_pane()
    window:perform_action(
      wezterm.action.ActivatePaneDirection(step_dir == "prev" and prev_dir or next_dir),
      tab:active_pane()
    )
    local new_pane = tab:active_pane()

    local i = 0
    while new_pane:pane_id() ~= last_pane:pane_id() and i < max_iter do
      if step_dir == "prev" then
        table.insert(siblings, 1, (do_func and do_func(new_pane) or new_pane))
      else
        table.insert(siblings, (do_func and do_func(new_pane) or new_pane))
      end
      last_pane = tab:active_pane()
      window:perform_action(
        wezterm.action.ActivatePaneDirection(step_dir == "prev" and prev_dir or next_dir),
        tab:active_pane()
      )
      new_pane = tab:active_pane()
      i = i + 1
    end

    -- Back to initial pane
    window:perform_action(
      wezterm.action.ActivatePaneByIndex(initial_pane_idx),
      tab:active_pane()
    )
  end

  return siblings
end

function module.balance_panes(axis)
  return function(window, pane)
    local tab = window:active_tab()
    local siblings = walk_siblings(axis, tab, window, pane)
    local tab_size = tab:get_size()[axis == "x" and "cols" or "rows"]
    local balanced_size = math.floor(tab_size / #siblings)
    local pane_size_key = axis == "x" and "cols" or "viewport_rows"
    local prev_dir = axis == "x" and "Left" or "Up"
    local next_dir = axis == "x" and "Right" or "Down"

    wezterm.log_info(
      string.format(
        "Resizing %s panes on %s axis to %s cells",
        #siblings,
        axis,
        balanced_size
      )
    )

    walk_siblings(axis, tab, window, pane, function(pane)
      local pane_size = pane:get_dimensions()[pane_size_key]
      local adj_amount = pane_size - balanced_size
      local adj_dir = adj_amount < 0 and next_dir or prev_dir
      adj_amount = math.abs(adj_amount)

      wezterm.log_info(
        string.format(
          "Adjusting pane [%s] from %s by %s cells %s",
          pane,
          tostring(pane_size),
          tostring(adj_amount),
          adj_dir
        )
      )

      window:perform_action(
        wezterm.action.AdjustPaneSize({ adj_dir, adj_amount }),
        pane
      )
    end)
  end
end

return module

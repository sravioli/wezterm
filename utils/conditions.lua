---@module "utils.conditions"

---@class Conditions
local M = {}

---Return true unconditionally.
---
---@return boolean
M.always = function()
  return true
end

---Return false unconditionally.
---
---@return boolean
M.never = function()
  return false
end

---Combine conditions with logical AND.
---
---@param ... fun(window: table, pane: table): boolean List of condition functions.
---@return fun(window: table, pane: table): boolean logic_gate Function returning true if all conditions pass.
M.all = function(...)
  local conditions = { ... }
  return function(window, pane)
    for _, condition in ipairs(conditions) do
      if not condition(window, pane) then
        return false
      end
    end
    return true
  end
end

---Combine conditions with logical OR.
---
---@param ... fun(window: table, pane: table): boolean List of condition functions.
---@return fun(window: table, pane: table): boolean logic_gate Function returning true if any condition passes.
M.any = function(...)
  local conditions = { ... }
  return function(window, pane)
    for _, condition in ipairs(conditions) do
      if condition(window, pane) then
        return true
      end
    end
    return false
  end
end

---Invert a condition result.
---
---@param condition fun(window: table, pane: table): boolean Condition to invert.
---@return fun(window: table, pane: table): boolean logic_gate Function returning the inverse result.
M.not_ = function(condition)
  return function(window, pane)
    return not condition(window, pane)
  end
end

---Check whether any key table is active.
---
---@param window table WezTerm window object.
---@param _ any Unused pane parameter.
---@return boolean active True if a key table is active.
M.mode_active = function(window, _)
  return window:active_key_table() ~= nil
end

---Check whether no key table is active.
---
---@param window table WezTerm window object.
---@param _ any Unused pane parameter.
---@return boolean inactive True if no key table is active.
M.mode_inactive = function(window, _)
  return window:active_key_table() == nil
end

---Check whether no key hints are showing: no key table and no leader.
---
---@param window table WezTerm window object.
---@param _ any Unused pane parameter.
---@return boolean idle True when neither a key table nor the leader is active.
M.hints_inactive = function(window, _)
  return window:active_key_table() == nil and window:leader_is_active() ~= true
end

---Check whether the active workspace name is not empty.
---
---@param window table WezTerm window object.
---@param _ any Unused pane parameter.
---@return boolean active True if a workspace is active.
M.has_workspace = function(window, _)
  return window:active_workspace() ~= ""
end

---Check whether the active workspace name is empty.
---
---@param window table WezTerm window object.
---@param _ any Unused pane parameter.
---@return boolean inactive True if no workspace is active.
M.is_default_workspace = function(window, _)
  return window:active_workspace() == ""
end

---Check whether the leader key is active.
---
---@param window table WezTerm window object.
---@param _ any Unused pane parameter.
---@return boolean active True if leader is active.
M.leader_active = function(window, _)
  return window:leader_is_active() == true
end

---Check whether the leader key is inactive.
---
---@param window table WezTerm window object.
---@param _ any Unused pane parameter.
---@return boolean inactive True if leader is inactive.
M.leader_inactive = function(window, _)
  return window:leader_is_active() == false
end

---Evaluate a function condition, or return a static value as-is.
---
---@param cond any Function to evaluate or static boolean value.
---@param window table WezTerm window object.
---@param pane table WezTerm pane object.
---@return any result Result of function evaluation or raw value.
M.predicate = function(cond, window, pane)
  if type(cond) == "function" then
    return cond(window, pane)
  end
  return cond
end

return M

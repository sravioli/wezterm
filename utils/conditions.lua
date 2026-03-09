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

---Invert result of a condition via logical NOT.
---
---@param condition fun(window: table, pane: table): boolean Condition to invert.
---@return fun(window: table, pane: table): boolean logic_gate Function returning inverse of input condition.
M.not_ = function(condition)
  return function(window, pane)
    return not condition(window, pane)
  end
end

---Check if any key table is currently active.
---
---@param window table WezTerm window object.
---@param _ any Unused pane parameter.
---@return boolean active True if a key table is active.
M.mode_active = function(window, _)
  return window:active_key_table() ~= nil
end

---Check if no key table is currently active.
---
---@param window table WezTerm window object.
---@param _ any Unused pane parameter.
---@return boolean inactive True if no key table is active.
M.mode_inactive = function(window, _)
  return window:active_key_table() == nil
end

---Check if workspace name is not empty.
---
---@param window table WezTerm window object.
---@param _ any Unused pane parameter.
---@return boolean active True if a workspace is active.
M.has_workspace = function(window, _)
  return window:active_workspace() ~= ""
end

---Check if workspace name is empty.
---
---@param window table WezTerm window object.
---@param _ any Unused pane parameter.
---@return boolean inactive True if no workspace is active.
M.is_default_workspace = function(window, _)
  return window:active_workspace() == ""
end

---Check if leader key is currently active.
---
---@param window table WezTerm window object.
---@param _ any Unused pane parameter.
---@return boolean active True if leader is active.
M.leader_active = function(window, _)
  return window:leader_is_active() == true
end

---Check if leader key is currently inactive.
---
---@param window table WezTerm window object.
---@param _ any Unused pane parameter.
---@return boolean inactive True if leader is inactive.
M.leader_inactive = function(window, _)
  return window:leader_is_active() == false
end

---Evaluate condition if it is a function, otherwise return value directly.
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

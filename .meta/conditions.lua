---@meta utils.Conditions
error "cannot require a meta file!"

-- luacheck: push ignore 631 (line is too long)

---Boolean condition functions for status bar visibility and key-table state.
---
---Provide composable logical combinators (`all`, `any`, `not_`) and concrete
---predicates for leader key state, active mode (key table), and workspace
---presence.
---
---@alias Conditions.Predicate  fun(window: table, pane: table): boolean
---@alias Conditions.Combinator fun(...: Conditions.Predicate): Conditions.Predicate
---@alias Conditions.Negator    fun(condition: Conditions.Predicate): Conditions.Predicate
---@alias Conditions.Evaluator  fun(cond: any, window: table, pane: table): any
---
---@class Conditions
---@field public always               Conditions.Predicate  Always returns true.
---@field public never                Conditions.Predicate  Always returns false.
---@field public all                  Conditions.Combinator Combine conditions with logical AND.
---@field public any                  Conditions.Combinator Combine conditions with logical OR.
---@field public not_                 Conditions.Negator    Invert a condition via logical NOT.
---@field public mode_active          Conditions.Predicate  True if a key table is currently active.
---@field public mode_inactive        Conditions.Predicate  True if no key table is active.
---@field public has_workspace        Conditions.Predicate  True if workspace name is non-empty.
---@field public is_default_workspace Conditions.Predicate  True if workspace name is empty.
---@field public leader_active        Conditions.Predicate  True if leader key is active.
---@field public leader_inactive      Conditions.Predicate  True if leader key is inactive.
---@field public predicate            Conditions.Evaluator  Evaluate a function condition or return the value directly.

-- luacheck: pop

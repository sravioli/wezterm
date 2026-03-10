---@module "utils.logger.sinks.memory"

---@class Logger.Sinks.MemorySink
local M = {}
M.__index = M

---Create new memory sink instance.
---
---@return Logger.Sinks.MemorySink
function M.new()
  return setmetatable({
    entries = {},
  }, M)
end

---Store event in memory.
---
---@param event Logger.Event Log event to store.
function M:write(event)
  table.insert(self.entries, event)
end

---Remove all stored log entries.
function M:clear()
  self.entries = {}
end

---Return shallow copy of stored entries.
---
---@return Logger.Event[] entries Copy of stored log events.
function M:get_entries()
  local copy = {}
  for i = 1, #self.entries do
    copy[i] = self.entries[i]
  end
  return copy
end

---Get number of entries in memory.
---
---@return integer count Number of stored entries.
function M:count()
  return #self.entries
end

---Stringify all entries into human-readable lines.
---
---Formats entries as `[LEVEL] Message`, separated by newlines.
---
---@return string formatted_log Concatenated string of all log entries.
function M:to_string()
  local out = {}
  for i = 1, #self.entries do
    local e = self.entries[i]
    table.insert(out, ("[%s] %s"):format(e.level_name, e.message))
  end
  return table.concat(out, "\n")
end

---Return actual sink function expected by logger.
---
---Creates a closure wrapping the `write` method.
---
---@return fun(entry: Logger.Event) sink_fn Sink function compatible with Logger.
function M:sink()
  return function(event)
    self:write(event)
  end
end

return M

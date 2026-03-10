---@meta utils.Logger.Sinks.MemorySink
error "cannot require a meta file!"

-- luacheck: push ignore 631 (line is too long)

---In-memory log event storage.
---
---Collect log events in a list for later inspection, testing, or serialisation.
---
---### Example Usage
---~~~lua
---local MemorySink = require("utils.logger.sinks.memory")
---local mem = MemorySink.new()
---local log = require("utils.logger"):new("Test", true, { mem:sink() })
---log:info("hello %s", "world")
---print(mem:count())      -- 1
---print(mem:to_string())  -- [INFO] [Test] hello "world"
---~~~
---
---@class Logger.Sinks.MemorySink
---@field public entries Logger.Event[] List of stored log events.

-- luacheck: pop

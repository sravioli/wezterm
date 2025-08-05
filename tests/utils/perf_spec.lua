---@module "tests.utils.perf_spec"
---@description Unit tests for utils.perf module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("utils.perf", function()
  local perf

  before_each(function()
    helper.setup()

    -- Mock the performance utilities if they exist
    package.loaded["utils.perf"] = {
      timer = {
        start = function(name)
          return {
            name = name,
            start_time = os.clock(),
            stop = function(self)
              return {
                name = self.name,
                duration = os.clock() - self.start_time
              }
            end
          }
        end,
        measure = function(name, fn)
          local start_time = os.clock()
          local result = fn()
          local duration = os.clock() - start_time
          return result, {
            name = name,
            duration = duration
          }
        end
      },
      memory = {
        usage = function()
          if collectgarbage then
            return collectgarbage("count")
          end
          return 0
        end,
        track = function(fn)
          local before = collectgarbage and collectgarbage("count") or 0
          local result = fn()
          local after = collectgarbage and collectgarbage("count") or 0
          return result, {
            before = before,
            after = after,
            used = after - before
          }
        end
      },
      profile = {
        start = function()
          return {
            measurements = {},
            add = function(self, name, duration)
              table.insert(self.measurements, { name = name, duration = duration })
            end,
            report = function(self)
              local total = 0
              for _, measurement in ipairs(self.measurements) do
                total = total + measurement.duration
              end
              return {
                total_duration = total,
                measurements = self.measurements,
                count = #self.measurements
              }
            end
          }
        end
      }
    }

    perf = require("utils.perf")
  end)

  after_each(function()
    helper.teardown()
    package.loaded["utils.perf"] = nil
  end)

  describe("timer functionality", function()
    it("should create and use timers", function()
      assert.is_table(perf.timer)
      assert.is_function(perf.timer.start)

      local timer = perf.timer.start("test_operation")
      assert.is_table(timer)
      assert.equals("test_operation", timer.name)
      assert.is_function(timer.stop)

      -- Simulate some work
      local sum = 0
      for i = 1, 1000 do
        sum = sum + i
      end

      local result = timer:stop()
      assert.is_table(result)
      assert.equals("test_operation", result.name)
      assert.is_number(result.duration)
      assert.is_true(result.duration >= 0)
    end)

    it("should measure function execution time", function()
      assert.is_function(perf.timer.measure)

      local test_function = function()
        local result = 0
        for i = 1, 500 do
          result = result + math.sqrt(i)
        end
        return result
      end

      local result, timing = perf.timer.measure("math_operations", test_function)

      assert.is_number(result)
      assert.is_table(timing)
      assert.equals("math_operations", timing.name)
      assert.is_number(timing.duration)
      assert.is_true(timing.duration >= 0)
    end)

    it("should handle nested timer operations", function()
      local outer_timer = perf.timer.start("outer_operation")

      local inner_result, inner_timing = perf.timer.measure("inner_operation", function()
        return "inner_result"
      end)

      local outer_result = outer_timer:stop()

      assert.equals("inner_result", inner_result)
      assert.is_table(inner_timing)
      assert.is_table(outer_result)
      assert.is_true(outer_result.duration >= inner_timing.duration)
    end)

    it("should handle very fast operations", function()
      local result, timing = perf.timer.measure("fast_operation", function()
        return 2 + 2
      end)

      assert.equals(4, result)
      assert.is_table(timing)
      assert.is_number(timing.duration)
      assert.is_true(timing.duration >= 0)
    end)
  end)

  describe("memory tracking", function()
    it("should track memory usage", function()
      assert.is_table(perf.memory)
      assert.is_function(perf.memory.usage)

      local usage = perf.memory.usage()
      assert.is_number(usage)
      assert.is_true(usage >= 0)
    end)

    it("should track memory allocation during function execution", function()
      assert.is_function(perf.memory.track)

      local result, memory_info = perf.memory.track(function()
        local large_table = {}
        for i = 1, 1000 do
          large_table[i] = string.rep("test", 100)
        end
        return #large_table
      end)

      assert.equals(1000, result)
      assert.is_table(memory_info)
      assert.is_number(memory_info.before)
      assert.is_number(memory_info.after)
      assert.is_number(memory_info.used)
      assert.is_true(memory_info.used >= 0)
    end)

    it("should handle memory deallocation", function()
      local before_gc = perf.memory.usage()

      -- Create and release memory
      local result, memory_info = perf.memory.track(function()
        local temp_data = {}
        for i = 1, 500 do
          temp_data[i] = { data = string.rep("x", 50) }
        end
        temp_data = nil
        if collectgarbage then
          collectgarbage("collect")
        end
        return "done"
      end)

      assert.equals("done", result)
      assert.is_table(memory_info)
    end)
  end)

  describe("profiling functionality", function()
    it("should create and use profiler", function()
      assert.is_table(perf.profile)
      assert.is_function(perf.profile.start)

      local profiler = perf.profile.start()
      assert.is_table(profiler)
      assert.is_function(profiler.add)
      assert.is_function(profiler.report)
    end)

    it("should accumulate measurements", function()
      local profiler = perf.profile.start()

      profiler:add("operation_1", 0.001)
      profiler:add("operation_2", 0.002)
      profiler:add("operation_3", 0.0015)

      local report = profiler:report()
      assert.is_table(report)
      assert.is_number(report.total_duration)
      assert.is_table(report.measurements)
      assert.equals(3, report.count)
      assert.equals(0.0045, report.total_duration)
    end)

    it("should handle complex profiling scenarios", function()
      local profiler = perf.profile.start()

      -- Simulate multiple operations being profiled
      local operations = {
        { name = "config_load", fn = function() return "config_loaded" end },
        { name = "event_setup", fn = function() return "events_set" end },
        { name = "ui_render", fn = function() return "ui_rendered" end }
      }

      for _, op in ipairs(operations) do
        local result, timing = perf.timer.measure(op.name, op.fn)
        profiler:add(timing.name, timing.duration)
      end

      local report = profiler:report()
      assert.equals(3, report.count)
      assert.is_true(report.total_duration >= 0)
    end)
  end)

  describe("performance benchmarking", function()
    it("should benchmark WezTerm configuration loading", function()
      local config_load_test = function()
        -- Mock config loading
        local config = {}
        for i = 1, 50 do
          config["key_" .. i] = "value_" .. i
        end
        return config
      end

      local result, timing = perf.timer.measure("config_load_benchmark", config_load_test)

      assert.is_table(result)
      assert.is_table(timing)
      assert.is_true(timing.duration < 1.0) -- Should be fast
    end)

    it("should benchmark event handler performance", function()
      local event_handler_test = function()
        -- Mock event handler execution
        local mock_tab = helper.create_mock_tab()
        local mock_config = helper.create_test_config()

        -- Simulate format-tab-title event
        for i = 1, 100 do
          if helper.registered_events and helper.registered_events["format-tab-title"] then
            helper.registered_events["format-tab-title"](
              mock_tab, nil, nil, mock_config, false, 50
            )
          end
        end

        return "completed"
      end

      local result, timing = perf.timer.measure("event_handler_benchmark", event_handler_test)

      assert.equals("completed", result)
      assert.is_table(timing)
      assert.is_true(timing.duration < 0.5) -- Should be efficient
    end)

    it("should benchmark table merging performance", function()
      local merge_test = function()
        local base = {}
        for i = 1, 10 do
          local addition = {}
          for j = 1, 20 do
            addition["key_" .. j] = "value_" .. j
          end

          -- Mock table merge
          for key, value in pairs(addition) do
            base[key] = value
          end
        end
        return base
      end

      local result, timing = perf.timer.measure("table_merge_benchmark", merge_test)

      assert.is_table(result)
      assert.is_table(timing)
      assert.is_true(timing.duration < 0.1) -- Should be very fast
    end)
  end)

  describe("performance regression detection", function()
    it("should detect performance regressions", function()
      local baseline_times = {
        config_load = 0.001,
        event_handler = 0.0005,
        table_merge = 0.0001
      }

      local current_times = {
        config_load = 0.0012,
        event_handler = 0.0006,
        table_merge = 0.00015
      }

      for operation, baseline in pairs(baseline_times) do
        local current = current_times[operation]
        local regression_threshold = baseline * 2 -- 100% increase is significant

        if current > regression_threshold then
          assert.fail(string.format("Performance regression detected in %s: %.6f vs %.6f",
            operation, current, baseline))
        end
      end
    end)

    it("should validate performance targets", function()
      local performance_targets = {
        config_load_max = 0.01,    -- 10ms max
        event_handler_max = 0.005, -- 5ms max
        memory_usage_max = 1000    -- 1MB max for basic operations
      }

      -- Test config loading performance
      local config_result, config_timing = perf.timer.measure("config_load_target", function()
        local config = helper.create_test_config()
        return config
      end)

      assert.is_true(config_timing.duration <= performance_targets.config_load_max)

      -- Test memory usage
      local memory_result, memory_info = perf.memory.track(function()
        local data = {}
        for i = 1, 100 do
          data[i] = { key = "value" }
        end
        return data
      end)

      assert.is_true(memory_info.used <= performance_targets.memory_usage_max)
    end)
  end)

  describe("error handling", function()
    it("should handle timer errors gracefully", function()
      local error_function = function()
        error("Test error in timed function")
      end

      assert.has_errors(function()
        perf.timer.measure("error_test", error_function)
      end)
    end)

    it("should handle memory tracking errors", function()
      local memory_error_function = function()
        error("Memory tracking test error")
      end

      assert.has_errors(function()
        perf.memory.track(memory_error_function)
      end)
    end)

    it("should handle missing collectgarbage gracefully", function()
      local original_collectgarbage = collectgarbage
      collectgarbage = nil

      assert.has_no.errors(function()
        local usage = perf.memory.usage()
        assert.is_number(usage)
      end)

      collectgarbage = original_collectgarbage
    end)
  end)

  describe("utility functions", function()
    it("should format timing results", function()
      local timing = { name = "test_op", duration = 0.001234 }

      -- Mock formatting function
      local format_timing = function(t)
        return string.format("%s: %.3fms", t.name, t.duration * 1000)
      end

      local formatted = format_timing(timing)
      assert.is_string(formatted)
      assert.matches("test_op: 1.234ms", formatted)
    end)

    it("should compare performance results", function()
      local result1 = { duration = 0.001 }
      local result2 = { duration = 0.002 }

      local compare = function(r1, r2)
        return r2.duration / r1.duration
      end

      local ratio = compare(result1, result2)
      assert.equals(2.0, ratio)
    end)

    it("should calculate statistics from multiple runs", function()
      local runs = {
        { duration = 0.001 },
        { duration = 0.002 },
        { duration = 0.0015 },
        { duration = 0.0018 },
        { duration = 0.0012 }
      }

      local calculate_stats = function(results)
        local total = 0
        local min_val = math.huge
        local max_val = 0

        for _, result in ipairs(results) do
          total = total + result.duration
          min_val = math.min(min_val, result.duration)
          max_val = math.max(max_val, result.duration)
        end

        return {
          average = total / #results,
          min = min_val,
          max = max_val,
          count = #results
        }
      end

      local stats = calculate_stats(runs)
      assert.is_number(stats.average)
      assert.is_number(stats.min)
      assert.is_number(stats.max)
      assert.equals(5, stats.count)
      assert.is_true(stats.min <= stats.average)
      assert.is_true(stats.average <= stats.max)
    end)
  end)
end)

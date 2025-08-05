---@module "tests.run_tests"
---@description Test runner for WezTerm configuration
---@author Test Suite

-- Test runner using busted framework
-- This file sets up and runs all tests for the WezTerm configuration

local helper = require("tests.spec_helper")

-- Configuration for test runner
local config = {
  verbose = true,
  pattern = "_spec%.lua$",
  recursive = true,
  coverage = false,
  shuffle = false,
  seed = nil,
  output = "terminal"
}

-- Test suites to run (in order)
local test_suites = {
  -- Core utility tests
  "tests.utils.fn_spec",
  "tests.utils.init_spec",
  "tests.utils.perf_spec",
  "tests.utils.gpu_spec",
  "tests.utils.class.config_spec",
  "tests.utils.class.logger_spec",
  "tests.utils.class.picker_spec",
  "tests.utils.class.icon_spec",
  "tests.utils.class.layout_spec",
  "tests.utils.external.inspect_spec",

  -- Configuration module tests
  "tests.config.init_spec",
  "tests.config.appearance_spec",
  "tests.config.font_spec",
  "tests.config.tab-bar_spec",
  "tests.config.general_spec",
  "tests.config.gpu_spec",

  -- Event handler tests
  "tests.events.format-tab-title_spec",
  "tests.events.update-status_spec",
  "tests.events.format-window-title_spec",
  "tests.events.new-tab-button-click_spec",
  "tests.events.augment-command-palette_spec",

  -- Mapping tests
  "tests.mappings.init_spec",
  "tests.mappings.default_spec",
  "tests.mappings.modes_spec",

  -- Picker tests
  "tests.picker.colorscheme_spec",
  "tests.picker.font_spec",
  "tests.picker.font-size_spec",
  "tests.picker.font-leading_spec",

  -- Picker asset tests
  "tests.picker.assets.font-leadings.font-leadings_spec",
  "tests.picker.assets.font-sizes.font-sizes_spec",
  "tests.picker.assets.fonts.reset_spec",
  "tests.picker.assets.fonts.jetbrains-mono-nf_spec",

  -- Integration tests
  "tests.integration.picker_workflow_spec",
  "tests.integration.configuration_system_spec",

  -- Stress tests
  "tests.stress.system_resilience_spec",

  -- Main configuration test
  "tests.wezterm_spec"
}

-- Test statistics
local stats = {
  suites_run = 0,
  tests_run = 0,
  tests_passed = 0,
  tests_failed = 0,
  errors = {}
}

-- Helper function to run a single test suite
local function run_test_suite(suite_name)
  local success, result = pcall(require, suite_name)

  if not success then
    table.insert(stats.errors, {
      suite = suite_name,
      error = result,
      type = "load_error"
    })
    print(string.format("❌ Failed to load test suite: %s", suite_name))
    print(string.format("   Error: %s", result))
    return false
  end

  stats.suites_run = stats.suites_run + 1
  print(string.format("✅ Loaded test suite: %s", suite_name))
  return true
end

-- Helper function to validate test environment
local function validate_environment()
  local checks = {
    {
      name = "Lua version",
      check = function() return _VERSION end,
      expected = "string"
    },
    {
      name = "Package path",
      check = function() return package.path end,
      expected = "string"
    },
    {
      name = "Helper module",
      check = function() return type(helper) end,
      expected = "table"
    },
    {
      name = "Mock WezTerm",
      check = function() return type(helper.mock_wezterm) end,
      expected = "table"
    }
  }

  local all_passed = true

  for _, check in ipairs(checks) do
    local result = check.check()
    local type_result = type(result)
    local passed = type_result == check.expected

    if passed then
      print(string.format("✅ %s: %s", check.name, tostring(result)))
    else
      print(string.format("❌ %s: expected %s, got %s (%s)",
        check.name, check.expected, type_result, tostring(result)))
      all_passed = false
    end
  end

  return all_passed
end

-- Main test runner function
local function run_all_tests()
  print("=" * 60)
  print("WezTerm Configuration Test Suite")
  print("=" * 60)

  -- Validate test environment
  print("\n🔍 Validating test environment...")
  if not validate_environment() then
    print("\n❌ Test environment validation failed!")
    return false
  end

  -- Setup test environment
  print("\n⚙️  Setting up test environment...")
  helper.setup()

  -- Run test suites
  print(string.format("\n🧪 Running %d test suites...", #test_suites))

  local suites_passed = 0
  local suites_failed = 0

  for i, suite_name in ipairs(test_suites) do
    print(string.format("\n[%d/%d] Running %s", i, #test_suites, suite_name))

    if run_test_suite(suite_name) then
      suites_passed = suites_passed + 1
    else
      suites_failed = suites_failed + 1
    end

    -- Clean up after each suite
    helper.teardown()
    helper.setup()
  end

  -- Final cleanup
  helper.teardown()

  -- Print summary
  print("\n" .. "=" * 60)
  print("Test Summary")
  print("=" * 60)
  print(string.format("Suites run: %d", stats.suites_run))
  print(string.format("Suites passed: %d", suites_passed))
  print(string.format("Suites failed: %d", suites_failed))

  if #stats.errors > 0 then
    print(string.format("\n❌ %d errors occurred:", #stats.errors))
    for i, error_info in ipairs(stats.errors) do
      print(string.format("  %d. %s (%s): %s",
        i, error_info.suite, error_info.type, error_info.error))
    end
  end

  local success_rate = suites_passed / #test_suites * 100
  print(string.format("\nSuccess rate: %.1f%%", success_rate))

  if suites_failed == 0 then
    print("\n🎉 All test suites completed successfully!")
    return true
  else
    print(string.format("\n💥 %d test suite(s) failed!", suites_failed))
    return false
  end
end

-- Performance testing function
local function run_performance_tests()
  print("\n⚡ Running performance tests...")

  local perf_tests = {
    {
      name = "Config loading",
      test = function()
        local start_time = os.clock()
        for i = 1, 10 do
          package.loaded["wezterm"] = nil
          require("wezterm")
        end
        return os.clock() - start_time
      end
    },
    {
      name = "Event handler execution",
      test = function()
        local start_time = os.clock()
        for i = 1, 100 do
          if helper.registered_events and helper.registered_events["format-tab-title"] then
            helper.registered_events["format-tab-title"](
              helper.create_mock_tab(),
              nil, nil, helper.create_test_config(), false, 50
            )
          end
        end
        return os.clock() - start_time
      end
    }
  }

  for _, perf_test in ipairs(perf_tests) do
    local elapsed = perf_test.test()
    print(string.format("  %s: %.3f seconds", perf_test.name, elapsed))
  end
end

-- Memory usage testing function
local function check_memory_usage()
  print("\n💾 Checking memory usage...")

  if collectgarbage then
    local before = collectgarbage("count")

    -- Load all modules
    for _, suite_name in ipairs(test_suites) do
      pcall(require, suite_name)
    end

    local after = collectgarbage("count")
    local used = after - before

    print(string.format("  Memory used: %.2f KB", used))

    -- Force garbage collection
    collectgarbage("collect")
    local after_gc = collectgarbage("count")
    local cleaned = after - after_gc

    print(string.format("  Memory cleaned: %.2f KB", cleaned))
    print(string.format("  Memory remaining: %.2f KB", after_gc - before))
  else
    print("  Memory checking not available")
  end
end

-- Main execution
if arg and arg[0] and arg[0]:match("run_tests%.lua$") then
  -- Running as standalone script
  local success = run_all_tests()

  if arg[1] == "--performance" or arg[1] == "-p" then
    run_performance_tests()
  end

  if arg[1] == "--memory" or arg[1] == "-m" then
    check_memory_usage()
  end

  os.exit(success and 0 or 1)
else
  -- Being required as module
  return {
    run_all_tests = run_all_tests,
    run_performance_tests = run_performance_tests,
    check_memory_usage = check_memory_usage,
    validate_environment = validate_environment,
    stats = stats
  }
end

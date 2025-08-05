#!/usr/bin/env lua

---@module "tests.test_discovery"
---@description Test discovery and execution utility
---@author Test Suite

local lfs = require("lfs") or nil  -- Optional dependency

-- Test discovery utility
local M = {}

-- Find all test files in directory
function M.find_test_files(directory)
  directory = directory or "tests"
  local test_files = {}

  if lfs then
    -- Use lfs if available for better file system operations
    for file in lfs.dir(directory) do
      if file ~= "." and file ~= ".." then
        local path = directory .. "/" .. file
        local attr = lfs.attributes(path)

        if attr.mode == "directory" then
          -- Recursively search subdirectories
          local sub_files = M.find_test_files(path)
          for _, sub_file in ipairs(sub_files) do
            table.insert(test_files, sub_file)
          end
        elseif file:match("_spec%.lua$") then
          table.insert(test_files, path)
        end
      end
    end
  else
    -- Fallback: hardcoded list of test files
    test_files = {
      "tests/spec_helper.lua",

      -- Core utilities
      "tests/utils/fn_spec.lua",
      "tests/utils/init_spec.lua",
      "tests/utils/perf_spec.lua",
      "tests/utils/gpu_spec.lua",
      "tests/utils/class/config_spec.lua",
      "tests/utils/class/logger_spec.lua",
      "tests/utils/class/picker_spec.lua",
      "tests/utils/class/icon_spec.lua",
      "tests/utils/class/layout_spec.lua",
      "tests/utils/external/inspect_spec.lua",

      -- Configuration modules
      "tests/config/init_spec.lua",
      "tests/config/appearance_spec.lua",
      "tests/config/font_spec.lua",
      "tests/config/tab-bar_spec.lua",
      "tests/config/general_spec.lua",
      "tests/config/gpu_spec.lua",

      -- Event handlers
      "tests/events/format-tab-title_spec.lua",
      "tests/events/update-status_spec.lua",
      "tests/events/format-window-title_spec.lua",
      "tests/events/new-tab-button-click_spec.lua",
      "tests/events/augment-command-palette_spec.lua",

      -- Key mappings
      "tests/mappings/init_spec.lua",
      "tests/mappings/default_spec.lua",
      "tests/mappings/modes_spec.lua",

      -- Pickers
      "tests/picker/colorscheme_spec.lua",
      "tests/picker/font_spec.lua",
      "tests/picker/font-size_spec.lua",
      "tests/picker/font-leading_spec.lua",

      -- Picker assets
      "tests/picker/assets/font-leadings/font-leadings_spec.lua",
      "tests/picker/assets/font-sizes/font-sizes_spec.lua",
      "tests/picker/assets/fonts/reset_spec.lua",
      "tests/picker/assets/fonts/jetbrains-mono-nf_spec.lua",

      -- Integration tests
      "tests/integration/picker_workflow_spec.lua",
      "tests/integration/configuration_system_spec.lua",

      -- Stress tests
      "tests/stress/system_resilience_spec.lua",

      -- Main configuration
      "tests/wezterm_spec.lua"
    }
  end

  return test_files
end

-- Get test categories
function M.get_test_categories()
  return {
    utils = { pattern = "tests/utils/.*_spec%.lua" },
    config = { pattern = "tests/config/.*_spec%.lua" },
    events = { pattern = "tests/events/.*_spec%.lua" },
    mappings = { pattern = "tests/mappings/.*_spec%.lua" },
    picker = { pattern = "tests/picker/.*_spec%.lua" },
    assets = { pattern = "tests/picker/assets/.*_spec%.lua" },
    integration = { pattern = "tests/integration/.*_spec%.lua" },
    stress = { pattern = "tests/stress/.*_spec%.lua" },
    external = { pattern = "tests/utils/external/.*_spec%.lua" },
    core = { pattern = "tests/utils/.*_spec%.lua" },
    class = { pattern = "tests/utils/class/.*_spec%.lua" },
    main = { pattern = "tests/wezterm_spec%.lua" },
    all = { pattern = ".*_spec%.lua" }
  }
end

-- Filter test files by category
function M.filter_by_category(test_files, category)
  local categories = M.get_test_categories()
  local pattern = categories[category]

  if not pattern then
    return test_files
  end

  local filtered = {}
  for _, file in ipairs(test_files) do
    if file:match(pattern.pattern) then
      table.insert(filtered, file)
    end
  end

  return filtered
end

-- Run specific test file
function M.run_test_file(file_path)
  local cmd = string.format("busted %s", file_path)
  print(string.format("Running: %s", cmd))
  return os.execute(cmd)
end

-- Run tests by category
function M.run_category(category)
  local test_files = M.find_test_files()
  local filtered_files = M.filter_by_category(test_files, category)

  print(string.format("Running %d tests in category '%s':", #filtered_files, category))

  local success_count = 0
  local total_count = #filtered_files

  for _, file in ipairs(filtered_files) do
    if M.run_test_file(file) == 0 then
      success_count = success_count + 1
    end
  end

  print(string.format("Results: %d/%d tests passed", success_count, total_count))
  return success_count == total_count
end

-- Interactive test runner
function M.interactive_runner()
  print("WezTerm Configuration Test Runner")
  print("=================================")

  while true do
    print("\nOptions:")
    print("1. Run all tests")
    print("2. Run tests by category")
    print("3. Run specific test file")
    print("4. List test files")
    print("5. Exit")

    io.write("Select option (1-5): ")
    local choice = io.read()

    if choice == "1" then
      local cmd = "lua tests/run_tests.lua"
      print(string.format("Running: %s", cmd))
      os.execute(cmd)

    elseif choice == "2" then
      print("\nAvailable categories:")
      local categories = M.get_test_categories()
      for category, _ in pairs(categories) do
        print(string.format("  - %s", category))
      end

      io.write("Enter category name: ")
      local category = io.read()

      if categories[category] then
        M.run_category(category)
      else
        print("Invalid category!")
      end

    elseif choice == "3" then
      local test_files = M.find_test_files()

      print("\nAvailable test files:")
      for i, file in ipairs(test_files) do
        print(string.format("  %d. %s", i, file))
      end

      io.write("Enter file number: ")
      local file_num = tonumber(io.read())

      if file_num and test_files[file_num] then
        M.run_test_file(test_files[file_num])
      else
        print("Invalid file number!")
      end

    elseif choice == "4" then
      local test_files = M.find_test_files()

      print(string.format("\nFound %d test files:", #test_files))
      for _, file in ipairs(test_files) do
        print(string.format("  - %s", file))
      end

    elseif choice == "5" then
      print("Goodbye!")
      break

    else
      print("Invalid option!")
    end
  end
end

-- Command line interface
if arg and arg[0] and arg[0]:match("test_discovery%.lua$") then
  local command = arg[1]

  if command == "list" then
    local test_files = M.find_test_files()
    for _, file in ipairs(test_files) do
      print(file)
    end

  elseif command == "categories" then
    local categories = M.get_test_categories()
    for category, _ in pairs(categories) do
      print(category)
    end

  elseif command == "run" and arg[2] then
    if M.get_test_categories()[arg[2]] then
      -- Run by category
      local success = M.run_category(arg[2])
      os.exit(success and 0 or 1)
    else
      -- Run specific file
      local success = M.run_test_file(arg[2])
      os.exit(success and 0 or 1)
    end

  elseif command == "interactive" then
    M.interactive_runner()

  else
    print("Usage:")
    print("  lua test_discovery.lua list           - List all test files")
    print("  lua test_discovery.lua categories     - List test categories")
    print("  lua test_discovery.lua run <category> - Run tests by category")
    print("  lua test_discovery.lua run <file>     - Run specific test file")
    print("  lua test_discovery.lua interactive    - Interactive test runner")
  end
else
  return M
end

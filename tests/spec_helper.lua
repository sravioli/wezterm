---@module "tests.spec_helper"
---@author Test Suite
---@license GNU-GPLv3

-- Test helper configuration for busted tests
-- This file provides common utilities and mocks for testing WezTerm configuration

local M = {}

-- Mock WezTerm module for testing
M.mock_wezterm = {
  GLOBAL = {
    opacity = 1,
    cache = {},
  },
  config_builder = function()
    local config = {}
    config.set_strict_mode = function() end
    return config
  end,
  config_dir = "/mock/config/dir",
  column_width = function() return 10 end,
  gui = {},
  home_dir = "/mock/home",
  hostname = function() return "mock-host" end,
  target_triple = "mock-target",
  truncate_right = function(str, len) return string.sub(str, 1, len) end,
  log_info = function(...) print("INFO:", ...) end,
  log_warn = function(...) print("WARN:", ...) end,
  log_error = function(...) print("ERROR:", ...) end,
  on = function(event, callback)
    -- Mock event registration
    M.registered_events = M.registered_events or {}
    M.registered_events[event] = callback
  end,
  color_schemes = {
    ["Test Scheme"] = {
      background = "#000000",
      foreground = "#ffffff",
      ansi = {"#000000", "#ff0000", "#00ff00", "#ffff00", "#0000ff", "#ff00ff", "#00ffff", "#ffffff"},
      brights = {"#808080", "#ff8080", "#80ff80", "#ffff80", "#8080ff", "#ff80ff", "#80ffff", "#ffffff"},
      tab_bar = {
        background = "#000000",
        inactive_tab_hover = { bg_color = "#333333" }
      }
    }
  }
}

-- Setup package.path to include the source directory
M.setup_path = function()
  local config_dir = "c:\\Users\\Simone.Fidanza\\.config\\wezterm"
  package.path = config_dir .. "\\?.lua;" .. config_dir .. "\\?\\init.lua;" .. package.path
end

-- Mock require to return our mock wezterm when requested
M.setup_mocks = function()
  package.loaded["wezterm"] = M.mock_wezterm
end

-- Create a test configuration table
M.create_test_config = function()
  return {
    color_scheme = "Test Scheme",
    color_schemes = M.mock_wezterm.color_schemes,
    use_fancy_tab_bar = false,
    enable_tab_bar = true
  }
end

-- Helper to create mock tab object
M.create_mock_tab = function(overrides)
  local defaults = {
    tab_index = 0,
    is_active = false,
    panes = {
      {
        has_unseen_output = false,
        pane_index = 0
      }
    }
  }
  return setmetatable(overrides or {}, { __index = defaults })
end

-- Helper to create mock window object
M.create_mock_window = function()
  return {
    set_right_status = function(status) end,
    active_workspace = function() return "default" end,
    active_key_table = function() return nil end,
    leader_is_active = function() return false end,
    active_tab = function()
      return M.create_mock_tab({ is_active = true })
    end
  }
end

-- Helper to create mock pane object
M.create_mock_pane = function()
  return {
    get_current_working_dir = function()
      return { file_path = "/mock/path" }
    end,
    get_foreground_process_name = function()
      return "bash"
    end
  }
end

-- Assertion helpers
M.assert_table_contains = function(tbl, key, msg)
  assert.is_not_nil(tbl[key], msg or ("Expected table to contain key: " .. tostring(key)))
end

M.assert_function_exists = function(obj, method_name, msg)
  assert.is_function(obj[method_name], msg or ("Expected " .. method_name .. " to be a function"))
end

M.assert_valid_color = function(color, msg)
  if type(color) == "string" then
    assert.matches("^#%x%x%x%x%x%x$", color, msg or "Expected valid hex color")
  end
end

-- Setup function to be called before each test
M.setup = function()
  M.setup_path()
  M.setup_mocks()
end

-- Teardown function to be called after each test
M.teardown = function()
  -- Reset global state
  if M.mock_wezterm.GLOBAL then
    M.mock_wezterm.GLOBAL.cache = {}
  end
  M.registered_events = {}
end

return M

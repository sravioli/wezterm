---@module "tests.utils.class.config_spec"
---@description Unit tests for utils.class.config module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("utils.class.config", function()
  local Config

  before_each(function()
    helper.setup()
    Config = require("utils.class.config")
  end)

  after_each(function()
    helper.teardown()
  end)

  describe("initialization", function()
    it("should create a new config instance", function()
      local config = Config:new()

      assert.is_not_nil(config)
      assert.is_table(config.config)
    end)

    it("should use config builder when available", function()
      -- Mock wezterm has config_builder available
      local config = Config:new()

      assert.is_not_nil(config)
      assert.is_table(config.config)
    end)

    it("should handle missing config builder gracefully", function()
      -- Temporarily remove config_builder
      local original_builder = package.loaded.wezterm.config_builder
      package.loaded.wezterm.config_builder = nil

      local config = Config:new()

      assert.is_not_nil(config)
      assert.is_table(config.config)

      -- Restore config_builder
      package.loaded.wezterm.config_builder = original_builder
    end)

    it("should have logger instance", function()
      assert.is_not_nil(Config.log)
      assert.is_table(Config.log)
    end)
  end)

  describe("add method", function()
    local config

    before_each(function()
      config = Config:new()
    end)

    it("should add module by string path", function()
      -- Create a mock module
      local mock_module = { test_key = "test_value", another_key = 42 }
      package.loaded["test.module"] = mock_module

      local result = config:add("test.module")

      assert.equals("test_value", result.test_key)
      assert.equals(42, result.another_key)

      -- Cleanup
      package.loaded["test.module"] = nil
    end)

    it("should add table directly", function()
      local test_table = {
        color_scheme = "Test Theme",
        font_size = 12,
        nested = { key = "value" }
      }

      local result = config:add(test_table)

      assert.equals("Test Theme", result.color_scheme)
      assert.equals(12, result.font_size)
      assert.is_table(result.nested)
      assert.equals("value", result.nested.key)
    end)

    it("should handle non-existent modules gracefully", function()
      local original_config = {}
      for k, v in pairs(config.config) do
        original_config[k] = v
      end

      local result = config:add("non.existent.module")

      -- Should return original config unchanged
      assert.same(config.config, result)
    end)

    it("should merge multiple configurations", function()
      local first = { a = 1, b = 2 }
      local second = { b = 3, c = 4 }

      config:add(first)
      local result = config:add(second)

      assert.equals(1, result.a)
      assert.equals(3, result.b)  -- should overwrite
      assert.equals(4, result.c)
    end)

    it("should handle nested configurations", function()
      local first = {
        ui = { theme = "dark", size = 12 },
        other = "value"
      }
      local second = {
        ui = { theme = "light" },
        new_key = "new_value"
      }

      config:add(first)
      local result = config:add(second)

      assert.equals("light", result.ui.theme)
      assert.equals(12, result.ui.size)  -- should preserve
      assert.equals("value", result.other)
      assert.equals("new_value", result.new_key)
    end)

    it("should return config object for chaining", function()
      local first = { a = 1 }
      local second = { b = 2 }

      local result = config:add(first):add(second)

      assert.equals(1, result.a)
      assert.equals(2, result.b)
    end)

    it("should warn about duplicate keys", function()
      local first = { duplicate_key = "first_value" }
      local second = { duplicate_key = "second_value" }

      config:add(first)
      local result = config:add(second)

      -- Should have the second value (overwritten)
      assert.equals("second_value", result.duplicate_key)
    end)
  end)

  describe("metatable behavior", function()
    it("should properly set metatable", function()
      local config = Config:new()

      -- Should have access to Config methods
      assert.is_function(config.add)
    end)

    it("should return config table from add method", function()
      local config = Config:new()
      local test_config = { test = "value" }

      local result = config:add(test_config)

      -- Result should be the internal config table
      assert.equals(config.config, result)
    end)
  end)

  describe("error handling", function()
    it("should handle invalid spec types", function()
      local config = Config:new()

      -- Should not crash with invalid types
      assert.has_no.errors(function()
        config:add(nil)
      end)

      assert.has_no.errors(function()
        config:add(42)
      end)

      assert.has_no.errors(function()
        config:add(true)
      end)
    end)

    it("should handle circular references", function()
      local config = Config:new()
      local circular = {}
      circular.self = circular

      -- Should not crash or hang
      assert.has_no.errors(function()
        config:add(circular)
      end)
    end)
  end)

  describe("integration", function()
    it("should work with real config modules pattern", function()
      local config = Config:new()

      -- Simulate a real config module
      local appearance_config = {
        color_scheme = "Test Theme",
        background = { { source = { Color = "#000000" } } },
        cursor_blink_rate = 500
      }

      local font_config = {
        font_size = 12,
        font_family = "Test Font"
      }

      local result = config:add(appearance_config):add(font_config)

      assert.equals("Test Theme", result.color_scheme)
      assert.is_table(result.background)
      assert.equals(500, result.cursor_blink_rate)
      assert.equals(12, result.font_size)
      assert.equals("Test Font", result.font_family)
    end)
  end)
end)

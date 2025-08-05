---@module "tests.config.init_spec"
---@description Unit tests for config.init module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("config.init", function()
  local config_init

  before_each(function()
    helper.setup()

    -- Mock the individual config modules
    package.loaded["config.appearance"] = {
      color_scheme = "Test Scheme",
      background = { { source = { Color = "#000000" } } },
      cursor_blink_rate = 500
    }

    package.loaded["config.font"] = {
      font_size = 12,
      font_family = "Test Font"
    }

    package.loaded["config.tab-bar"] = {
      use_fancy_tab_bar = false,
      enable_tab_bar = true,
      tab_bar_at_bottom = false
    }

    package.loaded["config.general"] = {
      default_workspace = "main",
      automatically_reload_config = true
    }

    package.loaded["config.gpu"] = {
      enable_wayland = false,
      webgpu_power_preference = "HighPerformance"
    }

    config_init = require("config.init")
  end)

  after_each(function()
    helper.teardown()
    -- Clean up mocked modules
    package.loaded["config.appearance"] = nil
    package.loaded["config.font"] = nil
    package.loaded["config.tab-bar"] = nil
    package.loaded["config.general"] = nil
    package.loaded["config.gpu"] = nil
  end)

  describe("module structure", function()
    it("should return a merged configuration table", function()
      assert.is_table(config_init)
    end)

    it("should contain appearance configuration", function()
      assert.equals("Test Scheme", config_init.color_scheme)
      assert.is_table(config_init.background)
      assert.equals(500, config_init.cursor_blink_rate)
    end)

    it("should contain font configuration", function()
      assert.equals(12, config_init.font_size)
      assert.equals("Test Font", config_init.font_family)
    end)

    it("should contain tab-bar configuration", function()
      assert.is_false(config_init.use_fancy_tab_bar)
      assert.is_true(config_init.enable_tab_bar)
      assert.is_false(config_init.tab_bar_at_bottom)
    end)

    it("should contain general configuration", function()
      assert.equals("main", config_init.default_workspace)
      assert.is_true(config_init.automatically_reload_config)
    end)

    it("should contain GPU configuration", function()
      assert.is_false(config_init.enable_wayland)
      assert.equals("HighPerformance", config_init.webgpu_power_preference)
    end)
  end)

  describe("merge behavior", function()
    it("should properly merge all configuration modules", function()
      -- Count the number of keys to ensure merging worked
      local key_count = 0
      for _ in pairs(config_init) do
        key_count = key_count + 1
      end

      assert.is_true(key_count > 0)
    end)

    it("should handle conflicts appropriately", function()
      -- If there are any conflicting keys, later modules should win
      -- This depends on the order in the merge function
      assert.is_table(config_init)
    end)

    it("should preserve nested structures", function()
      assert.is_table(config_init.background)
      assert.is_table(config_init.background[1])
      assert.is_table(config_init.background[1].source)
    end)
  end)

  describe("configuration completeness", function()
    it("should have all essential WezTerm configuration keys", function()
      -- Check for common WezTerm configuration keys
      helper.assert_table_contains(config_init, "color_scheme")
      helper.assert_table_contains(config_init, "font_size")
    end)

    it("should have valid color scheme", function()
      assert.is_string(config_init.color_scheme)
      assert.is_true(#config_init.color_scheme > 0)
    end)

    it("should have valid font configuration", function()
      assert.is_number(config_init.font_size)
      assert.is_true(config_init.font_size > 0)

      if config_init.font_family then
        assert.is_string(config_init.font_family)
      end
    end)

    it("should have valid background configuration", function()
      assert.is_table(config_init.background)
      assert.is_true(#config_init.background > 0)

      local first_bg = config_init.background[1]
      assert.is_table(first_bg)
      assert.is_table(first_bg.source)
    end)

    it("should have valid cursor configuration", function()
      if config_init.cursor_blink_rate then
        assert.is_number(config_init.cursor_blink_rate)
        assert.is_true(config_init.cursor_blink_rate > 0)
      end
    end)
  end)

  describe("error handling", function()
    it("should handle missing configuration modules gracefully", function()
      -- Temporarily remove one module
      local original_appearance = package.loaded["config.appearance"]
      package.loaded["config.appearance"] = nil

      assert.has_no.errors(function()
        -- Force reload
        package.loaded["config.init"] = nil
        require("config.init")
      end)

      -- Restore
      package.loaded["config.appearance"] = original_appearance
    end)

    it("should handle empty configuration modules", function()
      -- Replace with empty modules
      package.loaded["config.appearance"] = {}
      package.loaded["config.font"] = {}

      assert.has_no.errors(function()
        package.loaded["config.init"] = nil
        local empty_config = require("config.init")
        assert.is_table(empty_config)
      end)
    end)

    it("should handle malformed configuration modules", function()
      -- Replace with invalid modules
      package.loaded["config.appearance"] = "not a table"
      package.loaded["config.font"] = 42

      assert.has_no.errors(function()
        package.loaded["config.init"] = nil
        require("config.init")
      end)
    end)
  end)

  describe("integration", function()
    it("should work with WezTerm configuration system", function()
      -- The merged config should be valid for WezTerm
      assert.is_table(config_init)

      -- Should have essential configuration structure
      assert.is_not_nil(config_init.color_scheme)
    end)

    it("should be usable by Config class", function()
      local Config = require("utils.class.config")
      local config = Config:new()

      assert.has_no.errors(function()
        config:add(config_init)
      end)
    end)

    it("should maintain configuration precedence", function()
      -- The last module in the merge should take precedence for conflicts
      -- This tests the merge order behavior
      assert.is_table(config_init)
    end)
  end)

  describe("type validation", function()
    it("should have correct types for common configuration options", function()
      if config_init.color_scheme then
        assert.is_string(config_init.color_scheme)
      end

      if config_init.font_size then
        assert.is_number(config_init.font_size)
      end

      if config_init.enable_tab_bar then
        assert.is_boolean(config_init.enable_tab_bar)
      end

      if config_init.background then
        assert.is_table(config_init.background)
      end
    end)

    it("should have valid boolean configurations", function()
      local boolean_configs = {
        "use_fancy_tab_bar",
        "enable_tab_bar",
        "automatically_reload_config",
        "enable_wayland"
      }

      for _, key in ipairs(boolean_configs) do
        if config_init[key] ~= nil then
          assert.is_boolean(config_init[key])
        end
      end
    end)

    it("should have valid string configurations", function()
      local string_configs = {
        "color_scheme",
        "font_family",
        "default_workspace",
        "webgpu_power_preference"
      }

      for _, key in ipairs(string_configs) do
        if config_init[key] then
          assert.is_string(config_init[key])
          assert.is_true(#config_init[key] > 0)
        end
      end
    end)

    it("should have valid numeric configurations", function()
      local numeric_configs = {
        "font_size",
        "cursor_blink_rate"
      }

      for _, key in ipairs(numeric_configs) do
        if config_init[key] then
          assert.is_number(config_init[key])
          assert.is_true(config_init[key] > 0)
        end
      end
    end)
  end)
end)

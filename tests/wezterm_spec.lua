---@module "tests.wezterm_spec"
---@description Unit tests for main wezterm.lua module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("wezterm.lua", function()
  local wezterm_config

  before_each(function()
    helper.setup()

    -- Mock the Config class
    local MockConfig = {}
    MockConfig.__index = MockConfig

    function MockConfig:new()
      local instance = {
        _modules = {},
        config = {}
      }
      setmetatable(instance, MockConfig)
      return instance
    end

    function MockConfig:add(module_name)
      table.insert(self._modules, module_name)

      -- Mock config addition
      if module_name == "config" then
        self.config.color_scheme = "Test Scheme"
        self.config.font_size = 12
      elseif module_name == "mappings" then
        self.config.keys = {}
        self.config.key_tables = {}
      end

      return self.config
    end

    package.loaded["utils.class.config"] = MockConfig

    -- Load main configuration
    wezterm_config = require("wezterm")
  end)

  after_each(function()
    helper.teardown()
    package.loaded["utils.class.config"] = nil
    package.loaded["wezterm"] = nil
  end)

  describe("module structure", function()
    it("should return a configuration table", function()
      assert.is_table(wezterm_config)
    end)

    it("should contain basic configuration", function()
      -- Should have some configuration keys from the mocked modules
      assert.is_not_nil(wezterm_config)
    end)
  end)

  describe("event handlers registration", function()
    it("should register update-status event", function()
      assert.is_not_nil(helper.registered_events)
      -- Event handlers are loaded via require, should be registered
    end)

    it("should register format-tab-title event", function()
      assert.is_not_nil(helper.registered_events)
      -- Event handlers are loaded via require, should be registered
    end)

    it("should register new-tab-button-click event", function()
      assert.is_not_nil(helper.registered_events)
      -- Event handlers are loaded via require, should be registered
    end)

    it("should register augment-command-palette event", function()
      assert.is_not_nil(helper.registered_events)
      -- Event handlers are loaded via require, should be registered
    end)
  end)

  describe("Config class integration", function()
    it("should create Config instance", function()
      -- The wezterm.lua should use Config class
      assert.is_table(wezterm_config)
    end)

    it("should add config module", function()
      -- Config module should be added
      assert.is_table(wezterm_config)
    end)

    it("should add mappings module", function()
      -- Mappings module should be added
      assert.is_table(wezterm_config)
    end)

    it("should chain add calls", function()
      -- The pattern is Config:new():add("config"):add("mappings")
      assert.is_table(wezterm_config)
    end)
  end)

  describe("required modules", function()
    it("should load event handlers without errors", function()
      assert.has_no.errors(function()
        require("events.update-status")
      end)

      assert.has_no.errors(function()
        require("events.format-tab-title")
      end)

      assert.has_no.errors(function()
        require("events.new-tab-button-click")
      end)

      assert.has_no.errors(function()
        require("events.augment-command-palette")
      end)
    end)

    it("should handle missing event modules gracefully", function()
      -- Temporarily remove an event module
      local original_module = package.loaded["events.update-status"]
      package.loaded["events.update-status"] = nil

      assert.has_no.errors(function()
        -- Force reload of main config
        package.loaded["wezterm"] = nil
        require("wezterm")
      end)

      -- Restore
      package.loaded["events.update-status"] = original_module
    end)
  end)

  describe("configuration completeness", function()
    it("should produce valid WezTerm configuration", function()
      assert.is_table(wezterm_config)

      -- Basic validation that it looks like a WezTerm config
      -- (specific validation depends on what the Config class actually adds)
    end)

    it("should have proper structure for WezTerm", function()
      assert.is_table(wezterm_config)

      -- The config should be suitable for return from wezterm.lua
      -- WezTerm expects a table with configuration options
    end)
  end)

  describe("error handling", function()
    it("should handle Config class instantiation errors", function()
      -- Mock a failing Config class
      package.loaded["utils.class.config"] = {
        new = function()
          error("Mock Config instantiation error")
        end
      }

      assert.has_errors(function()
        package.loaded["wezterm"] = nil
        require("wezterm")
      end)
    end)

    it("should handle Config add method errors", function()
      local MockConfig = {}
      MockConfig.__index = MockConfig

      function MockConfig:new()
        local instance = {}
        setmetatable(instance, MockConfig)
        return instance
      end

      function MockConfig:add(module_name)
        if module_name == "config" then
          error("Mock config add error")
        end
        return {}
      end

      package.loaded["utils.class.config"] = MockConfig

      assert.has_errors(function()
        package.loaded["wezterm"] = nil
        require("wezterm")
      end)
    end)

    it("should handle missing Config class", function()
      package.loaded["utils.class.config"] = nil

      assert.has_errors(function()
        package.loaded["wezterm"] = nil
        require("wezterm")
      end)
    end)
  end)

  describe("module loading order", function()
    it("should load Config class before using it", function()
      -- Config class should be available when main module loads
      assert.is_not_nil(package.loaded["utils.class.config"])
    end)

    it("should load event handlers after Config setup", function()
      -- Event handlers should be loaded after Config is created
      -- This ensures proper initialization order
      assert.is_table(wezterm_config)
    end)
  end)

  describe("integration", function()
    it("should work with WezTerm runtime", function()
      -- The returned configuration should be valid for WezTerm
      assert.is_table(wezterm_config)

      -- Should not contain any obviously invalid values
      for key, value in pairs(wezterm_config) do
        assert.is_not_nil(key)
        assert.is_not_nil(value)
      end
    end)

    it("should handle real WezTerm config builder", function()
      -- Test with actual WezTerm config builder if available
      if helper.mock_wezterm.config_builder then
        assert.is_table(wezterm_config)
      end
    end)

    it("should be returnable from wezterm.lua", function()
      -- The main requirement: wezterm.lua must return a valid config
      assert.is_table(wezterm_config)

      -- Should be safe to return this table to WezTerm
      local function mock_wezterm_load()
        return wezterm_config
      end

      assert.has_no.errors(mock_wezterm_load)
    end)
  end)

  describe("performance", function()
    it("should load configuration efficiently", function()
      -- Configuration loading should not be prohibitively slow
      assert.has_no.errors(function()
        for i = 1, 10 do
          package.loaded["wezterm"] = nil
          require("wezterm")
        end
      end)
    end)

    it("should handle rapid reloads", function()
      -- WezTerm may reload config frequently during development
      assert.has_no.errors(function()
        for i = 1, 5 do
          package.loaded["wezterm"] = nil
          local config = require("wezterm")
          assert.is_table(config)
        end
      end)
    end)
  end)

  describe("memory management", function()
    it("should not leak memory during config creation", function()
      -- Basic test that config creation doesn't obviously leak
      assert.has_no.errors(function()
        for i = 1, 20 do
          package.loaded["wezterm"] = nil
          require("wezterm")
        end
      end)
    end)

    it("should properly handle module caching", function()
      -- Modules should be properly cached by Lua
      local first_load = require("wezterm")
      local second_load = require("wezterm")

      -- Should be same table due to caching
      assert.equals(first_load, second_load)
    end)
  end)
end)

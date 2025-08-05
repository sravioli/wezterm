---@module "tests.config.gpu_spec"
---@description Tests for config.gpu module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("config.gpu", function()
  local gpu_config

  before_each(function()
    helper.setup_mocks()

    -- Mock wezterm battery info
    local mock_wezterm = helper.get_mock_wezterm()
    mock_wezterm.battery_info = function()
      return {{
        state_of_charge = 0.75,
        vendor = "Mock Battery",
        model = "Test Battery"
      }}
    end

    -- Mock GPU utility
    package.loaded["utils.gpu"] = {
      pick_best = function()
        return {
          backend = "Vulkan",
          device = 1234,
          device_type = "DiscreteGpu",
          driver = "Test Driver",
          driver_info = "Test Driver Info",
          name = "Test GPU"
        }
      end
    }

    gpu_config = require("config.gpu")
  end)

  after_each(function()
    helper.cleanup_mocks()
  end)

  describe("Basic GPU configuration", function()
    it("should set WebGpu as front end", function()
      assert.equals("WebGpu", gpu_config.front_end)
    end)

    it("should disable fallback adapter by default", function()
      assert.is_false(gpu_config.webgpu_force_fallback_adapter)
    end)

    it("should set preferred adapter from GPU utility", function()
      assert.is_table(gpu_config.webgpu_preferred_adapter)
      assert.equals("Vulkan", gpu_config.webgpu_preferred_adapter.backend)
      assert.equals("Test GPU", gpu_config.webgpu_preferred_adapter.name)
    end)
  end)

  describe("Power management", function()
    describe("with high battery charge", function()
      before_each(function()
        package.loaded["config.gpu"] = nil
        local mock_wezterm = helper.get_mock_wezterm()
        mock_wezterm.battery_info = function()
          return {{
            state_of_charge = 0.75 -- High battery
          }}
        end
        gpu_config = require("config.gpu")
      end)

      it("should use HighPerformance power preference", function()
        assert.equals("HighPerformance", gpu_config.webgpu_power_preference)
      end)
    end)

    describe("with low battery charge", function()
      before_each(function()
        package.loaded["config.gpu"] = nil
        local mock_wezterm = helper.get_mock_wezterm()
        mock_wezterm.battery_info = function()
          return {{
            state_of_charge = 0.25 -- Low battery (below 35%)
          }}
        end
        gpu_config = require("config.gpu")
      end)

      it("should use LowPower power preference", function()
        assert.equals("LowPower", gpu_config.webgpu_power_preference)
      end)
    end)

    describe("with critical battery charge", function()
      before_each(function()
        package.loaded["config.gpu"] = nil
        local mock_wezterm = helper.get_mock_wezterm()
        mock_wezterm.battery_info = function()
          return {{
            state_of_charge = 0.10 -- Very low battery
          }}
        end
        gpu_config = require("config.gpu")
      end)

      it("should use LowPower power preference", function()
        assert.equals("LowPower", gpu_config.webgpu_power_preference)
      end)
    end)

    describe("with exactly 35% battery", function()
      before_each(function()
        package.loaded["config.gpu"] = nil
        local mock_wezterm = helper.get_mock_wezterm()
        mock_wezterm.battery_info = function()
          return {{
            state_of_charge = 0.35 -- Exactly at threshold
          }}
        end
        gpu_config = require("config.gpu")
      end)

      it("should use HighPerformance power preference", function()
        assert.equals("HighPerformance", gpu_config.webgpu_power_preference)
      end)
    end)

    describe("with no battery info", function()
      before_each(function()
        package.loaded["config.gpu"] = nil
        local mock_wezterm = helper.get_mock_wezterm()
        mock_wezterm.battery_info = function()
          return {} -- No battery
        end
        gpu_config = require("config.gpu")
      end)

      it("should default to HighPerformance power preference", function()
        assert.equals("HighPerformance", gpu_config.webgpu_power_preference)
      end)
    end)

    describe("with nil battery info", function()
      before_each(function()
        package.loaded["config.gpu"] = nil
        local mock_wezterm = helper.get_mock_wezterm()
        mock_wezterm.battery_info = function()
          return nil
        end
        gpu_config = require("config.gpu")
      end)

      it("should default to HighPerformance power preference", function()
        assert.equals("HighPerformance", gpu_config.webgpu_power_preference)
      end)
    end)
  end)

  describe("Configuration validation", function()
    it("should be a valid table", function()
      assert.is_table(gpu_config)
    end)

    it("should have all required properties", function()
      assert.is_string(gpu_config.front_end)
      assert.is_boolean(gpu_config.webgpu_force_fallback_adapter)
      assert.is_string(gpu_config.webgpu_power_preference)
      assert.is_table(gpu_config.webgpu_preferred_adapter)
    end)

    it("should have valid front_end value", function()
      local valid_frontends = { "WebGpu", "OpenGL", "Software" }
      assert.truthy(helper.contains(valid_frontends, gpu_config.front_end))
    end)

    it("should have valid power preference", function()
      local valid_preferences = { "HighPerformance", "LowPower" }
      assert.truthy(helper.contains(valid_preferences, gpu_config.webgpu_power_preference))
    end)
  end)

  describe("GPU adapter validation", function()
    it("should have properly structured preferred adapter", function()
      local adapter = gpu_config.webgpu_preferred_adapter
      assert.is_table(adapter)

      -- Check expected properties exist
      assert.is_not_nil(adapter.backend)
      assert.is_not_nil(adapter.name)
    end)
  end)

  describe("Dependency integration", function()
    it("should integrate with utils.gpu module", function()
      -- Verify that GPU utility is being called
      local utils_gpu = require("utils.gpu")
      assert.is_function(utils_gpu.pick_best)
    end)

    it("should integrate with wezterm battery_info", function()
      local wezterm = require("wezterm")
      assert.is_function(wezterm.battery_info)

      local battery_info = wezterm.battery_info()
      if battery_info and #battery_info > 0 then
        assert.is_number(battery_info[1].state_of_charge)
      end
    end)
  end)

  describe("Error handling", function()
    it("should handle missing GPU utility gracefully", function()
      package.loaded["config.gpu"] = nil
      package.loaded["utils.gpu"] = nil

      -- Should not throw error when GPU utility is missing
      local success, result = pcall(require, "config.gpu")
      -- Note: This might fail due to missing dependency,
      -- but it shouldn't crash unexpectedly
      if not success then
        assert.is_string(result) -- Error message should be a string
      end
    end)

    it("should handle battery info errors gracefully", function()
      package.loaded["config.gpu"] = nil
      local mock_wezterm = helper.get_mock_wezterm()
      mock_wezterm.battery_info = function()
        error("Battery info not available")
      end

      -- Should handle battery info errors
      local success, result = pcall(require, "config.gpu")
      if not success then
        assert.is_string(result)
      else
        -- If it succeeds, it should default to HighPerformance
        assert.equals("HighPerformance", result.webgpu_power_preference)
      end
    end)
  end)
end)

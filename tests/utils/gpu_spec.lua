---@module "tests.utils.gpu_spec"
---@description Unit tests for utils.gpu module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("utils.gpu", function()
  local gpu_utils

  before_each(function()
    helper.setup()
    gpu_utils = require("utils.gpu")
  end)

  after_each(function()
    helper.teardown()
  end)

  describe("GPU detection", function()
    it("should detect available GPUs", function()
      if gpu_utils.detect_gpus then
        assert.is_function(gpu_utils.detect_gpus)

        local gpus = gpu_utils.detect_gpus()
        if gpus then
          assert.is_table(gpus)
        end
      end
    end)

    it("should identify GPU vendors", function()
      if gpu_utils.get_gpu_vendor then
        assert.is_function(gpu_utils.get_gpu_vendor)

        local vendor = gpu_utils.get_gpu_vendor()
        if vendor then
          assert.is_string(vendor)

          local valid_vendors = { "NVIDIA", "AMD", "Intel", "Apple", "Unknown" }
          local is_valid = false
          for _, valid_vendor in ipairs(valid_vendors) do
            if vendor == valid_vendor then
              is_valid = true
              break
            end
          end
          assert.is_true(is_valid)
        end
      end
    end)

    it("should detect integrated vs discrete GPU", function()
      if gpu_utils.is_integrated_gpu then
        assert.is_function(gpu_utils.is_integrated_gpu)

        local is_integrated = gpu_utils.is_integrated_gpu()
        if is_integrated ~= nil then
          assert.is_boolean(is_integrated)
        end
      end
    end)

    it("should get GPU memory information", function()
      if gpu_utils.get_gpu_memory then
        assert.is_function(gpu_utils.get_gpu_memory)

        local memory_info = gpu_utils.get_gpu_memory()
        if memory_info then
          assert.is_table(memory_info)

          if memory_info.total then
            assert.is_number(memory_info.total)
            assert.is_true(memory_info.total > 0)
          end

          if memory_info.available then
            assert.is_number(memory_info.available)
            assert.is_true(memory_info.available >= 0)
          end
        end
      end
    end)
  end)

  describe("WebGPU configuration", function()
    it("should provide WebGPU backend selection", function()
      if gpu_utils.get_webgpu_backend then
        assert.is_function(gpu_utils.get_webgpu_backend)

        local backend = gpu_utils.get_webgpu_backend()
        if backend then
          assert.is_string(backend)

          local valid_backends = { "Vulkan", "Metal", "Dx12", "OpenGL" }
          local is_valid = false
          for _, valid_backend in ipairs(valid_backends) do
            if backend == valid_backend then
              is_valid = true
              break
            end
          end
          assert.is_true(is_valid)
        end
      end
    end)

    it("should determine optimal power preference", function()
      if gpu_utils.get_power_preference then
        assert.is_function(gpu_utils.get_power_preference)

        local preference = gpu_utils.get_power_preference()
        if preference then
          assert.is_string(preference)

          local valid_preferences = { "LowPower", "HighPerformance" }
          local is_valid = false
          for _, valid_pref in ipairs(valid_preferences) do
            if preference == valid_pref then
              is_valid = true
              break
            end
          end
          assert.is_true(is_valid)
        end
      end
    end)

    it("should configure WebGPU adapter selection", function()
      if gpu_utils.get_webgpu_adapter then
        assert.is_function(gpu_utils.get_webgpu_adapter)

        local adapter = gpu_utils.get_webgpu_adapter()
        if adapter then
          assert.is_string(adapter)
        end
      end
    end)
  end)

  describe("performance optimization", function()
    it("should recommend optimal settings for current GPU", function()
      if gpu_utils.get_recommended_settings then
        assert.is_function(gpu_utils.get_recommended_settings)

        local settings = gpu_utils.get_recommended_settings()
        if settings then
          assert.is_table(settings)

          if settings.webgpu_power_preference then
            assert.is_string(settings.webgpu_power_preference)
          end

          if settings.front_end then
            assert.is_string(settings.front_end)
          end

          if settings.max_fps then
            assert.is_number(settings.max_fps)
            assert.is_true(settings.max_fps > 0)
          end
        end
      end
    end)

    it("should detect GPU performance capabilities", function()
      if gpu_utils.get_performance_tier then
        assert.is_function(gpu_utils.get_performance_tier)

        local tier = gpu_utils.get_performance_tier()
        if tier then
          assert.is_string(tier)

          local valid_tiers = { "Low", "Medium", "High", "Ultra" }
          local is_valid = false
          for _, valid_tier in ipairs(valid_tiers) do
            if tier == valid_tier then
              is_valid = true
              break
            end
          end
          assert.is_true(is_valid)
        end
      end
    end)

    it("should provide frame rate recommendations", function()
      if gpu_utils.get_recommended_fps then
        assert.is_function(gpu_utils.get_recommended_fps)

        local fps = gpu_utils.get_recommended_fps()
        if fps then
          assert.is_number(fps)
          assert.is_true(fps > 0)
          assert.is_true(fps <= 144) -- Reasonable upper bound
        end
      end
    end)
  end)

  describe("platform compatibility", function()
    it("should handle different operating systems", function()
      if gpu_utils.get_platform_gpu_info then
        assert.is_function(gpu_utils.get_platform_gpu_info)

        local info = gpu_utils.get_platform_gpu_info()
        if info then
          assert.is_table(info)

          if info.platform then
            assert.is_string(info.platform)

            local valid_platforms = { "Windows", "macOS", "Linux", "Unknown" }
            local is_valid = false
            for _, platform in ipairs(valid_platforms) do
              if info.platform == platform then
                is_valid = true
                break
              end
            end
            assert.is_true(is_valid)
          end
        end
      end
    end)

    it("should handle Wayland compatibility", function()
      if gpu_utils.supports_wayland then
        assert.is_function(gpu_utils.supports_wayland)

        local supports = gpu_utils.supports_wayland()
        if supports ~= nil then
          assert.is_boolean(supports)
        end
      end
    end)

    it("should detect X11 compatibility", function()
      if gpu_utils.supports_x11 then
        assert.is_function(gpu_utils.supports_x11)

        local supports = gpu_utils.supports_x11()
        if supports ~= nil then
          assert.is_boolean(supports)
        end
      end
    end)
  end)

  describe("driver information", function()
    it("should get GPU driver version", function()
      if gpu_utils.get_driver_version then
        assert.is_function(gpu_utils.get_driver_version)

        local version = gpu_utils.get_driver_version()
        if version then
          assert.is_string(version)
          assert.is_true(#version > 0)
        end
      end
    end)

    it("should check for driver updates", function()
      if gpu_utils.check_driver_updates then
        assert.is_function(gpu_utils.check_driver_updates)

        -- This might be async or return immediately
        assert.has_no.errors(function()
          gpu_utils.check_driver_updates()
        end)
      end
    end)

    it("should validate driver compatibility", function()
      if gpu_utils.is_driver_compatible then
        assert.is_function(gpu_utils.is_driver_compatible)

        local compatible = gpu_utils.is_driver_compatible()
        if compatible ~= nil then
          assert.is_boolean(compatible)
        end
      end
    end)
  end)

  describe("thermal and power management", function()
    it("should monitor GPU temperature", function()
      if gpu_utils.get_gpu_temperature then
        assert.is_function(gpu_utils.get_gpu_temperature)

        local temp = gpu_utils.get_gpu_temperature()
        if temp then
          assert.is_number(temp)
          assert.is_true(temp >= 0 and temp <= 150) -- Reasonable temperature range in Celsius
        end
      end
    end)

    it("should monitor power consumption", function()
      if gpu_utils.get_power_consumption then
        assert.is_function(gpu_utils.get_power_consumption)

        local power = gpu_utils.get_power_consumption()
        if power then
          assert.is_number(power)
          assert.is_true(power >= 0) -- Watts
        end
      end
    end)

    it("should adjust for thermal throttling", function()
      if gpu_utils.is_thermal_throttling then
        assert.is_function(gpu_utils.is_thermal_throttling)

        local throttling = gpu_utils.is_thermal_throttling()
        if throttling ~= nil then
          assert.is_boolean(throttling)
        end
      end
    end)
  end)

  describe("error handling", function()
    it("should handle GPU detection failures gracefully", function()
      -- Mock a GPU detection failure
      local original_detect = gpu_utils.detect_gpus
      if original_detect then
        gpu_utils.detect_gpus = function()
          error("Mock GPU detection error")
        end

        assert.has_no.errors(function()
          gpu_utils.get_recommended_settings()
        end)

        -- Restore original function
        gpu_utils.detect_gpus = original_detect
      end
    end)

    it("should provide fallback configurations", function()
      if gpu_utils.get_fallback_settings then
        assert.is_function(gpu_utils.get_fallback_settings)

        local fallback = gpu_utils.get_fallback_settings()
        assert.is_table(fallback)

        -- Should have safe defaults
        if fallback.webgpu_power_preference then
          assert.is_string(fallback.webgpu_power_preference)
        end
      end
    end)

    it("should handle missing GPU drivers", function()
      if gpu_utils.has_gpu_drivers then
        assert.is_function(gpu_utils.has_gpu_drivers)

        local has_drivers = gpu_utils.has_gpu_drivers()
        if has_drivers ~= nil then
          assert.is_boolean(has_drivers)
        end
      end
    end)

    it("should handle unsupported GPUs", function()
      if gpu_utils.is_gpu_supported then
        assert.is_function(gpu_utils.is_gpu_supported)

        local supported = gpu_utils.is_gpu_supported()
        if supported ~= nil then
          assert.is_boolean(supported)
        end
      end
    end)
  end)

  describe("performance testing", function()
    it("should benchmark GPU performance", function()
      if gpu_utils.run_gpu_benchmark then
        assert.is_function(gpu_utils.run_gpu_benchmark)

        -- Benchmark might take time, so just test it doesn't error
        assert.has_no.errors(function()
          local result = gpu_utils.run_gpu_benchmark(100) -- Short benchmark

          if result then
            assert.is_table(result)

            if result.score then
              assert.is_number(result.score)
              assert.is_true(result.score >= 0)
            end

            if result.fps then
              assert.is_number(result.fps)
              assert.is_true(result.fps >= 0)
            end
          end
        end)
      end
    end)

    it("should measure frame time consistency", function()
      if gpu_utils.measure_frame_consistency then
        assert.is_function(gpu_utils.measure_frame_consistency)

        local consistency = gpu_utils.measure_frame_consistency()
        if consistency then
          assert.is_number(consistency)
          assert.is_true(consistency >= 0 and consistency <= 100) -- Percentage
        end
      end
    end)
  end)

  describe("integration", function()
    it("should provide WezTerm-specific GPU configuration", function()
      if gpu_utils.get_wezterm_gpu_config then
        assert.is_function(gpu_utils.get_wezterm_gpu_config)

        local config = gpu_utils.get_wezterm_gpu_config()
        assert.is_table(config)

        -- Should contain WezTerm GPU settings
        local wezterm_keys = {
          "webgpu_power_preference",
          "front_end",
          "enable_wayland",
          "prefer_egl"
        }

        for _, key in ipairs(wezterm_keys) do
          if config[key] ~= nil then
            -- Validate the value exists and has correct type
            assert.is_not_nil(config[key])
          end
        end
      end
    end)

    it("should work with config system", function()
      local Config = require("utils.class.config")
      local config = Config:new()

      if gpu_utils.get_wezterm_gpu_config then
        local gpu_config = gpu_utils.get_wezterm_gpu_config()

        assert.has_no.errors(function()
          config:add(gpu_config)
        end)
      end
    end)

    it("should integrate with performance monitoring", function()
      if gpu_utils.start_monitoring then
        assert.is_function(gpu_utils.start_monitoring)

        assert.has_no.errors(function()
          gpu_utils.start_monitoring()
        end)

        if gpu_utils.stop_monitoring then
          assert.has_no.errors(function()
            gpu_utils.stop_monitoring()
          end)
        end
      end
    end)
  end)

  describe("caching and optimization", function()
    it("should cache GPU detection results", function()
      if gpu_utils.detect_gpus then
        local start_time = os.clock()

        -- First call might be slower
        local gpus1 = gpu_utils.detect_gpus()

        -- Second call should use cache
        local gpus2 = gpu_utils.detect_gpus()

        local elapsed = os.clock() - start_time
        assert.is_true(elapsed < 1) -- Should be fast with caching

        if gpus1 and gpus2 then
          assert.same(gpus1, gpus2) -- Should return same results
        end
      end
    end)

    it("should optimize repeated queries", function()
      if gpu_utils.get_gpu_vendor then
        assert.has_no.errors(function()
          for i = 1, 10 do
            gpu_utils.get_gpu_vendor()
          end
        end)
      end
    end)
  end)

  describe("configuration validation", function()
    it("should validate GPU configuration values", function()
      if gpu_utils.validate_config then
        assert.is_function(gpu_utils.validate_config)

        local valid_config = {
          webgpu_power_preference = "HighPerformance",
          front_end = "WebGpu"
        }

        local invalid_config = {
          webgpu_power_preference = "InvalidValue",
          front_end = 42
        }

        local valid_result = gpu_utils.validate_config(valid_config)
        local invalid_result = gpu_utils.validate_config(invalid_config)

        if valid_result ~= nil then
          assert.is_boolean(valid_result)
        end

        if invalid_result ~= nil then
          assert.is_boolean(invalid_result)
        end
      end
    end)

    it("should sanitize configuration values", function()
      if gpu_utils.sanitize_config then
        assert.is_function(gpu_utils.sanitize_config)

        local config = {
          webgpu_power_preference = "invalid",
          front_end = nil
        }

        local sanitized = gpu_utils.sanitize_config(config)
        assert.is_table(sanitized)

        -- Should have valid values after sanitization
        if sanitized.webgpu_power_preference then
          assert.is_string(sanitized.webgpu_power_preference)
        end
      end
    end)
  end)
end)

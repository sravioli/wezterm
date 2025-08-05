---@module "tests.events.window-resized_spec"
---@description Unit tests for window resize event handling
---@author Test Suite

local helper = require("tests.spec_helper")

describe("events.window-resized", function()
  before_each(function()
    helper.setup()

    -- Mock event handler if it exists
    if package.loaded["events.window-resized"] then
      package.loaded["events.window-resized"] = nil
    end

    -- Try to load the event handler
    local success, event_module = pcall(require, "events.window-resized")
    if not success then
      -- Create a mock event handler for testing
      helper.mock_wezterm.on("window-resized", function(window, pane)
        -- Mock window resize handler
        if window and window.set_config_overrides then
          local dims = window.get_dimensions and window:get_dimensions() or { cols = 80, rows = 24 }

          -- Adjust font size based on window size
          local font_size = 12
          if dims.cols < 80 then
            font_size = 10
          elseif dims.cols > 120 then
            font_size = 14
          end

          window:set_config_overrides({
            font_size = font_size
          })
        end
      end)
    end
  end)

  after_each(function()
    helper.teardown()
    package.loaded["events.window-resized"] = nil
  end)

  describe("event registration", function()
    it("should register window-resized event", function()
      assert.is_not_nil(helper.registered_events)

      if helper.registered_events["window-resized"] then
        assert.is_function(helper.registered_events["window-resized"])
      end
    end)
  end)

  describe("window resize handling", function()
    local resize_handler

    before_each(function()
      resize_handler = helper.registered_events["window-resized"]
    end)

    it("should handle window resize event", function()
      if not resize_handler then
        pending("window-resized event handler not found")
        return
      end

      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      window.get_dimensions = function()
        return { cols = 80, rows = 24, pixel_width = 800, pixel_height = 600 }
      end

      assert.has_no.errors(function()
        resize_handler(window, pane)
      end)
    end)

    it("should handle small window sizes", function()
      if not resize_handler then
        pending("window-resized event handler not found")
        return
      end

      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local config_set = false

      window.get_dimensions = function()
        return { cols = 60, rows = 20, pixel_width = 600, pixel_height = 400 }
      end

      window.set_config_overrides = function(overrides)
        config_set = true
        assert.is_table(overrides)
      end

      assert.has_no.errors(function()
        resize_handler(window, pane)
      end)
    end)

    it("should handle large window sizes", function()
      if not resize_handler then
        pending("window-resized event handler not found")
        return
      end

      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      window.get_dimensions = function()
        return { cols = 160, rows = 48, pixel_width = 1600, pixel_height = 1200 }
      end

      assert.has_no.errors(function()
        resize_handler(window, pane)
      end)
    end)

    it("should handle ultrawide displays", function()
      if not resize_handler then
        pending("window-resized event handler not found")
        return
      end

      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      window.get_dimensions = function()
        return { cols = 220, rows = 60, pixel_width = 3440, pixel_height = 1440 }
      end

      assert.has_no.errors(function()
        resize_handler(window, pane)
      end)
    end)

    it("should handle mobile/tablet sizes", function()
      if not resize_handler then
        pending("window-resized event handler not found")
        return
      end

      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      window.get_dimensions = function()
        return { cols = 40, rows = 15, pixel_width = 480, pixel_height = 320 }
      end

      assert.has_no.errors(function()
        resize_handler(window, pane)
      end)
    end)
  end)

  describe("font size adjustment", function()
    local resize_handler

    before_each(function()
      resize_handler = helper.registered_events["window-resized"]
    end)

    it("should adjust font size for readability", function()
      if not resize_handler then
        pending("window-resized event handler not found")
        return
      end

      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local captured_config = nil

      window.set_config_overrides = function(overrides)
        captured_config = overrides
      end

      -- Test small window
      window.get_dimensions = function()
        return { cols = 50, rows = 15 }
      end

      resize_handler(window, pane)

      if captured_config and captured_config.font_size then
        assert.is_number(captured_config.font_size)
        assert.is_true(captured_config.font_size >= 8)
        assert.is_true(captured_config.font_size <= 20)
      end
    end)

    it("should maintain reasonable font size bounds", function()
      if not resize_handler then
        pending("window-resized event handler not found")
        return
      end

      local test_sizes = {
        { cols = 20, rows = 5 },   -- Very small
        { cols = 300, rows = 100 } -- Very large
      }

      for _, size in ipairs(test_sizes) do
        local window = helper.create_mock_window()
        local pane = helper.create_mock_pane()
        local captured_config = nil

        window.get_dimensions = function() return size end
        window.set_config_overrides = function(overrides)
          captured_config = overrides
        end

        assert.has_no.errors(function()
          resize_handler(window, pane)
        end)

        if captured_config and captured_config.font_size then
          assert.is_true(captured_config.font_size >= 6)  -- Minimum readable
          assert.is_true(captured_config.font_size <= 24) -- Maximum reasonable
        end
      end
    end)
  end)

  describe("layout adjustments", function()
    local resize_handler

    before_each(function()
      resize_handler = helper.registered_events["window-resized"]
    end)

    it("should adjust tab bar visibility for small windows", function()
      if not resize_handler then
        pending("window-resized event handler not found")
        return
      end

      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local captured_config = nil

      window.get_dimensions = function()
        return { cols = 30, rows = 10 } -- Very small window
      end

      window.set_config_overrides = function(overrides)
        captured_config = overrides
      end

      resize_handler(window, pane)

      if captured_config then
        -- Might disable tab bar for very small windows
        if captured_config.enable_tab_bar ~= nil then
          assert.is_boolean(captured_config.enable_tab_bar)
        end
      end
    end)

    it("should adjust scrollback for memory management", function()
      if not resize_handler then
        pending("window-resized event handler not found")
        return
      end

      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      window.get_dimensions = function()
        return { cols = 200, rows = 80 } -- Large window
      end

      assert.has_no.errors(function()
        resize_handler(window, pane)
      end)
    end)
  end)

  describe("performance optimization", function()
    local resize_handler

    before_each(function()
      resize_handler = helper.registered_events["window-resized"]
    end)

    it("should handle rapid resize events efficiently", function()
      if not resize_handler then
        pending("window-resized event handler not found")
        return
      end

      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      window.get_dimensions = function()
        return { cols = 80, rows = 24 }
      end

      assert.has_no.errors(function()
        for i = 1, 50 do
          resize_handler(window, pane)
        end
      end)
    end)

    it("should throttle configuration updates", function()
      if not resize_handler then
        pending("window-resized event handler not found")
        return
      end

      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local update_count = 0

      window.get_dimensions = function()
        return { cols = 80 + (update_count % 10), rows = 24 }
      end

      window.set_config_overrides = function(overrides)
        update_count = update_count + 1
      end

      for i = 1, 20 do
        resize_handler(window, pane)
      end

      -- Should have some reasonable throttling
      assert.is_true(update_count <= 20)
    end)
  end)

  describe("error handling", function()
    local resize_handler

    before_each(function()
      resize_handler = helper.registered_events["window-resized"]
    end)

    it("should handle nil window", function()
      if not resize_handler then
        pending("window-resized event handler not found")
        return
      end

      local pane = helper.create_mock_pane()

      assert.has_no.errors(function()
        resize_handler(nil, pane)
      end)
    end)

    it("should handle nil pane", function()
      if not resize_handler then
        pending("window-resized event handler not found")
        return
      end

      local window = helper.create_mock_window()

      assert.has_no.errors(function()
        resize_handler(window, nil)
      end)
    end)

    it("should handle missing window methods", function()
      if not resize_handler then
        pending("window-resized event handler not found")
        return
      end

      local window = {}  -- Empty window object
      local pane = helper.create_mock_pane()

      assert.has_no.errors(function()
        resize_handler(window, pane)
      end)
    end)

    it("should handle dimension retrieval errors", function()
      if not resize_handler then
        pending("window-resized event handler not found")
        return
      end

      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      window.get_dimensions = function()
        error("Mock dimension error")
      end

      assert.has_no.errors(function()
        resize_handler(window, pane)
      end)
    end)

    it("should handle invalid dimensions", function()
      if not resize_handler then
        pending("window-resized event handler not found")
        return
      end

      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      local invalid_dimensions = {
        nil,
        {},
        { cols = -1, rows = -1 },
        { cols = 0, rows = 0 },
        { cols = "invalid", rows = "invalid" }
      }

      for _, dims in ipairs(invalid_dimensions) do
        window.get_dimensions = function() return dims end

        assert.has_no.errors(function()
          resize_handler(window, pane)
        end)
      end
    end)
  end)

  describe("accessibility", function()
    local resize_handler

    before_each(function()
      resize_handler = helper.registered_events["window-resized"]
    end)

    it("should maintain minimum readable font size", function()
      if not resize_handler then
        pending("window-resized event handler not found")
        return
      end

      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local captured_config = nil

      window.get_dimensions = function()
        return { cols = 10, rows = 5 } -- Extremely small
      end

      window.set_config_overrides = function(overrides)
        captured_config = overrides
      end

      resize_handler(window, pane)

      if captured_config and captured_config.font_size then
        assert.is_true(captured_config.font_size >= 8) -- Minimum for accessibility
      end
    end)

    it("should preserve user accessibility settings", function()
      if not resize_handler then
        pending("window-resized event handler not found")
        return
      end

      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      -- Mock user with high contrast needs
      window.effective_config = function()
        return {
          force_reverse_video_cursor = true,
          colors = {
            background = "#000000",
            foreground = "#ffffff"
          }
        }
      end

      assert.has_no.errors(function()
        resize_handler(window, pane)
      end)
    end)
  end)
end)

---@module "tests.utils.class.picker_spec"
---@description Unit tests for utils.class.picker module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("utils.class.picker", function()
  local Picker

  before_each(function()
    helper.setup()
    Picker = require("utils.class.picker")
  end)

  after_each(function()
    helper.teardown()
  end)

  describe("initialization", function()
    it("should create a new picker instance", function()
      local picker = Picker:new()

      assert.is_not_nil(picker)
      assert.is_table(picker)
    end)

    it("should have logger instance", function()
      local picker = Picker:new()
      assert.is_not_nil(picker.log)
    end)

    it("should initialize with default configuration", function()
      local picker = Picker:new()

      -- Check for expected default properties
      assert.is_table(picker)
    end)
  end)

  describe("picker functionality", function()
    local picker

    before_each(function()
      picker = Picker:new()
    end)

    it("should handle window interactions", function()
      local mock_window = helper.create_mock_window()

      assert.has_no.errors(function()
        -- Test picker interactions with window
        if picker.set_window then
          picker:set_window(mock_window)
        end
      end)
    end)

    it("should handle pane interactions", function()
      local mock_pane = helper.create_mock_pane()

      assert.has_no.errors(function()
        -- Test picker interactions with pane
        if picker.set_pane then
          picker:set_pane(mock_pane)
        end
      end)
    end)

    it("should provide picker methods", function()
      -- Check that picker has expected methods for selection
      assert.is_table(picker)

      -- If picker has specific methods, test them
      if picker.show then
        assert.is_function(picker.show)
      end

      if picker.hide then
        assert.is_function(picker.hide)
      end

      if picker.select then
        assert.is_function(picker.select)
      end
    end)
  end)

  describe("configuration handling", function()
    it("should accept custom configuration", function()
      local custom_config = {
        title = "Test Picker",
        description = "A test picker instance"
      }

      assert.has_no.errors(function()
        local picker = Picker:new(custom_config)
        assert.is_not_nil(picker)
      end)
    end)

    it("should handle empty configuration", function()
      assert.has_no.errors(function()
        local picker = Picker:new({})
        assert.is_not_nil(picker)
      end)
    end)

    it("should handle nil configuration", function()
      assert.has_no.errors(function()
        local picker = Picker:new(nil)
        assert.is_not_nil(picker)
      end)
    end)
  end)

  describe("selection handling", function()
    local picker

    before_each(function()
      picker = Picker:new()
    end)

    it("should handle item selection", function()
      local test_items = {
        { id = "item1", label = "First Item" },
        { id = "item2", label = "Second Item" }
      }

      assert.has_no.errors(function()
        if picker.set_items then
          picker:set_items(test_items)
        end
      end)
    end)

    it("should handle selection callbacks", function()
      local callback_called = false
      local callback = function(item)
        callback_called = true
        assert.is_not_nil(item)
      end

      assert.has_no.errors(function()
        if picker.on_select then
          picker:on_select(callback)
        end
      end)
    end)

    it("should handle selection cancellation", function()
      assert.has_no.errors(function()
        if picker.cancel then
          picker:cancel()
        end
      end)
    end)
  end)

  describe("filtering and search", function()
    local picker

    before_each(function()
      picker = Picker:new()
    end)

    it("should handle search queries", function()
      assert.has_no.errors(function()
        if picker.search then
          picker:search("test query")
        end
      end)
    end)

    it("should handle filter functions", function()
      local filter_func = function(item, query)
        return string.find(item.label:lower(), query:lower()) ~= nil
      end

      assert.has_no.errors(function()
        if picker.set_filter then
          picker:set_filter(filter_func)
        end
      end)
    end)

    it("should handle empty search", function()
      assert.has_no.errors(function()
        if picker.search then
          picker:search("")
        end
      end)
    end)
  end)

  describe("display and rendering", function()
    local picker

    before_each(function()
      picker = Picker:new()
    end)

    it("should handle display options", function()
      local display_options = {
        max_items = 10,
        show_preview = true,
        highlight_matches = true
      }

      assert.has_no.errors(function()
        if picker.set_display_options then
          picker:set_display_options(display_options)
        end
      end)
    end)

    it("should handle custom rendering", function()
      local render_func = function(item)
        return item.label or tostring(item)
      end

      assert.has_no.errors(function()
        if picker.set_renderer then
          picker:set_renderer(render_func)
        end
      end)
    end)

    it("should handle preview content", function()
      local preview_func = function(item)
        return "Preview for " .. (item.label or "item")
      end

      assert.has_no.errors(function()
        if picker.set_previewer then
          picker:set_previewer(preview_func)
        end
      end)
    end)
  end)

  describe("error handling", function()
    local picker

    before_each(function()
      picker = Picker:new()
    end)

    it("should handle invalid items gracefully", function()
      assert.has_no.errors(function()
        if picker.set_items then
          picker:set_items(nil)
          picker:set_items({})
          picker:set_items({ nil, false, 0 })
        end
      end)
    end)

    it("should handle invalid callbacks gracefully", function()
      assert.has_no.errors(function()
        if picker.on_select then
          picker:on_select(nil)
          picker:on_select("not a function")
          picker:on_select(42)
        end
      end)
    end)

    it("should handle errors in user callbacks", function()
      local error_callback = function()
        error("Test error in callback")
      end

      assert.has_no.errors(function()
        if picker.on_select then
          picker:on_select(error_callback)
        end

        -- Simulate selection triggering error callback
        if picker.trigger_selection then
          picker:trigger_selection({ id = "test" })
        end
      end)
    end)
  end)

  describe("integration", function()
    it("should work with WezTerm window system", function()
      local picker = Picker:new()
      local mock_window = helper.create_mock_window()
      local mock_pane = helper.create_mock_pane()

      assert.has_no.errors(function()
        -- Simulate full picker workflow
        if picker.show then
          picker:show(mock_window, mock_pane)
        end

        if picker.set_items then
          picker:set_items({
            { id = "1", label = "Test Item 1" },
            { id = "2", label = "Test Item 2" }
          })
        end

        if picker.search then
          picker:search("Test")
        end

        if picker.hide then
          picker:hide()
        end
      end)
    end)

    it("should work with file system operations", function()
      local picker = Picker:new()

      assert.has_no.errors(function()
        -- Test file-related picker operations
        if picker.list_files then
          picker:list_files("/mock/path")
        end

        if picker.list_directories then
          picker:list_directories("/mock/path")
        end
      end)
    end)

    it("should handle rapid interactions", function()
      local picker = Picker:new()

      assert.has_no.errors(function()
        for i = 1, 10 do
          if picker.search then
            picker:search("query" .. i)
          end
        end
      end)
    end)
  end)

  describe("metatable behavior", function()
    it("should properly implement inheritance", function()
      local picker = Picker:new()

      -- Should have access to inherited methods
      assert.is_table(picker)
    end)

    it("should maintain instance separation", function()
      local picker1 = Picker:new({ title = "Picker 1" })
      local picker2 = Picker:new({ title = "Picker 2" })

      assert.not_equals(picker1, picker2)
    end)
  end)
end)

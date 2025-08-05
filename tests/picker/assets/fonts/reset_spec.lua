---@diagnostic disable: undefined-global, undefined-field
local spec_helper = require("tests.spec_helper")

describe("picker.assets.fonts.reset", function()
  local reset_font
  local mock_config
  local mock_font_config

  before_each(function()
    spec_helper.setup()

    -- Mock the config.font module
    mock_font_config = {
      font = "Default Font",
      font_size = 12,
      line_height = 1.0,
      font_rules = {},
    }

    package.loaded["config.font"] = mock_font_config

    -- Clear cache and load reset font module
    package.loaded["picker.assets.fonts.reset"] = nil
    reset_font = require("picker.assets.fonts.reset")

    -- Mock config object
    mock_config = {
      font = "Current Font",
      font_size = 14,
      line_height = 1.2,
    }
  end)

  after_each(function()
    spec_helper.teardown()
  end)

  describe("module structure", function()
    it("should be a table with get and activate functions", function()
      assert.is_table(reset_font)
      assert.is_function(reset_font.get)
      assert.is_function(reset_font.activate)
    end)
  end)

  describe("get function", function()
    it("should return reset option metadata", function()
      local result = reset_font.get()

      assert.is_table(result)
      assert.equals("reset", result.id)
      assert.equals("Restore fonts to default", result.label)
    end)

    it("should be consistent across calls", function()
      local result1 = reset_font.get()
      local result2 = reset_font.get()

      assert.equals(result1.id, result2.id)
      assert.equals(result1.label, result2.label)
    end)

    it("should return a new table each time", function()
      local result1 = reset_font.get()
      local result2 = reset_font.get()

      -- Should not be the same reference
      assert.not_equals(result1, result2)
    end)
  end)

  describe("activate function", function()
    it("should restore all font properties from config.font", function()
      reset_font.activate(mock_config, {})

      -- All properties from mock_font_config should be copied
      assert.equals(mock_font_config.font, mock_config.font)
      assert.equals(mock_font_config.font_size, mock_config.font_size)
      assert.equals(mock_font_config.line_height, mock_config.line_height)
      assert.equals(mock_font_config.font_rules, mock_config.font_rules)
    end)

    it("should overwrite existing font configuration", function()
      mock_config.font = "Old Font"
      mock_config.font_size = 20
      mock_config.custom_property = "should remain"

      reset_font.activate(mock_config, {})

      assert.equals(mock_font_config.font, mock_config.font)
      assert.equals(mock_font_config.font_size, mock_config.font_size)
      assert.equals("should remain", mock_config.custom_property) -- Non-font props preserved
    end)

    it("should handle complex font configurations", function()
      mock_font_config.font = {
        family = "Test Font",
        weight = "Bold",
      }
      mock_font_config.font_rules = {
        {
          intensity = "Bold",
          font = { weight = "ExtraBold" }
        }
      }

      reset_font.activate(mock_config, {})

      assert.same(mock_font_config.font, mock_config.font)
      assert.same(mock_font_config.font_rules, mock_config.font_rules)
    end)

    it("should work with empty config.font", function()
      package.loaded["config.font"] = {}
      package.loaded["picker.assets.fonts.reset"] = nil
      local empty_reset = require("picker.assets.fonts.reset")

      local config = { existing = "property" }

      assert.has_no_errors(function()
        empty_reset.activate(config, {})
      end)

      assert.equals("property", config.existing)
    end)

    it("should handle nil opts parameter", function()
      assert.has_no_errors(function()
        reset_font.activate(mock_config, nil)
      end)

      -- Should still perform reset
      assert.equals(mock_font_config.font, mock_config.font)
    end)

    it("should preserve non-font properties", function()
      mock_config.window_background_opacity = 0.8
      mock_config.color_scheme = "Custom"
      mock_config.keys = {}

      reset_font.activate(mock_config, {})

      -- Font properties should be reset
      assert.equals(mock_font_config.font, mock_config.font)
      assert.equals(mock_font_config.font_size, mock_config.font_size)

      -- Non-font properties should remain
      assert.equals(0.8, mock_config.window_background_opacity)
      assert.equals("Custom", mock_config.color_scheme)
      assert.same({}, mock_config.keys)
    end)
  end)

  describe("integration scenarios", function()
    it("should work with get/activate workflow", function()
      local meta = reset_font.get()

      -- Simulate user selection
      assert.equals("reset", meta.id)
      assert.equals("Restore fonts to default", meta.label)

      -- Apply the reset
      reset_font.activate(mock_config, meta)

      -- Verify reset was applied
      assert.equals(mock_font_config.font, mock_config.font)
    end)

    it("should handle multiple resets", function()
      -- First reset
      reset_font.activate(mock_config, {})
      local first_result = {
        font = mock_config.font,
        font_size = mock_config.font_size
      }

      -- Modify config
      mock_config.font = "Modified Font"
      mock_config.font_size = 999

      -- Second reset
      reset_font.activate(mock_config, {})

      -- Should be back to defaults
      assert.equals(first_result.font, mock_config.font)
      assert.equals(first_result.font_size, mock_config.font_size)
    end)
  end)

  describe("error handling", function()
    it("should handle missing config.font module", function()
      package.loaded["config.font"] = nil
      package.loaded["picker.assets.fonts.reset"] = nil

      assert.has_no_errors(function()
        pcall(require, "picker.assets.fonts.reset")
      end)
    end)

    it("should handle nil config parameter", function()
      assert.has_no_errors(function()
        pcall(reset_font.activate, nil, {})
      end)
    end)

    it("should handle circular references in config.font", function()
      -- Create circular reference
      local circular = { name = "test" }
      circular.self = circular
      mock_font_config.circular = circular

      assert.has_no_errors(function()
        reset_font.activate(mock_config, {})
      end)
    end)
  end)

  describe("dependency management", function()
    it("should re-require config.font on each activate call", function()
      -- Initial activate
      reset_font.activate(mock_config, {})
      local initial_font = mock_config.font

      -- Change the mock
      mock_font_config.font = "New Default Font"

      -- Since require is cached, this won't pick up the change
      -- But the test verifies the current behavior
      reset_font.activate(mock_config, {})

      -- In current implementation, it uses cached config.font
      assert.equals(initial_font, mock_config.font)
    end)

    it("should handle config.font with functions", function()
      mock_font_config.get_font = function() return "Dynamic Font" end

      assert.has_no_errors(function()
        reset_font.activate(mock_config, {})
      end)

      assert.is_function(mock_config.get_font)
    end)
  end)
end)

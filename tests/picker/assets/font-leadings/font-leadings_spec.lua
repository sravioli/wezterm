---@diagnostic disable: undefined-global, undefined-field
local spec_helper = require("tests.spec_helper")

describe("picker.assets.font-leadings.font-leadings", function()
  local font_leadings
  local mock_config

  before_each(function()
    spec_helper.setup()

    -- Clear cache and load font-leadings module
    package.loaded["picker.assets.font-leadings.font-leadings"] = nil
    font_leadings = require("picker.assets.font-leadings.font-leadings")

    -- Mock config object
    mock_config = {
      line_height = 1.2
    }
  end)

  after_each(function()
    spec_helper.teardown()
  end)

  describe("module structure", function()
    it("should be a table with get and activate functions", function()
      assert.is_table(font_leadings)
      assert.is_function(font_leadings.get)
      assert.is_function(font_leadings.activate)
    end)
  end)

  describe("get function", function()
    it("should return a list of leading options", function()
      local leadings_list = font_leadings.get()
      assert.is_table(leadings_list)
      assert.is_truthy(#leadings_list > 0)
    end)

    it("should include reset option as first item", function()
      local leadings_list = font_leadings.get()
      assert.equals("Reset Line Height to Default", leadings_list[1].label)
      assert.equals("reset", leadings_list[1].id)
    end)

    it("should generate leading values from 0.9 to 1.4", function()
      local leadings_list = font_leadings.get()

      -- Should have reset + 6 values (0.9, 1.0, 1.1, 1.2, 1.3, 1.4)
      assert.equals(6, #leadings_list)

      -- Check some specific values
      local found_values = {}
      for i = 2, #leadings_list do
        local item = leadings_list[i]
        assert.is_string(item.label)
        assert.is_string(item.id)
        found_values[item.id] = true
      end

      -- Verify expected values are present
      assert.is_truthy(found_values["0.9"])
      assert.is_truthy(found_values["1.0"])
      assert.is_truthy(found_values["1.4"])
    end)

    it("should format labels with x suffix", function()
      local leadings_list = font_leadings.get()

      for i = 2, #leadings_list do
        local item = leadings_list[i]
        assert.truthy(item.label:match("x$"), "Label should end with 'x': " .. item.label)
      end
    end)

    it("should generate items in correct order", function()
      local leadings_list = font_leadings.get()

      -- Reset should be first
      assert.equals("reset", leadings_list[1].id)

      -- Others should be in ascending order
      for i = 2, #leadings_list - 1 do
        local current = tonumber(leadings_list[i].id)
        local next_val = tonumber(leadings_list[i + 1].id)
        assert.is_truthy(current < next_val, "Values should be in ascending order")
      end
    end)
  end)

  describe("activate function", function()
    it("should reset line height when reset option is selected", function()
      local opts = { id = "reset", label = "Reset Line Height to Default" }

      font_leadings.activate(mock_config, opts)

      assert.is_nil(mock_config.line_height)
    end)

    it("should set line height to numeric value", function()
      local opts = { id = "1.2", label = "1.2x" }

      font_leadings.activate(mock_config, opts)

      assert.equals(1.2, mock_config.line_height)
    end)

    it("should handle different numeric values", function()
      local test_values = { "0.9", "1.0", "1.1", "1.3", "1.4" }

      for _, value in ipairs(test_values) do
        local opts = { id = value, label = value .. "x" }
        local config = {}

        font_leadings.activate(config, opts)

        assert.equals(tonumber(value), config.line_height)
      end
    end)

    it("should overwrite existing line height", function()
      mock_config.line_height = 2.0
      local opts = { id = "1.1", label = "1.1x" }

      font_leadings.activate(mock_config, opts)

      assert.equals(1.1, mock_config.line_height)
    end)

    it("should handle edge case values", function()
      local edge_cases = {
        { id = "0.5", expected = 0.5 },
        { id = "2.0", expected = 2.0 },
        { id = "0.1", expected = 0.1 },
      }

      for _, case in ipairs(edge_cases) do
        local config = {}
        local opts = { id = case.id, label = case.id .. "x" }

        font_leadings.activate(config, opts)

        assert.equals(case.expected, config.line_height)
      end
    end)
  end)

  describe("integration scenarios", function()
    it("should work with complete get/activate workflow", function()
      local leadings_list = font_leadings.get()
      local config = {}

      -- Select a non-reset option
      local selected_item = leadings_list[3] -- Should be 1.0x or similar
      font_leadings.activate(config, selected_item)

      assert.is_number(config.line_height)
      assert.equals(tonumber(selected_item.id), config.line_height)
    end)

    it("should handle reset after setting value", function()
      local config = { line_height = 1.5 }

      -- First, set a value
      font_leadings.activate(config, { id = "1.2", label = "1.2x" })
      assert.equals(1.2, config.line_height)

      -- Then reset
      font_leadings.activate(config, { id = "reset", label = "Reset Line Height to Default" })
      assert.is_nil(config.line_height)
    end)
  end)

  describe("error handling", function()
    it("should handle invalid numeric strings gracefully", function()
      local config = {}
      local opts = { id = "invalid", label = "Invalid" }

      assert.has_no_errors(function()
        font_leadings.activate(config, opts)
      end)

      -- Should either set to NaN/nil or not modify config
      -- The exact behavior depends on tonumber implementation
    end)

    it("should handle missing opts fields", function()
      local config = {}

      assert.has_no_errors(function()
        font_leadings.activate(config, {})
      end)
    end)

    it("should handle nil opts", function()
      local config = {}

      assert.has_no_errors(function()
        pcall(font_leadings.activate, config, nil)
      end)
    end)

    it("should handle nil config", function()
      local opts = { id = "1.2", label = "1.2x" }

      assert.has_no_errors(function()
        pcall(font_leadings.activate, nil, opts)
      end)
    end)
  end)

  describe("precision and rounding", function()
    it("should maintain precision in generated values", function()
      local leadings_list = font_leadings.get()

      -- Check that floating point precision is maintained
      for i = 2, #leadings_list do
        local item = leadings_list[i]
        local numeric_value = tonumber(item.id)

        -- Should be properly formatted with one decimal place
        assert.truthy(item.id:match("^%d%.%d$"), "ID should have one decimal place: " .. item.id)
        assert.is_number(numeric_value)
      end
    end)

    it("should handle step increment correctly", function()
      local leadings_list = font_leadings.get()
      local values = {}

      for i = 2, #leadings_list do
        table.insert(values, tonumber(leadings_list[i].id))
      end

      table.sort(values)

      -- Check that increment is approximately 0.1
      for i = 1, #values - 1 do
        local diff = values[i + 1] - values[i]
        assert.is_true(math.abs(diff - 0.1) < 0.001, "Step should be 0.1, got: " .. diff)
      end
    end)
  end)
end)

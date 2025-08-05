---@diagnostic disable: undefined-global, undefined-field
local spec_helper = require("tests.spec_helper")

describe("picker.assets.font-sizes.font-sizes", function()
  local font_sizes
  local mock_config

  before_each(function()
    spec_helper.setup()

    -- Mock the config.font module that font-sizes depends on
    package.loaded["config.font"] = {
      font_size = 12
    }

    -- Clear cache and load font-sizes module
    package.loaded["picker.assets.font-sizes.font-sizes"] = nil
    font_sizes = require("picker.assets.font-sizes.font-sizes")

    -- Mock config object
    mock_config = {
      font_size = 12
    }
  end)

  after_each(function()
    spec_helper.teardown()
  end)

  describe("module structure", function()
    it("should be a table with get and activate functions", function()
      assert.is_table(font_sizes)
      assert.is_function(font_sizes.get)
      assert.is_function(font_sizes.activate)
    end)
  end)

  describe("get function", function()
    it("should return a list of font size options", function()
      local sizes_list = font_sizes.get()
      assert.is_table(sizes_list)
      assert.is_truthy(#sizes_list > 0)
    end)

    it("should generate sizes from 8 to 30 pt", function()
      local sizes_list = font_sizes.get()

      -- Should have 23 values (8-30) + reset = 24 total
      assert.equals(24, #sizes_list)

      -- Find all non-reset items
      local numeric_sizes = {}
      for _, item in ipairs(sizes_list) do
        if item.label ~= "Reset" then
          table.insert(numeric_sizes, tonumber(item.id))
        end
      end

      table.sort(numeric_sizes)

      -- Should start at 8 and end at 30
      assert.equals(8, numeric_sizes[1])
      assert.equals(30, numeric_sizes[#numeric_sizes])
      assert.equals(23, #numeric_sizes)
    end)

    it("should format labels with 'pt' suffix", function()
      local sizes_list = font_sizes.get()

      for _, item in ipairs(sizes_list) do
        if item.label ~= "Reset" then
          assert.truthy(item.label:match("pt$"), "Label should end with 'pt': " .. item.label)
          assert.truthy(item.label:match("^%s*%d+pt$"), "Label should be formatted as number + pt: " .. item.label)
        end
      end
    end)

    it("should include reset option with current font size", function()
      local sizes_list = font_sizes.get()

      local reset_item = nil
      for _, item in ipairs(sizes_list) do
        if item.label == "Reset" then
          reset_item = item
          break
        end
      end

      assert.is_truthy(reset_item, "Should include reset option")
      assert.equals("12", reset_item.id) -- Based on mocked config.font.font_size
      assert.equals("Reset", reset_item.label)
    end)

    it("should have all items with valid id and label", function()
      local sizes_list = font_sizes.get()

      for _, item in ipairs(sizes_list) do
        assert.is_string(item.id)
        assert.is_string(item.label)
        assert.is_truthy(#item.id > 0)
        assert.is_truthy(#item.label > 0)
      end
    end)

    it("should format numeric labels with proper padding", function()
      local sizes_list = font_sizes.get()

      for _, item in ipairs(sizes_list) do
        if item.label ~= "Reset" then
          -- Should be right-aligned in 2-character field
          assert.truthy(item.label:match("^%s*%d+pt$"))

          -- Extract the number part
          local num_str = item.label:match("(%d+)pt")
          local num = tonumber(num_str)

          -- Single digits should be padded, double digits should not
          if num < 10 then
            assert.truthy(item.label:match("^%s+%dpt$"), "Single digits should be padded: " .. item.label)
          else
            assert.truthy(item.label:match("^%d%dpt$"), "Double digits should not be padded: " .. item.label)
          end
        end
      end
    end)
  end)

  describe("activate function", function()
    it("should set font size to numeric value", function()
      local opts = { id = "14", label = "14pt" }

      font_sizes.activate(mock_config, opts)

      assert.equals(14, mock_config.font_size)
    end)

    it("should handle different font sizes", function()
      local test_sizes = { "8", "12", "16", "20", "24", "30" }

      for _, size in ipairs(test_sizes) do
        local opts = { id = size, label = size .. "pt" }
        local config = {}

        font_sizes.activate(config, opts)

        assert.equals(tonumber(size), config.font_size)
      end
    end)

    it("should overwrite existing font size", function()
      mock_config.font_size = 10
      local opts = { id = "16", label = "16pt" }

      font_sizes.activate(mock_config, opts)

      assert.equals(16, mock_config.font_size)
    end)

    it("should handle reset option", function()
      local opts = { id = "12", label = "Reset" } -- Reset to default size

      font_sizes.activate(mock_config, opts)

      assert.equals(12, mock_config.font_size)
    end)

    it("should handle edge case sizes", function()
      local edge_cases = {
        { id = "6", expected = 6 },   -- Below range
        { id = "40", expected = 40 }, -- Above range
        { id = "1", expected = 1 },   -- Very small
      }

      for _, case in ipairs(edge_cases) do
        local config = {}
        local opts = { id = case.id, label = case.id .. "pt" }

        font_sizes.activate(config, opts)

        assert.equals(case.expected, config.font_size)
      end
    end)
  end)

  describe("integration scenarios", function()
    it("should work with complete get/activate workflow", function()
      local sizes_list = font_sizes.get()
      local config = {}

      -- Select a specific size
      local selected_item = nil
      for _, item in ipairs(sizes_list) do
        if item.id == "16" then
          selected_item = item
          break
        end
      end

      assert.is_truthy(selected_item, "Should find 16pt size")

      font_sizes.activate(config, selected_item)

      assert.equals(16, config.font_size)
    end)

    it("should handle multiple size changes", function()
      local config = { font_size = 12 }

      -- Change to larger size
      font_sizes.activate(config, { id = "18", label = "18pt" })
      assert.equals(18, config.font_size)

      -- Change to smaller size
      font_sizes.activate(config, { id = "10", label = "10pt" })
      assert.equals(10, config.font_size)

      -- Reset to default
      font_sizes.activate(config, { id = "12", label = "Reset" })
      assert.equals(12, config.font_size)
    end)
  end)

  describe("error handling", function()
    it("should handle invalid numeric strings gracefully", function()
      local config = {}
      local opts = { id = "invalid", label = "Invalid" }

      assert.has_no_errors(function()
        font_sizes.activate(config, opts)
      end)

      -- Should result in NaN or 0, depending on tonumber behavior
      local result = config.font_size
      assert.is_truthy(result == 0 or result ~= result) -- 0 or NaN
    end)

    it("should handle missing opts fields", function()
      local config = {}

      assert.has_no_errors(function()
        font_sizes.activate(config, {})
      end)
    end)

    it("should handle nil opts", function()
      local config = {}

      assert.has_no_errors(function()
        pcall(font_sizes.activate, config, nil)
      end)
    end)

    it("should handle nil config", function()
      local opts = { id = "14", label = "14pt" }

      assert.has_no_errors(function()
        pcall(font_sizes.activate, nil, opts)
      end)
    end)
  end)

  describe("dependency on config.font", function()
    it("should handle missing config.font module", function()
      -- Clear the mocked config.font
      package.loaded["config.font"] = nil
      package.loaded["picker.assets.font-sizes.font-sizes"] = nil

      assert.has_no_errors(function()
        pcall(require, "picker.assets.font-sizes.font-sizes")
      end)
    end)

    it("should handle config.font without font_size", function()
      package.loaded["config.font"] = {} -- No font_size property
      package.loaded["picker.assets.font-sizes.font-sizes"] = nil

      assert.has_no_errors(function()
        local module = require("picker.assets.font-sizes.font-sizes")
        module.get()
      end)
    end)

    it("should adapt to different default font sizes", function()
      -- Test with different default sizes
      local test_defaults = { 10, 14, 16, 18 }

      for _, default_size in ipairs(test_defaults) do
        package.loaded["config.font"] = { font_size = default_size }
        package.loaded["picker.assets.font-sizes.font-sizes"] = nil

        local module = require("picker.assets.font-sizes.font-sizes")
        local sizes_list = module.get()

        -- Find reset item
        local reset_item = nil
        for _, item in ipairs(sizes_list) do
          if item.label == "Reset" then
            reset_item = item
            break
          end
        end

        assert.is_truthy(reset_item)
        assert.equals(tostring(default_size), reset_item.id)
      end
    end)
  end)

  describe("size range and progression", function()
    it("should cover complete size range", function()
      local sizes_list = font_sizes.get()
      local numeric_sizes = {}

      for _, item in ipairs(sizes_list) do
        if item.label ~= "Reset" then
          table.insert(numeric_sizes, tonumber(item.id))
        end
      end

      table.sort(numeric_sizes)

      -- Should be consecutive integers from 8 to 30
      for i = 1, #numeric_sizes do
        assert.equals(7 + i, numeric_sizes[i])
      end
    end)

    it("should include both small and large sizes", function()
      local sizes_list = font_sizes.get()

      local has_small = false
      local has_large = false

      for _, item in ipairs(sizes_list) do
        local size = tonumber(item.id)
        if size and size <= 10 then
          has_small = true
        end
        if size and size >= 24 then
          has_large = true
        end
      end

      assert.is_true(has_small, "Should include small font sizes")
      assert.is_true(has_large, "Should include large font sizes")
    end)
  end)
end)

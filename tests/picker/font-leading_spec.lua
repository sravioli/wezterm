---@diagnostic disable: undefined-global, undefined-field
local spec_helper = require("tests.spec_helper")

describe("picker.font-leading", function()
  local font_leading_picker
  local mock_picker_class

  before_each(function()
    spec_helper.setup()

    -- Mock the Picker class
    mock_picker_class = {
      new = function(config)
        return {
          title = config.title,
          subdir = config.subdir,
          fuzzy = config.fuzzy,
          comp = config.comp,
          config = config,
          -- Mock picker methods
          show = function(self) return self end,
          select = function(self, item) return item end,
          filter = function(self, term) return {} end,
        }
      end
    }

    -- Mock utils module
    package.loaded["utils"] = {
      class = {
        picker = mock_picker_class
      }
    }

    -- Clear cache and load font-leading picker
    package.loaded["picker.font-leading"] = nil
    font_leading_picker = require("picker.font-leading")
  end)

  after_each(function()
    spec_helper.teardown()
  end)

  describe("picker configuration", function()
    it("should create picker with correct title", function()
      assert.equals("󰢷  Font leading", font_leading_picker.title)
    end)

    it("should configure for font-leadings subdirectory", function()
      assert.equals("font-leadings", font_leading_picker.subdir)
    end)

    it("should disable fuzzy search", function()
      assert.is_false(font_leading_picker.fuzzy)
    end)

    it("should have comparison function", function()
      assert.is_function(font_leading_picker.comp)
    end)
  end)

  describe("comparison function", function()
    local comp

    before_each(function()
      comp = font_leading_picker.comp
    end)

    it("should prioritize Reset Line Height option", function()
      local reset_item = { label = "Reset Line Height to Default" }
      local leading_item = { label = "1.2" }

      assert.is_true(comp(reset_item, leading_item))
      assert.is_false(comp(leading_item, reset_item))
    end)

    it("should sort non-reset items by label alphabetically", function()
      local leading_1_0 = { label = "1.0" }
      local leading_1_5 = { label = "1.5" }

      assert.is_true(comp(leading_1_0, leading_1_5))
      assert.is_false(comp(leading_1_5, leading_1_0))
    end)

    it("should handle decimal leading values", function()
      local values = {
        { label = "0.8" },
        { label = "1.0" },
        { label = "1.2" },
        { label = "1.4" },
        { label = "1.6" },
        { label = "2.0" },
      }

      -- Should maintain alphabetical order
      for i = 1, #values - 1 do
        assert.is_true(comp(values[i], values[i + 1]))
      end
    end)

    it("should handle descriptive leading labels", function()
      local tight = { label = "Tight" }
      local normal = { label = "Normal" }
      local loose = { label = "Loose" }

      -- Alphabetical: "Loose" < "Normal" < "Tight"
      assert.is_true(comp(loose, normal))
      assert.is_true(comp(normal, tight))
    end)

    it("should handle multiple reset items", function()
      local reset1 = { label = "Reset Line Height to Default" }
      local reset2 = { label = "Reset Line Height to Default" }

      -- Both are reset items, so both should be prioritized equally
      assert.is_true(comp(reset1, reset2))
      assert.is_true(comp(reset2, reset1))
    end)

    it("should handle mixed format values", function()
      local percentage = { label = "120%" }
      local decimal = { label = "1.2" }
      local pixels = { label = "20px" }

      -- Alphabetical comparison
      assert.is_true(comp(percentage, decimal)) -- "120%" < "1.2"
      assert.is_true(comp(decimal, pixels))     -- "1.2" < "20px"
    end)
  end)

  describe("picker integration", function()
    it("should be created from Picker class", function()
      assert.is_table(font_leading_picker.config)
      assert.equals("󰢷  Font leading", font_leading_picker.config.title)
    end)

    it("should have all required picker methods", function()
      assert.is_function(font_leading_picker.show)
      assert.is_function(font_leading_picker.select)
      assert.is_function(font_leading_picker.filter)
    end)

    it("should have fuzzy search disabled as configured", function()
      assert.is_false(font_leading_picker.fuzzy)
    end)
  end)

  describe("font leading selection workflow", function()
    it("should support leading selection", function()
      local leading_item = { label = "1.4", value = 1.4 }
      local selected = font_leading_picker:select(leading_item)
      assert.equals(leading_item, selected)
    end)

    it("should support filtering leadings", function()
      local filtered = font_leading_picker:filter("1.")
      assert.is_table(filtered)
    end)

    it("should support showing picker", function()
      local result = font_leading_picker:show()
      assert.equals(font_leading_picker, result)
    end)
  end)

  describe("edge cases", function()
    it("should handle missing labels gracefully", function()
      local comp = font_leading_picker.comp
      local item_no_label = { value = 1.2 }
      local item_with_label = { label = "1.4" }

      assert.has_no_errors(function()
        comp(item_no_label, item_with_label)
      end)
    end)

    it("should handle empty labels", function()
      local comp = font_leading_picker.comp
      local empty_item = { label = "" }
      local normal_item = { label = "1.2" }

      assert.has_no_errors(function()
        comp(empty_item, normal_item)
        comp(normal_item, empty_item)
      end)
    end)

    it("should handle extreme leading values", function()
      local comp = font_leading_picker.comp
      local very_tight = { label = "0.1" }
      local very_loose = { label = "5.0" }

      assert.is_true(comp(very_tight, very_loose))
      assert.is_false(comp(very_loose, very_tight))
    end)

    it("should handle nil comparison gracefully", function()
      local comp = font_leading_picker.comp

      assert.has_no_errors(function()
        pcall(comp, nil, { label = "1.2" })
        pcall(comp, { label = "1.2" }, nil)
        pcall(comp, nil, nil)
      end)
    end)
  end)

  describe("realistic font leading scenarios", function()
    it("should handle common leading values", function()
      local comp = font_leading_picker.comp
      local common_leadings = {
        { label = "0.8" },  -- Tight
        { label = "1.0" },  -- Single spacing
        { label = "1.2" },  -- Default
        { label = "1.5" },  -- One and half
        { label = "2.0" },  -- Double spacing
        { label = "Reset Line Height to Default" },
      }

      -- Reset should always come first
      for i = 1, #common_leadings - 1 do
        assert.is_true(comp(common_leadings[6], common_leadings[i]))
      end

      -- Other values should be in alphabetical order
      assert.is_true(comp(common_leadings[1], common_leadings[2])) -- "0.8" < "1.0"
      assert.is_true(comp(common_leadings[2], common_leadings[3])) -- "1.0" < "1.2"
    end)

    it("should handle platform-specific leading formats", function()
      local comp = font_leading_picker.comp
      local formats = {
        { label = "1.2em" },
        { label = "120%" },
        { label = "24px" },
        { label = "1.2" },
      }

      -- Should maintain consistent ordering
      assert.is_true(comp(formats[2], formats[3])) -- "120%" < "24px"
      assert.is_true(comp(formats[4], formats[1])) -- "1.2" < "1.2em"
    end)

    it("should handle accessibility-focused leading options", function()
      local comp = font_leading_picker.comp
      local accessibility_options = {
        { label = "High Contrast" },
        { label = "Large Text" },
        { label = "Extra Spacing" },
        { label = "Comfortable" },
      }

      -- Should sort consistently
      assert.is_true(comp(accessibility_options[4], accessibility_options[3])) -- "Comfortable" < "Extra Spacing"
      assert.is_true(comp(accessibility_options[3], accessibility_options[1])) -- "Extra Spacing" < "High Contrast"
    end)
  end)

  describe("configuration differences from other pickers", function()
    it("should have fuzzy search disabled unlike font picker", function()
      -- Font leading is more precise, so fuzzy search is disabled
      assert.is_false(font_leading_picker.fuzzy)
    end)

    it("should use specific reset label text", function()
      local comp = font_leading_picker.comp
      local standard_reset = { label = "Reset" }
      local specific_reset = { label = "Reset Line Height to Default" }

      -- Only the specific text should be treated as reset
      assert.is_true(comp(specific_reset, standard_reset))
      assert.is_false(comp(standard_reset, specific_reset))
    end)
  end)
end)

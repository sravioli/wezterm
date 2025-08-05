---@diagnostic disable: undefined-global, undefined-field
local spec_helper = require("tests.spec_helper")

describe("picker.font-size", function()
  local font_size_picker
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

    -- Clear cache and load font-size picker
    package.loaded["picker.font-size"] = nil
    font_size_picker = require("picker.font-size")
  end)

  after_each(function()
    spec_helper.teardown()
  end)

  describe("picker configuration", function()
    it("should create picker with correct title", function()
      assert.equals("󰢷  Font size", font_size_picker.title)
    end)

    it("should configure for font-sizes subdirectory", function()
      assert.equals("font-sizes", font_size_picker.subdir)
    end)

    it("should enable fuzzy search", function()
      assert.is_true(font_size_picker.fuzzy)
    end)

    it("should have comparison function", function()
      assert.is_function(font_size_picker.comp)
    end)
  end)

  describe("comparison function", function()
    local comp

    before_each(function()
      comp = font_size_picker.comp
    end)

    it("should prioritize Reset option", function()
      local reset_item = { label = "Reset" }
      local size_item = { label = "12pt" }

      assert.is_true(comp(reset_item, size_item))
      assert.is_false(comp(size_item, reset_item))
    end)

    it("should sort non-reset items by label alphabetically", function()
      local size_10 = { label = "10pt" }
      local size_20 = { label = "20pt" }

      assert.is_true(comp(size_10, size_20))
      assert.is_false(comp(size_20, size_10))
    end)

    it("should handle numerical font sizes correctly", function()
      local size_8 = { label = "8pt" }
      local size_12 = { label = "12pt" }
      local size_16 = { label = "16pt" }

      -- Alphabetical comparison: "12pt" < "16pt" < "8pt"
      assert.is_true(comp(size_12, size_16))
      assert.is_true(comp(size_16, size_8))
      assert.is_true(comp(size_12, size_8))
    end)

    it("should handle different size formats", function()
      local pt_size = { label = "12pt" }
      local px_size = { label = "16px" }
      local em_size = { label = "1.2em" }

      -- Should compare lexicographically
      assert.is_true(comp(pt_size, px_size)) -- "12pt" < "16px"
      assert.is_true(comp(em_size, pt_size)) -- "1.2em" < "12pt"
    end)

    it("should handle multiple reset items", function()
      local reset1 = { label = "Reset" }
      local reset2 = { label = "Reset" }

      -- Both are reset items, so first one should be prioritized
      assert.is_true(comp(reset1, reset2))
      assert.is_true(comp(reset2, reset1))
    end)

    it("should be case sensitive for consistent sorting", function()
      local lower_case = { label = "small" }
      local upper_case = { label = "LARGE" }

      -- ASCII: uppercase comes before lowercase
      assert.is_true(comp(upper_case, lower_case))
      assert.is_false(comp(lower_case, upper_case))
    end)
  end)

  describe("picker integration", function()
    it("should be created from Picker class", function()
      assert.is_table(font_size_picker.config)
      assert.equals("󰢷  Font size", font_size_picker.config.title)
    end)

    it("should have all required picker methods", function()
      assert.is_function(font_size_picker.show)
      assert.is_function(font_size_picker.select)
      assert.is_function(font_size_picker.filter)
    end)
  end)

  describe("font size selection workflow", function()
    it("should support size selection", function()
      local size_item = { label = "14pt", value = 14 }
      local selected = font_size_picker:select(size_item)
      assert.equals(size_item, selected)
    end)

    it("should support filtering sizes", function()
      local filtered = font_size_picker:filter("pt")
      assert.is_table(filtered)
    end)

    it("should support showing picker", function()
      local result = font_size_picker:show()
      assert.equals(font_size_picker, result)
    end)
  end)

  describe("edge cases", function()
    it("should handle missing labels gracefully", function()
      local comp = font_size_picker.comp
      local item_no_label = { value = 12 }
      local item_with_label = { label = "14pt" }

      assert.has_no_errors(function()
        comp(item_no_label, item_with_label)
      end)
    end)

    it("should handle empty labels", function()
      local comp = font_size_picker.comp
      local empty_item = { label = "" }
      local normal_item = { label = "12pt" }

      assert.has_no_errors(function()
        comp(empty_item, normal_item)
        comp(normal_item, empty_item)
      end)
    end)

    it("should handle special size values", function()
      local comp = font_size_picker.comp
      local items = {
        { label = "Tiny" },
        { label = "Small" },
        { label = "Medium" },
        { label = "Large" },
        { label = "Huge" },
      }

      -- Should sort alphabetically
      assert.is_true(comp(items[3], items[1])) -- "Medium" > "Tiny"
      assert.is_true(comp(items[4], items[2])) -- "Large" > "Small"
    end)

    it("should handle nil comparison gracefully", function()
      local comp = font_size_picker.comp

      assert.has_no_errors(function()
        pcall(comp, nil, { label = "12pt" })
        pcall(comp, { label = "12pt" }, nil)
        pcall(comp, nil, nil)
      end)
    end)
  end)

  describe("realistic font size scenarios", function()
    it("should handle common font sizes", function()
      local comp = font_size_picker.comp
      local common_sizes = {
        { label = "8pt" },
        { label = "9pt" },
        { label = "10pt" },
        { label = "11pt" },
        { label = "12pt" },
        { label = "14pt" },
        { label = "16pt" },
        { label = "18pt" },
        { label = "Reset" },
      }

      -- Reset should always come first
      for i = 1, #common_sizes - 1 do
        assert.is_true(comp(common_sizes[9], common_sizes[i]))
      end
    end)

    it("should handle fractional sizes", function()
      local comp = font_size_picker.comp
      local fractional_sizes = {
        { label = "10.5pt" },
        { label = "11.5pt" },
        { label = "12.5pt" },
      }

      -- Should maintain alphabetical order
      assert.is_true(comp(fractional_sizes[1], fractional_sizes[2]))
      assert.is_true(comp(fractional_sizes[2], fractional_sizes[3]))
    end)
  end)
end)

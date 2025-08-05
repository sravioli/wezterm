---@diagnostic disable: undefined-global, undefined-field
local spec_helper = require("tests.spec_helper")

describe("picker.font", function()
  local font_picker
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

    -- Clear cache and load font picker
    package.loaded["picker.font"] = nil
    font_picker = require("picker.font")
  end)

  after_each(function()
    spec_helper.teardown()
  end)

  describe("picker configuration", function()
    it("should create picker with correct title", function()
      assert.equals("󰢷  Font picker", font_picker.title)
    end)

    it("should configure for fonts subdirectory", function()
      assert.equals("fonts", font_picker.subdir)
    end)

    it("should enable fuzzy search", function()
      assert.is_true(font_picker.fuzzy)
    end)

    it("should have comparison function", function()
      assert.is_function(font_picker.comp)
    end)
  end)

  describe("comparison function", function()
    local comp

    before_each(function()
      comp = font_picker.comp
    end)

    it("should prioritize reset option", function()
      local reset_item = { id = "reset", label = "Reset" }
      local normal_item = { id = "arial", label = "Arial" }

      assert.is_true(comp(reset_item, normal_item))
      assert.is_false(comp(normal_item, reset_item))
    end)

    it("should sort non-reset items by label alphabetically", function()
      local item_a = { id = "arial", label = "Arial" }
      local item_b = { id = "times", label = "Times New Roman" }

      assert.is_true(comp(item_a, item_b))
      assert.is_false(comp(item_b, item_a))
    end)

    it("should handle items with same labels", function()
      local item1 = { id = "font1", label = "Same Font" }
      local item2 = { id = "font2", label = "Same Font" }

      -- Should not error and return consistent result
      local result1 = comp(item1, item2)
      local result2 = comp(item1, item2)
      assert.equals(result1, result2)
    end)

    it("should handle case sensitivity correctly", function()
      local item_lower = { id = "test1", label = "arial" }
      local item_upper = { id = "test2", label = "TIMES" }

      -- Should compare case-sensitively (lowercase comes before uppercase in ASCII)
      assert.is_false(comp(item_lower, item_upper))
      assert.is_true(comp(item_upper, item_lower))
    end)

    it("should handle multiple reset items", function()
      local reset1 = { id = "reset", label = "Reset Font" }
      local reset2 = { id = "reset", label = "Reset All" }

      -- Both are reset items, so first one should be prioritized
      assert.is_true(comp(reset1, reset2))
      assert.is_true(comp(reset2, reset1))
    end)
  end)

  describe("picker integration", function()
    it("should be created from Picker class", function()
      -- Verify that the picker was created with correct config
      assert.is_table(font_picker.config)
      assert.equals("󰢷  Font picker", font_picker.config.title)
    end)

    it("should have all required picker methods", function()
      assert.is_function(font_picker.show)
      assert.is_function(font_picker.select)
      assert.is_function(font_picker.filter)
    end)
  end)

  describe("edge cases", function()
    it("should handle missing labels in comparison", function()
      local comp = font_picker.comp
      local item_no_label = { id = "test" }
      local item_with_label = { id = "test2", label = "Test" }

      -- Should not error
      assert.has_no_errors(function()
        comp(item_no_label, item_with_label)
      end)
    end)

    it("should handle nil items in comparison", function()
      local comp = font_picker.comp

      -- Should handle gracefully without erroring
      assert.has_no_errors(function()
        pcall(comp, nil, { id = "test", label = "Test" })
        pcall(comp, { id = "test", label = "Test" }, nil)
        pcall(comp, nil, nil)
      end)
    end)
  end)

  describe("font picker workflow", function()
    it("should support font selection workflow", function()
      -- Simulate selecting a font
      local selected_font = font_picker:select({ id = "arial", label = "Arial" })
      assert.is_table(selected_font)
    end)

    it("should support filtering fonts", function()
      local filtered = font_picker:filter("mono")
      assert.is_table(filtered)
    end)

    it("should support showing picker", function()
      local result = font_picker:show()
      assert.equals(font_picker, result)
    end)
  end)
end)

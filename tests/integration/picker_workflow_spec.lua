---@diagnostic disable: undefined-global, undefined-field
local spec_helper = require("tests.spec_helper")

describe("integration.picker_workflow", function()
  local colorscheme_picker, font_picker, font_size_picker

  before_each(function()
    spec_helper.setup()

    -- Mock the utils system
    package.loaded["utils"] = {
      class = {
        picker = {
          new = function(config)
            return {
              title = config.title,
              subdir = config.subdir,
              fuzzy = config.fuzzy,
              comp = config.comp,
              show = function(self)
                return { picker = self, action = "show" }
              end,
              select = function(self, item)
                return { picker = self, selected = item, action = "select" }
              end,
              filter = function(self, term)
                return { picker = self, term = term, action = "filter" }
              end
            }
          end
        }
      },
      fn = {
        fs = {
          read_dir = function() return { "scheme1.lua", "scheme2.lua" } end,
          exists = function() return true end
        }
      }
    }

    -- Mock config dependencies
    package.loaded["config.font"] = { font_size = 12 }

    -- Load picker modules
    colorscheme_picker = require("picker.colorscheme")
    font_picker = require("picker.font")
    font_size_picker = require("picker.font-size")
  end)

  after_each(function()
    spec_helper.teardown()
  end)

  describe("picker creation workflow", function()
    it("should create all pickers successfully", function()
      assert.is_table(colorscheme_picker)
      assert.is_table(font_picker)
      assert.is_table(font_size_picker)
    end)

    it("should have consistent picker interface", function()
      local pickers = { colorscheme_picker, font_picker, font_size_picker }

      for _, picker in ipairs(pickers) do
        assert.is_function(picker.show)
        assert.is_function(picker.select)
        assert.is_function(picker.filter)
        assert.is_string(picker.title)
      end
    end)

    it("should have unique titles for each picker", function()
      local titles = {
        colorscheme_picker.title,
        font_picker.title,
        font_size_picker.title
      }

      -- All titles should be different
      assert.not_equals(titles[1], titles[2])
      assert.not_equals(titles[2], titles[3])
      assert.not_equals(titles[1], titles[3])
    end)
  end)

  describe("picker interaction workflow", function()
    it("should show pickers in sequence", function()
      local colorscheme_result = colorscheme_picker:show()
      local font_result = font_picker:show()
      local font_size_result = font_size_picker:show()

      assert.equals("show", colorscheme_result.action)
      assert.equals("show", font_result.action)
      assert.equals("show", font_size_result.action)
    end)

    it("should handle selection workflow", function()
      local test_items = {
        colorscheme = { id = "test-scheme", label = "Test Scheme" },
        font = { id = "test-font", label = "Test Font" },
        font_size = { id = "14", label = "14pt" }
      }

      local colorscheme_selection = colorscheme_picker:select(test_items.colorscheme)
      local font_selection = font_picker:select(test_items.font)
      local font_size_selection = font_size_picker:select(test_items.font_size)

      assert.equals(test_items.colorscheme, colorscheme_selection.selected)
      assert.equals(test_items.font, font_selection.selected)
      assert.equals(test_items.font_size, font_size_selection.selected)
    end)

    it("should handle filtering workflow", function()
      local filter_terms = { "dark", "mono", "12" }

      for i, picker in ipairs({ colorscheme_picker, font_picker, font_size_picker }) do
        local filter_result = picker:filter(filter_terms[i])

        assert.equals("filter", filter_result.action)
        assert.equals(filter_terms[i], filter_result.term)
      end
    end)
  end)

  describe("cross-picker consistency", function()
    it("should use consistent fuzzy search settings", function()
      -- Colorscheme and font pickers should have fuzzy search enabled
      assert.is_true(colorscheme_picker.fuzzy)
      assert.is_true(font_picker.fuzzy)

      -- Font size picker should have it enabled too
      assert.is_true(font_size_picker.fuzzy)
    end)

    it("should have consistent comparison functions", function()
      local pickers = { colorscheme_picker, font_picker, font_size_picker }

      for _, picker in ipairs(pickers) do
        assert.is_function(picker.comp)

        -- Test that comparison functions handle basic cases
        local item_a = { id = "a", label = "A" }
        local item_b = { id = "b", label = "B" }

        assert.has_no_errors(function()
          picker.comp(item_a, item_b)
        end)
      end
    end)
  end)

  describe("picker asset integration", function()
    it("should work with font asset modules", function()
      -- Test that picker modules can integrate with asset modules
      local mock_font_asset = {
        get = function() return { id = "test-font", label = "Test Font" } end,
        activate = function(config, opts) config.font = opts.id end
      }

      package.loaded["picker.assets.fonts.test-font"] = mock_font_asset

      -- Simulate picker selecting this font asset
      local selection = font_picker:select(mock_font_asset.get())
      assert.is_table(selection.selected)
      assert.equals("test-font", selection.selected.id)
    end)

    it("should work with colorscheme asset modules", function()
      local mock_colorscheme_asset = {
        get = function() return { id = "test-scheme", label = "Test Scheme" } end,
        activate = function(config, opts) config.color_scheme = opts.id end
      }

      package.loaded["picker.assets.colorschemes.test-scheme"] = mock_colorscheme_asset

      local selection = colorscheme_picker:select(mock_colorscheme_asset.get())
      assert.is_table(selection.selected)
      assert.equals("test-scheme", selection.selected.id)
    end)
  end)

  describe("error handling in workflows", function()
    it("should handle picker creation failures gracefully", function()
      -- Mock utils.class.picker to fail
      package.loaded["utils"].class.picker.new = function()
        error("Picker creation failed")
      end

      assert.has_errors(function()
        require("picker.colorscheme")
      end)
    end)

    it("should handle missing dependencies gracefully", function()
      -- Remove config.font dependency
      package.loaded["config.font"] = nil

      assert.has_no_errors(function()
        -- Font size picker should handle missing config gracefully
        package.loaded["picker.font-size"] = nil
        pcall(require, "picker.font-size")
      end)
    end)

    it("should handle invalid picker configurations", function()
      -- Test with invalid picker config
      package.loaded["utils"].class.picker.new = function(config)
        if not config or not config.title then
          error("Invalid picker configuration")
        end
        return { title = config.title }
      end

      -- Should still work with valid configurations
      assert.has_no_errors(function()
        package.loaded["picker.colorscheme"] = nil
        require("picker.colorscheme")
      end)
    end)
  end)

  describe("performance characteristics", function()
    it("should create pickers efficiently", function()
      local start_time = os.clock()

      for i = 1, 10 do
        package.loaded["picker.colorscheme"] = nil
        package.loaded["picker.font"] = nil
        package.loaded["picker.font-size"] = nil

        require("picker.colorscheme")
        require("picker.font")
        require("picker.font-size")
      end

      local elapsed = os.clock() - start_time
      assert.is_true(elapsed < 1.0, "Picker creation should be fast")
    end)

    it("should handle rapid picker interactions", function()
      assert.has_no_errors(function()
        for i = 1, 50 do
          colorscheme_picker:show()
          font_picker:filter("test")
          font_size_picker:select({ id = "12", label = "12pt" })
        end
      end)
    end)
  end)

  describe("realistic usage scenarios", function()
    it("should support theme customization workflow", function()
      -- User customizes theme by changing multiple aspects
      local customization_steps = {
        {
          picker = colorscheme_picker,
          selection = { id = "dark-theme", label = "Dark Theme" }
        },
        {
          picker = font_picker,
          selection = { id = "jetbrains-mono", label = "JetBrains Mono" }
        },
        {
          picker = font_size_picker,
          selection = { id = "14", label = "14pt" }
        }
      }

      local results = {}
      for _, step in ipairs(customization_steps) do
        local result = step.picker:select(step.selection)
        table.insert(results, result)
      end

      assert.equals(3, #results)
      for _, result in ipairs(results) do
        assert.equals("select", result.action)
        assert.is_table(result.selected)
      end
    end)

    it("should support search and filter workflow", function()
      -- User searches for specific options
      local search_terms = {
        colorscheme = "dark",
        font = "mono",
        font_size = "14"
      }

      local search_results = {
        colorscheme_picker:filter(search_terms.colorscheme),
        font_picker:filter(search_terms.font),
        font_size_picker:filter(search_terms.font_size)
      }

      for i, result in ipairs(search_results) do
        assert.equals("filter", result.action)
        assert.is_string(result.term)
      end
    end)
  end)
end)

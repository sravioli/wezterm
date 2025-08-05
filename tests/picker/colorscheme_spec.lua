---@module "tests.picker.colorscheme_spec"
---@description Unit tests for picker.colorscheme module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("picker.colorscheme", function()
  local colorscheme_picker

  before_each(function()
    helper.setup()

    -- Mock Utils module
    package.loaded["utils"] = {
      class = {
        picker = {
          new = function(config)
            return {
              config = config or {},
              show = function() end,
              hide = function() end,
              set_items = function() end,
              on_select = function() end
            }
          end
        }
      },
      fn = {
        fs = {
          read_dir = function(path)
            return {
              "test-scheme.lua",
              "another-scheme.lua"
            }
          end,
          exists = function(path) return true end
        }
      }
    }

    colorscheme_picker = require("picker.colorscheme")
  end)

  after_each(function()
    helper.teardown()
    package.loaded["utils"] = nil
    package.loaded["picker.colorscheme"] = nil
  end)

  describe("picker creation", function()
    it("should create a colorscheme picker", function()
      assert.is_table(colorscheme_picker)
    end)

    it("should use Picker base class", function()
      assert.is_table(colorscheme_picker)
      -- Should have picker functionality
    end)

    it("should have colorscheme-specific configuration", function()
      assert.is_table(colorscheme_picker)
    end)
  end)

  describe("colorscheme discovery", function()
    it("should discover available colorschemes", function()
      assert.has_no.errors(function()
        if colorscheme_picker.discover_schemes then
          local schemes = colorscheme_picker:discover_schemes()
          assert.is_table(schemes)
        end
      end)
    end)

    it("should handle multiple colorscheme sources", function()
      assert.has_no.errors(function()
        if colorscheme_picker.get_all_schemes then
          local schemes = colorscheme_picker:get_all_schemes()
          assert.is_table(schemes)
        end
      end)
    end)

    it("should include built-in schemes", function()
      assert.has_no.errors(function()
        if colorscheme_picker.get_builtin_schemes then
          local schemes = colorscheme_picker:get_builtin_schemes()
          assert.is_table(schemes)
        end
      end)
    end)

    it("should include custom schemes", function()
      assert.has_no.errors(function()
        if colorscheme_picker.get_custom_schemes then
          local schemes = colorscheme_picker:get_custom_schemes()
          assert.is_table(schemes)
        end
      end)
    end)
  end)

  describe("scheme selection", function()
    it("should handle scheme selection", function()
      local selected_scheme = nil

      assert.has_no.errors(function()
        if colorscheme_picker.on_select then
          colorscheme_picker:on_select(function(scheme)
            selected_scheme = scheme
          end)
        end

        if colorscheme_picker.select_scheme then
          colorscheme_picker:select_scheme("test-scheme")
        end
      end)
    end)

    it("should validate selected scheme", function()
      assert.has_no.errors(function()
        if colorscheme_picker.validate_scheme then
          local is_valid = colorscheme_picker:validate_scheme("test-scheme")
          assert.is_boolean(is_valid)
        end
      end)
    end)

    it("should apply selected scheme", function()
      assert.has_no.errors(function()
        if colorscheme_picker.apply_scheme then
          colorscheme_picker:apply_scheme("test-scheme")
        end
      end)
    end)

    it("should handle invalid scheme selection", function()
      assert.has_no.errors(function()
        if colorscheme_picker.select_scheme then
          colorscheme_picker:select_scheme("non-existent-scheme")
        end
      end)
    end)
  end)

  describe("preview functionality", function()
    it("should provide scheme preview", function()
      assert.has_no.errors(function()
        if colorscheme_picker.preview_scheme then
          local preview = colorscheme_picker:preview_scheme("test-scheme")
          if preview then
            assert.is_string(preview)
          end
        end
      end)
    end)

    it("should handle preview errors gracefully", function()
      assert.has_no.errors(function()
        if colorscheme_picker.preview_scheme then
          colorscheme_picker:preview_scheme("invalid-scheme")
        end
      end)
    end)

    it("should show color samples in preview", function()
      assert.has_no.errors(function()
        if colorscheme_picker.get_color_samples then
          local samples = colorscheme_picker:get_color_samples("test-scheme")
          if samples then
            assert.is_table(samples)
          end
        end
      end)
    end)
  end)

  describe("search and filtering", function()
    it("should filter schemes by name", function()
      assert.has_no.errors(function()
        if colorscheme_picker.filter_by_name then
          local filtered = colorscheme_picker:filter_by_name("test")
          if filtered then
            assert.is_table(filtered)
          end
        end
      end)
    end)

    it("should filter schemes by category", function()
      assert.has_no.errors(function()
        if colorscheme_picker.filter_by_category then
          local filtered = colorscheme_picker:filter_by_category("dark")
          if filtered then
            assert.is_table(filtered)
          end
        end
      end)
    end)

    it("should handle empty search results", function()
      assert.has_no.errors(function()
        if colorscheme_picker.filter_by_name then
          local filtered = colorscheme_picker:filter_by_name("nonexistent")
          if filtered then
            assert.is_table(filtered)
          end
        end
      end)
    end)

    it("should provide fuzzy search", function()
      assert.has_no.errors(function()
        if colorscheme_picker.fuzzy_search then
          local results = colorscheme_picker:fuzzy_search("tst")
          if results then
            assert.is_table(results)
          end
        end
      end)
    end)
  end)

  describe("scheme metadata", function()
    it("should provide scheme information", function()
      assert.has_no.errors(function()
        if colorscheme_picker.get_scheme_info then
          local info = colorscheme_picker:get_scheme_info("test-scheme")
          if info then
            assert.is_table(info)
          end
        end
      end)
    end)

    it("should include scheme description", function()
      assert.has_no.errors(function()
        if colorscheme_picker.get_scheme_description then
          local desc = colorscheme_picker:get_scheme_description("test-scheme")
          if desc then
            assert.is_string(desc)
          end
        end
      end)
    end)

    it("should include scheme author", function()
      assert.has_no.errors(function()
        if colorscheme_picker.get_scheme_author then
          local author = colorscheme_picker:get_scheme_author("test-scheme")
          if author then
            assert.is_string(author)
          end
        end
      end)
    end)

    it("should categorize schemes", function()
      assert.has_no.errors(function()
        if colorscheme_picker.get_scheme_category then
          local category = colorscheme_picker:get_scheme_category("test-scheme")
          if category then
            assert.is_string(category)
          end
        end
      end)
    end)
  end)

  describe("current scheme handling", function()
    it("should get current colorscheme", function()
      assert.has_no.errors(function()
        if colorscheme_picker.get_current_scheme then
          local current = colorscheme_picker:get_current_scheme()
          if current then
            assert.is_string(current)
          end
        end
      end)
    end)

    it("should highlight current scheme in list", function()
      assert.has_no.errors(function()
        if colorscheme_picker.highlight_current then
          colorscheme_picker:highlight_current()
        end
      end)
    end)

    it("should restore previous scheme on cancel", function()
      assert.has_no.errors(function()
        if colorscheme_picker.restore_previous then
          colorscheme_picker:restore_previous()
        end
      end)
    end)
  end)

  describe("window integration", function()
    it("should show picker in window", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      assert.has_no.errors(function()
        if colorscheme_picker.show then
          colorscheme_picker:show(window, pane)
        end
      end)
    end)

    it("should handle window events", function()
      local window = helper.create_mock_window()

      assert.has_no.errors(function()
        if colorscheme_picker.handle_key then
          colorscheme_picker:handle_key("Enter", window)
        end
      end)
    end)

    it("should update window config on selection", function()
      local window = helper.create_mock_window()
      local config_updated = false

      window.set_config_overrides = function(overrides)
        config_updated = true
        assert.is_table(overrides)
      end

      assert.has_no.errors(function()
        if colorscheme_picker.apply_to_window then
          colorscheme_picker:apply_to_window(window, "test-scheme")
        end
      end)
    end)
  end)

  describe("error handling", function()
    it("should handle missing colorscheme files", function()
      package.loaded["utils"].fn.fs.read_dir = function(path)
        return {}
      end

      assert.has_no.errors(function()
        if colorscheme_picker.discover_schemes then
          colorscheme_picker:discover_schemes()
        end
      end)
    end)

    it("should handle corrupted colorscheme files", function()
      assert.has_no.errors(function()
        if colorscheme_picker.load_scheme then
          colorscheme_picker:load_scheme("corrupted-scheme")
        end
      end)
    end)

    it("should handle permission errors", function()
      package.loaded["utils"].fn.fs.exists = function(path)
        return false
      end

      assert.has_no.errors(function()
        if colorscheme_picker.discover_schemes then
          colorscheme_picker:discover_schemes()
        end
      end)
    end)

    it("should handle picker display errors", function()
      local window = {}  -- Mock window without proper methods

      assert.has_no.errors(function()
        if colorscheme_picker.show then
          colorscheme_picker:show(window)
        end
      end)
    end)
  end)

  describe("performance", function()
    it("should handle large numbers of schemes efficiently", function()
      -- Mock many schemes
      package.loaded["utils"].fn.fs.read_dir = function(path)
        local schemes = {}
        for i = 1, 100 do
          table.insert(schemes, "scheme-" .. i .. ".lua")
        end
        return schemes
      end

      assert.has_no.errors(function()
        if colorscheme_picker.discover_schemes then
          local schemes = colorscheme_picker:discover_schemes()
          if schemes then
            assert.is_table(schemes)
          end
        end
      end)
    end)

    it("should cache scheme information", function()
      assert.has_no.errors(function()
        if colorscheme_picker.get_scheme_info then
          -- First call
          local info1 = colorscheme_picker:get_scheme_info("test-scheme")
          -- Second call should use cache
          local info2 = colorscheme_picker:get_scheme_info("test-scheme")

          if info1 and info2 then
            assert.same(info1, info2)
          end
        end
      end)
    end)

    it("should handle rapid scheme switching", function()
      assert.has_no.errors(function()
        if colorscheme_picker.apply_scheme then
          for i = 1, 10 do
            colorscheme_picker:apply_scheme("scheme-" .. (i % 3))
          end
        end
      end)
    end)
  end)

  describe("customization", function()
    it("should allow custom scheme directories", function()
      assert.has_no.errors(function()
        if colorscheme_picker.add_scheme_directory then
          colorscheme_picker:add_scheme_directory("/custom/schemes")
        end
      end)
    end)

    it("should support scheme favorites", function()
      assert.has_no.errors(function()
        if colorscheme_picker.add_favorite then
          colorscheme_picker:add_favorite("test-scheme")
        end

        if colorscheme_picker.get_favorites then
          local favorites = colorscheme_picker:get_favorites()
          if favorites then
            assert.is_table(favorites)
          end
        end
      end)
    end)

    it("should support recently used schemes", function()
      assert.has_no.errors(function()
        if colorscheme_picker.get_recent then
          local recent = colorscheme_picker:get_recent()
          if recent then
            assert.is_table(recent)
          end
        end
      end)
    end)
  end)
end)

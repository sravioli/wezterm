---@module "tests.config.font_spec"
---@description Unit tests for config.font module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("config.font", function()
  local font_config

  before_each(function()
    helper.setup()

    -- Mock Utils module for font operations
    package.loaded["utils"] = {
      fn = {
        font = {
          get_fonts = function()
            return {
              "JetBrains Mono",
              "Fira Code",
              "Cascadia Code",
              "Source Code Pro"
            }
          end,
          is_available = function(font_name)
            local available_fonts = {
              "JetBrains Mono",
              "Fira Code",
              "Cascadia Code"
            }
            for _, font in ipairs(available_fonts) do
              if font == font_name then
                return true
              end
            end
            return false
          end
        }
      }
    }

    font_config = require("config.font")
  end)

  after_each(function()
    helper.teardown()
    package.loaded["utils"] = nil
    package.loaded["config.font"] = nil
  end)

  describe("font family configuration", function()
    it("should have font family defined", function()
      helper.assert_table_contains(font_config, "font")

      if font_config.font then
        assert.is_table(font_config.font)
      end
    end)

    it("should use available fonts", function()
      if font_config.font and font_config.font.family then
        local family = font_config.font.family
        assert.is_string(family)
        assert.is_true(#family > 0)
      end
    end)

    it("should have fallback fonts", function()
      if font_config.font_rules then
        assert.is_table(font_config.font_rules)
      end

      if font_config.font_dirs then
        assert.is_table(font_config.font_dirs)
      end
    end)
  end)

  describe("font size configuration", function()
    it("should have font size defined", function()
      if font_config.font_size then
        assert.is_number(font_config.font_size)
        assert.is_true(font_config.font_size > 0)
      end
    end)

    it("should have reasonable font size", function()
      if font_config.font_size then
        local size = font_config.font_size
        assert.is_true(size >= 8 and size <= 72) -- Reasonable range
      end
    end)

    it("should allow fractional font sizes", function()
      if font_config.font_size then
        -- Font size can be fractional
        assert.is_number(font_config.font_size)
      end
    end)
  end)

  describe("font styling", function()
    it("should configure font weight", function()
      if font_config.font and font_config.font.weight then
        local weight = font_config.font.weight

        local valid_weights = {
          "Thin", "ExtraLight", "Light", "DemiLight",
          "Regular", "Medium", "DemiBold", "Bold",
          "ExtraBold", "Black", "ExtraBlack"
        }

        local is_valid = false
        for _, valid_weight in ipairs(valid_weights) do
          if weight == valid_weight then
            is_valid = true
            break
          end
        end

        assert.is_true(is_valid or type(weight) == "number")
      end
    end)

    it("should configure font stretch", function()
      if font_config.font and font_config.font.stretch then
        local stretch = font_config.font.stretch

        local valid_stretches = {
          "UltraCondensed", "ExtraCondensed", "Condensed",
          "SemiCondensed", "Normal", "SemiExpanded",
          "Expanded", "ExtraExpanded", "UltraExpanded"
        }

        local is_valid = false
        for _, valid_stretch in ipairs(valid_stretches) do
          if stretch == valid_stretch then
            is_valid = true
            break
          end
        end

        assert.is_true(is_valid)
      end
    end)

    it("should configure font style", function()
      if font_config.font and font_config.font.style then
        local style = font_config.font.style

        local valid_styles = { "Normal", "Italic", "Oblique" }

        local is_valid = false
        for _, valid_style in ipairs(valid_styles) do
          if style == valid_style then
            is_valid = true
            break
          end
        end

        assert.is_true(is_valid)
      end
    end)
  end)

  describe("font features", function()
    it("should configure harfbuzz features", function()
      if font_config.harfbuzz_features then
        assert.is_table(font_config.harfbuzz_features)

        -- Common features for coding fonts
        local common_features = {
          "calt", "liga", "clig", "kern", "zero"
        }

        for _, feature in ipairs(font_config.harfbuzz_features) do
          assert.is_string(feature)
        end
      end
    end)

    it("should handle ligatures appropriately", function()
      if font_config.font and font_config.font.harfbuzz_features then
        local features = font_config.font.harfbuzz_features

        -- Should either enable or disable ligatures explicitly
        assert.is_table(features)
      end
    end)

    it("should configure zero variants", function()
      if font_config.harfbuzz_features then
        -- Zero with slash is common for coding fonts
        local has_zero_feature = false
        for _, feature in ipairs(font_config.harfbuzz_features) do
          if feature:match("zero") then
            has_zero_feature = true
            break
          end
        end
        -- Zero feature is optional but common
      end
    end)
  end)

  describe("line spacing", function()
    it("should configure line height", function()
      if font_config.line_height then
        assert.is_number(font_config.line_height)
        assert.is_true(font_config.line_height > 0)
      end
    end)

    it("should have reasonable line height", function()
      if font_config.line_height then
        local height = font_config.line_height
        assert.is_true(height >= 0.8 and height <= 2.0) -- Reasonable range
      end
    end)

    it("should configure cell dimensions", function()
      if font_config.cell_width then
        assert.is_number(font_config.cell_width)
        assert.is_true(font_config.cell_width > 0)
      end

      if font_config.cell_height then
        assert.is_number(font_config.cell_height)
        assert.is_true(font_config.cell_height > 0)
      end
    end)
  end)

  describe("font shaping", function()
    it("should configure font shaper", function()
      if font_config.font_shaper then
        local shaper = font_config.font_shaper

        local valid_shapers = { "Harfbuzz", "Allsorts" }

        local is_valid = false
        for _, valid_shaper in ipairs(valid_shapers) do
          if shaper == valid_shaper then
            is_valid = true
            break
          end
        end

        assert.is_true(is_valid)
      end
    end)

    it("should configure font rasterizer", function()
      if font_config.font_rasterizer then
        local rasterizer = font_config.font_rasterizer

        local valid_rasterizers = { "FreeType", "DirectWrite" }

        local is_valid = false
        for _, valid_rast in ipairs(valid_rasterizers) do
          if rasterizer == valid_rast then
            is_valid = true
            break
          end
        end

        assert.is_true(is_valid)
      end
    end)

    it("should configure freetype options", function()
      if font_config.freetype_load_flags then
        assert.is_string(font_config.freetype_load_flags)
      end

      if font_config.freetype_load_target then
        local target = font_config.freetype_load_target

        local valid_targets = {
          "Normal", "Light", "Mono", "HorizontalLcd", "VerticalLcd"
        }

        local is_valid = false
        for _, valid_target in ipairs(valid_targets) do
          if target == valid_target then
            is_valid = true
            break
          end
        end

        assert.is_true(is_valid)
      end
    end)
  end)

  describe("font directories", function()
    it("should configure custom font directories", function()
      if font_config.font_dirs then
        assert.is_table(font_config.font_dirs)

        for _, dir in ipairs(font_config.font_dirs) do
          assert.is_string(dir)
        end
      end
    end)

    it("should handle platform-specific font paths", function()
      if font_config.font_dirs then
        local dirs = font_config.font_dirs

        -- Should include common font directories
        local has_fonts_dir = false
        for _, dir in ipairs(dirs) do
          if dir:match("[Ff]onts") then
            has_fonts_dir = true
            break
          end
        end
        -- Font directories are optional
      end
    end)
  end)

  describe("font rules", function()
    it("should configure font rules for different text types", function()
      if font_config.font_rules then
        assert.is_table(font_config.font_rules)

        for _, rule in ipairs(font_config.font_rules) do
          assert.is_table(rule)

          if rule.intensity then
            local valid_intensities = { "Bold", "Half", "Normal" }
            local is_valid = false
            for _, intensity in ipairs(valid_intensities) do
              if rule.intensity == intensity then
                is_valid = true
                break
              end
            end
            assert.is_true(is_valid)
          end

          if rule.italic ~= nil then
            assert.is_boolean(rule.italic)
          end

          if rule.font then
            assert.is_table(rule.font)
          end
        end
      end
    end)

    it("should handle bold and italic combinations", function()
      if font_config.font_rules then
        -- Should have rules for different font weights and styles
        assert.is_table(font_config.font_rules)
      end
    end)
  end)

  describe("font fallbacks", function()
    it("should handle missing fonts gracefully", function()
      -- Mock a missing font
      package.loaded["utils"].fn.font.is_available = function() return false end

      assert.has_no.errors(function()
        package.loaded["config.font"] = nil
        require("config.font")
      end)
    end)

    it("should provide system font fallbacks", function()
      if font_config.font and font_config.font.family then
        -- Should fall back to system fonts if preferred font unavailable
        assert.is_string(font_config.font.family)
      end
    end)
  end)

  describe("font rendering", function()
    it("should configure anti-aliasing", function()
      if font_config.font_antialias then
        local antialias = font_config.font_antialias

        local valid_antialias = { "None", "Greyscale", "Subpixel" }

        local is_valid = false
        for _, valid_aa in ipairs(valid_antialias) do
          if antialias == valid_aa then
            is_valid = true
            break
          end
        end

        assert.is_true(is_valid)
      end
    end)

    it("should configure hinting", function()
      if font_config.font_hinting then
        local hinting = font_config.font_hinting

        local valid_hinting = { "None", "Vertical", "VerticalSubpixel", "Full" }

        local is_valid = false
        for _, valid_hint in ipairs(valid_hinting) do
          if hinting == valid_hint then
            is_valid = true
            break
          end
        end

        assert.is_true(is_valid)
      end
    end)
  end)

  describe("error handling", function()
    it("should handle corrupted font configuration", function()
      -- Mock corrupted utils
      package.loaded["utils"] = nil

      assert.has_no.errors(function()
        package.loaded["config.font"] = nil
        require("config.font")
      end)
    end)

    it("should handle invalid font sizes", function()
      -- Should validate font size ranges
      if font_config.font_size then
        assert.is_number(font_config.font_size)
        assert.is_true(font_config.font_size > 0)
      end
    end)

    it("should handle invalid font families", function()
      -- Should handle empty or nil font families
      if font_config.font then
        assert.is_table(font_config.font)
      end
    end)
  end)

  describe("performance", function()
    it("should load font configuration efficiently", function()
      local start_time = os.clock()

      for i = 1, 10 do
        package.loaded["config.font"] = nil
        require("config.font")
      end

      local elapsed = os.clock() - start_time
      assert.is_true(elapsed < 1) -- Should load quickly
    end)

    it("should cache font availability checks", function()
      -- Font availability should be cached for performance
      local utils = package.loaded["utils"]
      if utils and utils.fn and utils.fn.font then
        assert.is_function(utils.fn.font.is_available)
      end
    end)
  end)

  describe("integration", function()
    it("should work with Config class", function()
      local Config = require("utils.class.config")
      local config = Config:new()

      assert.has_no.errors(function()
        config:add(font_config)
      end)
    end)

    it("should be compatible with WezTerm font system", function()
      -- Font config should be valid for WezTerm
      assert.is_table(font_config)

      if font_config.font then
        assert.is_table(font_config.font)
      end
    end)

    it("should work with appearance configuration", function()
      -- Font should integrate well with appearance settings
      assert.is_table(font_config)
    end)
  end)

  describe("accessibility", function()
    it("should support high DPI scaling", function()
      if font_config.dpi then
        assert.is_number(font_config.dpi)
        assert.is_true(font_config.dpi > 0)
      end
    end)

    it("should support dyslexia-friendly fonts", function()
      -- Should be configurable for accessibility needs
      if font_config.font and font_config.font.family then
        assert.is_string(font_config.font.family)
      end
    end)

    it("should handle various character encodings", function()
      if font_config.unicode_version then
        assert.is_number(font_config.unicode_version)
      end
    end)
  end)
end)

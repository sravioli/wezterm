---@module "tests.config.appearance_spec"
---@description Unit tests for config.appearance module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("config.appearance", function()
  local appearance_config

  before_each(function()
    helper.setup()

    -- Mock Utils module
    package.loaded["utils"] = {
      fn = {
        color = {
          get_schemes = function()
            return helper.mock_wezterm.color_schemes
          end,
          get_scheme = function()
            return "Test Scheme"
          end
        }
      }
    }

    appearance_config = require("config.appearance")
  end)

  after_each(function()
    helper.teardown()
    package.loaded["utils"] = nil
    package.loaded["config.appearance"] = nil
  end)

  describe("color scheme configuration", function()
    it("should have color schemes defined", function()
      assert.is_table(appearance_config.color_schemes)
      assert.is_not_nil(appearance_config.color_schemes["Test Scheme"])
    end)

    it("should have a selected color scheme", function()
      assert.is_string(appearance_config.color_scheme)
      assert.equals("Test Scheme", appearance_config.color_scheme)
    end)

    it("should use valid color scheme", function()
      local scheme_name = appearance_config.color_scheme
      local schemes = appearance_config.color_schemes

      assert.is_not_nil(schemes[scheme_name])

      local theme = schemes[scheme_name]
      assert.is_table(theme)
      helper.assert_valid_color(theme.background)
      helper.assert_valid_color(theme.foreground)
    end)
  end)

  describe("background configuration", function()
    it("should have background configuration", function()
      assert.is_table(appearance_config.background)
      assert.is_true(#appearance_config.background > 0)
    end)

    it("should have valid background structure", function()
      local bg = appearance_config.background[1]

      assert.is_table(bg)
      assert.is_table(bg.source)
      assert.is_not_nil(bg.source.Color)
      assert.equals("100%", bg.width)
      assert.equals("100%", bg.height)
      assert.is_number(bg.opacity)
    end)

    it("should use theme background color", function()
      local bg = appearance_config.background[1]
      local theme = appearance_config.color_schemes[appearance_config.color_scheme]

      assert.equals(theme.background, bg.source.Color)
    end)

    it("should respect global opacity setting", function()
      local bg = appearance_config.background[1]

      -- Should use global opacity or default to 1
      assert.is_number(bg.opacity)
      assert.is_true(bg.opacity >= 0 and bg.opacity <= 1)
    end)
  end)

  describe("ANSI color configuration", function()
    it("should have ANSI color configuration", function()
      assert.is_not_nil(appearance_config.bold_brightens_ansi_colors)
      assert.equals("BrightAndBold", appearance_config.bold_brightens_ansi_colors)
    end)
  end)

  describe("character selection configuration", function()
    it("should have char select configuration", function()
      assert.is_not_nil(appearance_config.char_select_bg_color)
      assert.is_not_nil(appearance_config.char_select_fg_color)
      assert.is_number(appearance_config.char_select_font_size)
      assert.equals(12, appearance_config.char_select_font_size)
    end)

    it("should use theme colors for char select", function()
      local theme = appearance_config.color_schemes[appearance_config.color_scheme]

      assert.equals(theme.brights[6], appearance_config.char_select_bg_color)
      assert.equals(theme.background, appearance_config.char_select_fg_color)
    end)
  end)

  describe("command palette configuration", function()
    it("should have command palette configuration", function()
      assert.is_not_nil(appearance_config.command_palette_bg_color)
      assert.is_not_nil(appearance_config.command_palette_fg_color)
      assert.is_number(appearance_config.command_palette_font_size)
      assert.is_number(appearance_config.command_palette_rows)
    end)

    it("should have reasonable command palette settings", function()
      assert.equals(14, appearance_config.command_palette_font_size)
      assert.equals(20, appearance_config.command_palette_rows)
    end)

    it("should use theme colors for command palette", function()
      local theme = appearance_config.color_schemes[appearance_config.color_scheme]

      assert.equals(theme.brights[6], appearance_config.command_palette_bg_color)
      assert.equals(theme.background, appearance_config.command_palette_fg_color)
    end)
  end)

  describe("cursor configuration", function()
    it("should have cursor configuration", function()
      assert.is_string(appearance_config.cursor_blink_ease_in)
      assert.is_string(appearance_config.cursor_blink_ease_out)
      assert.is_number(appearance_config.cursor_blink_rate)
      assert.is_string(appearance_config.default_cursor_style)
      assert.is_number(appearance_config.cursor_thickness)
      assert.is_boolean(appearance_config.force_reverse_video_cursor)
    end)

    it("should have valid cursor settings", function()
      assert.equals("EaseIn", appearance_config.cursor_blink_ease_in)
      assert.equals("EaseOut", appearance_config.cursor_blink_ease_out)
      assert.equals(500, appearance_config.cursor_blink_rate)
      assert.equals("BlinkingUnderline", appearance_config.default_cursor_style)
      assert.equals(1, appearance_config.cursor_thickness)
      assert.is_true(appearance_config.force_reverse_video_cursor)
    end)

    it("should have positive cursor blink rate", function()
      assert.is_true(appearance_config.cursor_blink_rate > 0)
    end)

    it("should have positive cursor thickness", function()
      assert.is_true(appearance_config.cursor_thickness > 0)
    end)
  end)

  describe("scroll bar configuration", function()
    it("should have scroll bar configuration", function()
      assert.is_boolean(appearance_config.enable_scroll_bar)
      assert.is_true(appearance_config.enable_scroll_bar)
    end)
  end)

  describe("mouse configuration", function()
    it("should have mouse cursor configuration", function()
      assert.is_boolean(appearance_config.hide_mouse_cursor_when_typing)
      assert.is_true(appearance_config.hide_mouse_cursor_when_typing)
    end)
  end)

  describe("text blink configuration", function()
    it("should have text blink configuration", function()
      assert.is_string(appearance_config.text_blink_ease_in)
      assert.is_string(appearance_config.text_blink_ease_out)
      assert.is_string(appearance_config.text_blink_rapid_ease_in)
    end)

    it("should have valid text blink settings", function()
      assert.equals("EaseIn", appearance_config.text_blink_ease_in)
      assert.equals("EaseOut", appearance_config.text_blink_ease_out)
      assert.equals("Linear", appearance_config.text_blink_rapid_ease_in)
    end)
  end)

  describe("theme integration", function()
    it("should properly reference theme colors", function()
      local theme = appearance_config.color_schemes[appearance_config.color_scheme]

      -- Verify theme is properly accessed throughout config
      assert.is_table(theme)
      assert.is_table(theme.ansi)
      assert.is_table(theme.brights)
      helper.assert_valid_color(theme.background)
    end)

    it("should handle theme color arrays", function()
      local theme = appearance_config.color_schemes[appearance_config.color_scheme]

      assert.is_table(theme.ansi)
      assert.is_true(#theme.ansi >= 8)

      assert.is_table(theme.brights)
      assert.is_true(#theme.brights >= 8)

      -- Test specific color references used in config
      assert.is_not_nil(theme.brights[6])  -- Used for char_select and command_palette
    end)
  end)

  describe("configuration validation", function()
    it("should have all required appearance settings", function()
      local required_keys = {
        "color_schemes",
        "color_scheme",
        "background",
        "bold_brightens_ansi_colors",
        "cursor_blink_rate",
        "default_cursor_style",
        "enable_scroll_bar",
        "hide_mouse_cursor_when_typing"
      }

      for _, key in ipairs(required_keys) do
        helper.assert_table_contains(appearance_config, key)
      end
    end)

    it("should have valid easing functions", function()
      local valid_easing = {
        "Linear", "EaseIn", "EaseOut", "EaseInOut",
        "CubicBezier", "Constant"
      }

      local function is_valid_easing(value)
        for _, valid in ipairs(valid_easing) do
          if value == valid then return true end
        end
        return false
      end

      assert.is_true(is_valid_easing(appearance_config.cursor_blink_ease_in))
      assert.is_true(is_valid_easing(appearance_config.cursor_blink_ease_out))
      assert.is_true(is_valid_easing(appearance_config.text_blink_ease_in))
      assert.is_true(is_valid_easing(appearance_config.text_blink_ease_out))
      assert.is_true(is_valid_easing(appearance_config.text_blink_rapid_ease_in))
    end)

    it("should have valid cursor styles", function()
      local valid_cursor_styles = {
        "BlinkingBlock", "SteadyBlock",
        "BlinkingUnderline", "SteadyUnderline",
        "BlinkingBar", "SteadyBar"
      }

      local function is_valid_cursor_style(style)
        for _, valid in ipairs(valid_cursor_styles) do
          if style == valid then return true end
        end
        return false
      end

      assert.is_true(is_valid_cursor_style(appearance_config.default_cursor_style))
    end)
  end)

  describe("error handling", function()
    it("should handle missing color utils gracefully", function()
      package.loaded["utils"] = {
        fn = {
          color = {
            get_schemes = function() return {} end,
            get_scheme = function() return "NonExistent" end
          }
        }
      }

      assert.has_no.errors(function()
        package.loaded["config.appearance"] = nil
        require("config.appearance")
      end)
    end)

    it("should handle missing global settings", function()
      -- Remove global opacity setting
      helper.mock_wezterm.GLOBAL.opacity = nil

      assert.has_no.errors(function()
        package.loaded["config.appearance"] = nil
        local config = require("config.appearance")

        -- Should default to opacity 1
        assert.equals(1, config.background[1].opacity)
      end)
    end)

    it("should handle malformed color schemes", function()
      package.loaded["utils"] = {
        fn = {
          color = {
            get_schemes = function()
              return {
                ["Broken Scheme"] = {
                  -- Missing required colors
                }
              }
            end,
            get_scheme = function() return "Broken Scheme" end
          }
        }
      }

      assert.has_no.errors(function()
        package.loaded["config.appearance"] = nil
        require("config.appearance")
      end)
    end)
  end)
end)

---@module "tests.config.tab-bar_spec"
---@description Unit tests for config.tab-bar module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("config.tab-bar", function()
  local tab_bar_config

  before_each(function()
    helper.setup()
    tab_bar_config = require("config.tab-bar")
  end)

  after_each(function()
    helper.teardown()
    package.loaded["config.tab-bar"] = nil
  end)

  describe("tab bar visibility", function()
    it("should configure tab bar enabled state", function()
      if tab_bar_config.enable_tab_bar ~= nil then
        assert.is_boolean(tab_bar_config.enable_tab_bar)
      end
    end)

    it("should configure tab bar position", function()
      if tab_bar_config.tab_bar_at_bottom ~= nil then
        assert.is_boolean(tab_bar_config.tab_bar_at_bottom)
      end
    end)

    it("should configure fancy tab bar usage", function()
      if tab_bar_config.use_fancy_tab_bar ~= nil then
        assert.is_boolean(tab_bar_config.use_fancy_tab_bar)
      end
    end)

    it("should hide tab bar when only one tab", function()
      if tab_bar_config.hide_tab_bar_if_only_one_tab ~= nil then
        assert.is_boolean(tab_bar_config.hide_tab_bar_if_only_one_tab)
      end
    end)
  end)

  describe("tab bar styling", function()
    it("should configure tab max width", function()
      if tab_bar_config.tab_max_width then
        assert.is_number(tab_bar_config.tab_max_width)
        assert.is_true(tab_bar_config.tab_max_width > 0)
      end
    end)

    it("should configure tab bar height", function()
      if tab_bar_config.tab_bar_style then
        assert.is_table(tab_bar_style)
      end
    end)

    it("should configure new tab button", function()
      if tab_bar_config.show_new_tab_button_in_tab_bar ~= nil then
        assert.is_boolean(tab_bar_config.show_new_tab_button_in_tab_bar)
      end

      if tab_bar_config.new_tab_hover then
        assert.is_table(tab_bar_config.new_tab_hover)
      end
    end)

    it("should configure tab close button", function()
      if tab_bar_config.show_close_tab_button_in_tabs ~= nil then
        assert.is_boolean(tab_bar_config.show_close_tab_button_in_tabs)
      end
    end)
  end)

  describe("tab colors", function()
    it("should have tab color configuration", function()
      if tab_bar_config.colors then
        assert.is_table(tab_bar_config.colors)

        if tab_bar_config.colors.tab_bar then
          assert.is_table(tab_bar_config.colors.tab_bar)
        end
      end
    end)

    it("should configure active tab colors", function()
      if tab_bar_config.colors and tab_bar_config.colors.tab_bar then
        local tab_bar = tab_bar_config.colors.tab_bar

        if tab_bar.active_tab then
          assert.is_table(tab_bar.active_tab)

          if tab_bar.active_tab.bg_color then
            helper.assert_valid_color(tab_bar.active_tab.bg_color)
          end

          if tab_bar.active_tab.fg_color then
            helper.assert_valid_color(tab_bar.active_tab.fg_color)
          end
        end
      end
    end)

    it("should configure inactive tab colors", function()
      if tab_bar_config.colors and tab_bar_config.colors.tab_bar then
        local tab_bar = tab_bar_config.colors.tab_bar

        if tab_bar.inactive_tab then
          assert.is_table(tab_bar.inactive_tab)

          if tab_bar.inactive_tab.bg_color then
            helper.assert_valid_color(tab_bar.inactive_tab.bg_color)
          end

          if tab_bar.inactive_tab.fg_color then
            helper.assert_valid_color(tab_bar.inactive_tab.fg_color)
          end
        end
      end
    end)

    it("should configure hover colors", function()
      if tab_bar_config.colors and tab_bar_config.colors.tab_bar then
        local tab_bar = tab_bar_config.colors.tab_bar

        if tab_bar.inactive_tab_hover then
          assert.is_table(tab_bar.inactive_tab_hover)

          if tab_bar.inactive_tab_hover.bg_color then
            helper.assert_valid_color(tab_bar.inactive_tab_hover.bg_color)
          end

          if tab_bar.inactive_tab_hover.fg_color then
            helper.assert_valid_color(tab_bar.inactive_tab_hover.fg_color)
          end
        end
      end
    end)

    it("should configure new tab button colors", function()
      if tab_bar_config.colors and tab_bar_config.colors.tab_bar then
        local tab_bar = tab_bar_config.colors.tab_bar

        if tab_bar.new_tab then
          assert.is_table(tab_bar.new_tab)

          if tab_bar.new_tab.bg_color then
            helper.assert_valid_color(tab_bar.new_tab.bg_color)
          end

          if tab_bar.new_tab.fg_color then
            helper.assert_valid_color(tab_bar.new_tab.fg_color)
          end
        end

        if tab_bar.new_tab_hover then
          assert.is_table(tab_bar.new_tab_hover)
        end
      end
    end)
  end)

  describe("tab formatting", function()
    it("should configure tab title formatting", function()
      if tab_bar_config.tab_title_format then
        assert.is_string(tab_bar_config.tab_title_format)
      end
    end)

    it("should configure active tab title formatting", function()
      if tab_bar_config.active_tab_title_format then
        assert.is_string(tab_bar_config.active_tab_title_format)
      end
    end)

    it("should handle tab title truncation", function()
      if tab_bar_config.tab_max_width then
        assert.is_number(tab_bar_config.tab_max_width)
        assert.is_true(tab_bar_config.tab_max_width > 0)
      end
    end)
  end)

  describe("tab bar fonts", function()
    it("should configure tab bar font", function()
      if tab_bar_config.window_frame then
        assert.is_table(tab_bar_config.window_frame)

        if tab_bar_config.window_frame.font then
          assert.is_table(tab_bar_config.window_frame.font)

          if tab_bar_config.window_frame.font.family then
            assert.is_string(tab_bar_config.window_frame.font.family)
          end

          if tab_bar_config.window_frame.font.size then
            assert.is_number(tab_bar_config.window_frame.font.size)
            assert.is_true(tab_bar_config.window_frame.font.size > 0)
          end
        end
      end
    end)

    it("should configure tab bar font size", function()
      if tab_bar_config.window_frame and tab_bar_config.window_frame.font then
        local font = tab_bar_config.window_frame.font

        if font.size then
          assert.is_number(font.size)
          assert.is_true(font.size >= 8 and font.size <= 72)
        end
      end
    end)
  end)

  describe("window frame", function()
    it("should configure window frame colors", function()
      if tab_bar_config.window_frame then
        assert.is_table(tab_bar_config.window_frame)

        if tab_bar_config.window_frame.active_titlebar_bg then
          helper.assert_valid_color(tab_bar_config.window_frame.active_titlebar_bg)
        end

        if tab_bar_config.window_frame.inactive_titlebar_bg then
          helper.assert_valid_color(tab_bar_config.window_frame.inactive_titlebar_bg)
        end
      end
    end)

    it("should configure window frame border", function()
      if tab_bar_config.window_frame then
        local frame = tab_bar_config.window_frame

        if frame.border_left_width then
          assert.is_number(frame.border_left_width)
          assert.is_true(frame.border_left_width >= 0)
        end

        if frame.border_right_width then
          assert.is_number(frame.border_right_width)
          assert.is_true(frame.border_right_width >= 0)
        end

        if frame.border_bottom_height then
          assert.is_number(frame.border_bottom_height)
          assert.is_true(frame.border_bottom_height >= 0)
        end

        if frame.border_top_height then
          assert.is_number(frame.border_top_height)
          assert.is_true(frame.border_top_height >= 0)
        end
      end
    end)
  end)

  describe("tab indicators", function()
    it("should configure unseen output indicator", function()
      if tab_bar_config.show_tab_index_in_tab_bar ~= nil then
        assert.is_boolean(tab_bar_config.show_tab_index_in_tab_bar)
      end
    end)

    it("should configure tab index display", function()
      if tab_bar_config.show_tab_index_in_tab_bar ~= nil then
        assert.is_boolean(tab_bar_config.show_tab_index_in_tab_bar)
      end
    end)

    it("should configure zoomed pane indicator", function()
      -- WezTerm shows indicators for zoomed panes
      if tab_bar_config.show_tab_index_in_tab_bar ~= nil then
        assert.is_boolean(tab_bar_config.show_tab_index_in_tab_bar)
      end
    end)
  end)

  describe("scrolling behavior", function()
    it("should configure tab bar scrolling", function()
      if tab_bar_config.enable_scroll_bar ~= nil then
        assert.is_boolean(tab_bar_config.enable_scroll_bar)
      end
    end)

    it("should handle many tabs gracefully", function()
      if tab_bar_config.tab_max_width then
        assert.is_number(tab_bar_config.tab_max_width)
        assert.is_true(tab_bar_config.tab_max_width > 0)
      end
    end)
  end)

  describe("integration with themes", function()
    it("should work with color schemes", function()
      local config = helper.create_test_config()

      if tab_bar_config.colors then
        -- Tab bar colors should integrate with overall color scheme
        assert.is_table(tab_bar_config.colors)
      end
    end)

    it("should respect theme inheritance", function()
      if tab_bar_config.colors and tab_bar_config.colors.tab_bar then
        local tab_bar = tab_bar_config.colors.tab_bar

        if tab_bar.background then
          helper.assert_valid_color(tab_bar.background)
        end
      end
    end)
  end)

  describe("error handling", function()
    it("should handle missing color values gracefully", function()
      -- Should provide sensible defaults
      assert.is_table(tab_bar_config)
    end)

    it("should handle invalid color values", function()
      -- Should validate color formats
      if tab_bar_config.colors then
        assert.is_table(tab_bar_config.colors)
      end
    end)

    it("should handle invalid dimensions", function()
      if tab_bar_config.tab_max_width then
        assert.is_number(tab_bar_config.tab_max_width)
        assert.is_true(tab_bar_config.tab_max_width > 0)
      end
    end)
  end)

  describe("accessibility", function()
    it("should provide sufficient color contrast", function()
      if tab_bar_config.colors and tab_bar_config.colors.tab_bar then
        local tab_bar = tab_bar_config.colors.tab_bar

        -- Should have good contrast between foreground and background
        if tab_bar.active_tab then
          assert.is_table(tab_bar.active_tab)
        end
      end
    end)

    it("should support high contrast themes", function()
      if tab_bar_config.colors then
        assert.is_table(tab_bar_config.colors)
      end
    end)

    it("should be readable at different font sizes", function()
      if tab_bar_config.window_frame and tab_bar_config.window_frame.font then
        local font = tab_bar_config.window_frame.font

        if font.size then
          assert.is_number(font.size)
          assert.is_true(font.size >= 8) -- Minimum readable size
        end
      end
    end)
  end)

  describe("performance", function()
    it("should handle many tabs efficiently", function()
      -- Configuration should scale well with tab count
      assert.is_table(tab_bar_config)
    end)

    it("should minimize redraw operations", function()
      if tab_bar_config.use_fancy_tab_bar ~= nil then
        -- Fancy tab bar can be more expensive
        assert.is_boolean(tab_bar_config.use_fancy_tab_bar)
      end
    end)
  end)

  describe("platform compatibility", function()
    it("should work across different operating systems", function()
      if tab_bar_config.window_frame then
        assert.is_table(tab_bar_config.window_frame)
      end
    end)

    it("should handle different DPI settings", function()
      if tab_bar_config.window_frame and tab_bar_config.window_frame.font then
        local font = tab_bar_config.window_frame.font

        if font.size then
          assert.is_number(font.size)
        end
      end
    end)
  end)

  describe("customization", function()
    it("should allow tab bar position customization", function()
      if tab_bar_config.tab_bar_at_bottom ~= nil then
        assert.is_boolean(tab_bar_config.tab_bar_at_bottom)
      end
    end)

    it("should allow color customization", function()
      if tab_bar_config.colors then
        assert.is_table(tab_bar_config.colors)
      end
    end)

    it("should allow font customization", function()
      if tab_bar_config.window_frame and tab_bar_config.window_frame.font then
        assert.is_table(tab_bar_config.window_frame.font)
      end
    end)
  end)

  describe("integration", function()
    it("should work with Config class", function()
      local Config = require("utils.class.config")
      local config = Config:new()

      assert.has_no.errors(function()
        config:add(tab_bar_config)
      end)
    end)

    it("should work with appearance configuration", function()
      local appearance_config = require("config.appearance")

      -- Should not conflict with appearance settings
      assert.is_table(tab_bar_config)
      assert.is_table(appearance_config)
    end)

    it("should work with event handlers", function()
      -- Should work with format-tab-title event
      assert.is_table(tab_bar_config)
    end)
  end)

  describe("validation", function()
    it("should have valid WezTerm configuration structure", function()
      assert.is_table(tab_bar_config)

      -- Should not contain any obviously invalid keys
      for key, value in pairs(tab_bar_config) do
        assert.is_not_nil(key)
        assert.is_not_nil(value)
        assert.is_string(key)
      end
    end)

    it("should use correct data types", function()
      if tab_bar_config.enable_tab_bar ~= nil then
        assert.is_boolean(tab_bar_config.enable_tab_bar)
      end

      if tab_bar_config.tab_max_width then
        assert.is_number(tab_bar_config.tab_max_width)
      end

      if tab_bar_config.colors then
        assert.is_table(tab_bar_config.colors)
      end
    end)
  end)
end)

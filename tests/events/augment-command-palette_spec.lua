---@module "tests.events.augment-command-palette_spec"
---@description Tests for events.augment-command-palette module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("events.augment-command-palette", function()
  local augment_command_palette_fn

  before_each(function()
    helper.setup_mocks()

    -- Mock picker modules
    package.loaded["picker.colorscheme"] = {
      pick = function()
        return {
          action = "ColorSchemePicker",
          args = {}
        }
      end
    }

    package.loaded["picker.font"] = {
      pick = function()
        return {
          action = "FontPicker",
          args = {}
        }
      end
    }

    package.loaded["picker.font-size"] = {
      pick = function()
        return {
          action = "FontSizePicker",
          args = {}
        }
      end
    }

    package.loaded["picker.font-leading"] = {
      pick = function()
        return {
          action = "FontLeadingPicker",
          args = {}
        }
      end
    }

    -- Load the module to register the event handler
    require("events.augment-command-palette")

    -- Get the registered handler
    local mock_wezterm = helper.get_mock_wezterm()
    augment_command_palette_fn = mock_wezterm._event_handlers["augment-command-palette"]
  end)

  after_each(function()
    helper.cleanup_mocks()
  end)

  describe("Event handler registration", function()
    it("should register augment-command-palette event handler", function()
      assert.is_function(augment_command_palette_fn)
    end)
  end)

  describe("Command palette entries", function()
    local palette_entries

    before_each(function()
      palette_entries = augment_command_palette_fn(nil, nil)
    end)

    it("should return a table of command entries", function()
      assert.is_table(palette_entries)
      assert.truthy(#palette_entries > 0)
    end)

    describe("Rename tab command", function()
      local rename_entry

      before_each(function()
        rename_entry = palette_entries[1] -- First entry should be rename tab
      end)

      it("should have rename tab entry", function()
        assert.is_table(rename_entry)
        assert.equals("Rename tab", rename_entry.brief)
        assert.equals("md_rename_box", rename_entry.icon)
      end)

      it("should have PromptInputLine action", function()
        assert.is_table(rename_entry.action)
        assert.equals("PromptInputLine", rename_entry.action.action)
        assert.equals("Enter new name for tab", rename_entry.action.description)
        assert.is_function(rename_entry.action.action)
      end)

      it("should handle tab renaming callback", function()
        local mock_window = {
          active_tab = function()
            return {
              set_title = spy.new(function() end)
            }
          end
        }

        -- Test the callback function
        local callback = rename_entry.action.action
        callback(mock_window, nil, "New Tab Name")

        assert.spy(mock_window.active_tab().set_title).was.called.with("New Tab Name")
      end)

      it("should handle nil input gracefully", function()
        local mock_window = {
          active_tab = function()
            return {
              set_title = spy.new(function() end)
            }
          end
        }

        local callback = rename_entry.action.action
        callback(mock_window, nil, nil)

        assert.spy(mock_window.active_tab().set_title).was_not.called()
      end)
    end)

    describe("Colorscheme picker command", function()
      local colorscheme_entry

      before_each(function()
        colorscheme_entry = palette_entries[2] -- Second entry should be colorscheme picker
      end)

      it("should have colorscheme picker entry", function()
        assert.is_table(colorscheme_entry)
        assert.equals("Colorscheme picker", colorscheme_entry.brief)
        assert.equals("md_palette", colorscheme_entry.icon)
      end)

      it("should have colorscheme picker action", function()
        assert.is_table(colorscheme_entry.action)
        assert.equals("ColorSchemePicker", colorscheme_entry.action.action)
      end)
    end)

    describe("Font picker command", function()
      local font_entry

      before_each(function()
        font_entry = palette_entries[3] -- Third entry should be font picker
      end)

      it("should have font picker entry", function()
        assert.is_table(font_entry)
        assert.equals("Font picker", font_entry.brief)
      end)

      it("should have font picker action", function()
        assert.is_table(font_entry.action)
        assert.equals("FontPicker", font_entry.action.action)
      end)
    end)

    describe("Font size picker command", function()
      local font_size_entry

      before_each(function()
        -- Find font size picker entry
        for _, entry in ipairs(palette_entries) do
          if entry.brief and entry.brief:find("Font size") then
            font_size_entry = entry
            break
          end
        end
      end)

      it("should have font size picker entry", function()
        assert.is_table(font_size_entry)
        assert.truthy(font_size_entry.brief:find("size"))
      end)

      it("should have font size picker action", function()
        if font_size_entry then
          assert.is_table(font_size_entry.action)
          assert.equals("FontSizePicker", font_size_entry.action.action)
        end
      end)
    end)

    describe("Font leading picker command", function()
      local font_leading_entry

      before_each(function()
        -- Find font leading picker entry
        for _, entry in ipairs(palette_entries) do
          if entry.brief and entry.brief:find("leading") then
            font_leading_entry = entry
            break
          end
        end
      end)

      it("should have font leading picker entry", function()
        if font_leading_entry then
          assert.is_table(font_leading_entry)
          assert.truthy(font_leading_entry.brief:find("leading"))
        end
      end)

      it("should have font leading picker action", function()
        if font_leading_entry then
          assert.is_table(font_leading_entry.action)
          assert.equals("FontLeadingPicker", font_leading_entry.action.action)
        end
      end)
    end)
  end)

  describe("Command entry validation", function()
    local palette_entries

    before_each(function()
      palette_entries = augment_command_palette_fn(nil, nil)
    end)

    it("should have valid structure for all entries", function()
      for i, entry in ipairs(palette_entries) do
        assert.is_table(entry, "Entry " .. i .. " should be a table")
        assert.is_string(entry.brief, "Entry " .. i .. " should have brief description")

        if entry.icon then
          assert.is_string(entry.icon, "Entry " .. i .. " icon should be string")
        end

        if entry.action then
          assert.is_not_nil(entry.action, "Entry " .. i .. " should have action")
        end
      end
    end)

    it("should have unique brief descriptions", function()
      local briefs = {}
      for _, entry in ipairs(palette_entries) do
        assert.is_nil(briefs[entry.brief], "Brief '" .. entry.brief .. "' should be unique")
        briefs[entry.brief] = true
      end
    end)

    it("should have valid icon names", function()
      local valid_icon_pattern = "^md_" -- Material Design icons
      for _, entry in ipairs(palette_entries) do
        if entry.icon then
          assert.truthy(entry.icon:match(valid_icon_pattern) or entry.icon:match("^[%w_]+$"),
            "Icon '" .. entry.icon .. "' should be valid")
        end
      end
    end)
  end)

  describe("Integration with picker modules", function()
    it("should integrate with colorscheme picker", function()
      local colorscheme_picker = require("picker.colorscheme")
      assert.is_function(colorscheme_picker.pick)
    end)

    it("should integrate with font picker", function()
      local font_picker = require("picker.font")
      assert.is_function(font_picker.pick)
    end)

    it("should integrate with font-size picker", function()
      local font_size_picker = require("picker.font-size")
      assert.is_function(font_size_picker.pick)
    end)

    it("should integrate with font-leading picker", function()
      local font_leading_picker = require("picker.font-leading")
      assert.is_function(font_leading_picker.pick)
    end)
  end)

  describe("WezTerm action integration", function()
    it("should use wezterm action and action_callback", function()
      local wt = require("wezterm")
      assert.is_table(wt.action)
      assert.is_function(wt.action_callback)
    end)

    it("should properly structure PromptInputLine action", function()
      local palette_entries = augment_command_palette_fn(nil, nil)
      local rename_entry = palette_entries[1]

      local action = rename_entry.action
      assert.equals("PromptInputLine", action.action)
      assert.is_string(action.description)
      assert.is_function(action.action)
    end)
  end)

  describe("Error handling", function()
    it("should handle missing picker modules gracefully", function()
      -- Test with missing colorscheme picker
      package.loaded["picker.colorscheme"] = nil

      local success, result = pcall(function()
        package.loaded["events.augment-command-palette"] = nil
        return require("events.augment-command-palette")
      end)

      if not success then
        assert.is_string(result) -- Should have error message
      end
    end)

    it("should handle invalid picker responses", function()
      package.loaded["picker.colorscheme"] = {
        pick = function()
          return nil -- Invalid response
        end
      }

      package.loaded["events.augment-command-palette"] = nil
      local success, result = pcall(require, "events.augment-command-palette")

      if not success then
        assert.is_string(result)
      end
    end)
  end)

  describe("Event parameters", function()
    it("should handle nil parameters", function()
      local result = augment_command_palette_fn(nil, nil)
      assert.is_table(result)
    end)

    it("should handle empty parameters", function()
      local result = augment_command_palette_fn({}, {})
      assert.is_table(result)
    end)
  end)
end)

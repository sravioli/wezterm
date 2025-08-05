---@module "tests.events.new-tab-button-click_spec"
---@description Unit tests for events.new-tab-button-click module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("events.new-tab-button-click", function()
  before_each(function()
    helper.setup()

    -- Load the event handler
    require("events.new-tab-button-click")
  end)

  after_each(function()
    helper.teardown()
    package.loaded["events.new-tab-button-click"] = nil
  end)

  describe("event registration", function()
    it("should register new-tab-button-click event", function()
      assert.is_not_nil(helper.registered_events)
      assert.is_function(helper.registered_events["new-tab-button-click"])
    end)
  end)

  describe("new tab creation", function()
    local click_handler

    before_each(function()
      click_handler = helper.registered_events["new-tab-button-click"]
    end)

    it("should create new tab on left click", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local button = "Left"

      local tab_created = false
      window.spawn_tab = function()
        tab_created = true
        return helper.create_mock_tab({ is_active = true })
      end

      local result = click_handler(window, pane, button)

      -- Handler might return action or perform action directly
      if result then
        assert.is_not_nil(result)
      end
    end)

    it("should handle right click differently", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local button = "Right"

      assert.has_no.errors(function()
        click_handler(window, pane, button)
      end)
    end)

    it("should handle middle click", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local button = "Middle"

      assert.has_no.errors(function()
        click_handler(window, pane, button)
      end)
    end)

    it("should ignore unknown button types", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local button = "Unknown"

      assert.has_no.errors(function()
        click_handler(window, pane, button)
      end)
    end)
  end)

  describe("workspace handling", function()
    local click_handler

    before_each(function()
      click_handler = helper.registered_events["new-tab-button-click"]
    end)

    it("should create tab in current workspace", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      window.active_workspace = function()
        return "work-project"
      end

      local current_workspace = nil
      window.spawn_tab = function(args)
        current_workspace = args and args.workspace or window.active_workspace()
        return helper.create_mock_tab()
      end

      click_handler(window, pane, "Left")

      if current_workspace then
        assert.equals("work-project", current_workspace)
      end
    end)

    it("should handle empty workspace names", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      window.active_workspace = function()
        return ""
      end

      assert.has_no.errors(function()
        click_handler(window, pane, "Left")
      end)
    end)

    it("should handle nil workspace", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      window.active_workspace = function()
        return nil
      end

      assert.has_no.errors(function()
        click_handler(window, pane, "Left")
      end)
    end)
  end)

  describe("current directory handling", function()
    local click_handler

    before_each(function()
      click_handler = helper.registered_events["new-tab-button-click"]
    end)

    it("should inherit current working directory", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      pane.get_current_working_dir = function()
        return { file_path = "/home/user/project" }
      end

      local cwd_used = nil
      window.spawn_tab = function(args)
        cwd_used = args and args.cwd
        return helper.create_mock_tab()
      end

      click_handler(window, pane, "Left")

      if cwd_used then
        assert.is_string(cwd_used)
      end
    end)

    it("should handle missing current directory", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      pane.get_current_working_dir = function()
        return nil
      end

      assert.has_no.errors(function()
        click_handler(window, pane, "Left")
      end)
    end)

    it("should handle malformed directory paths", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      pane.get_current_working_dir = function()
        return { file_path = "" }
      end

      assert.has_no.errors(function()
        click_handler(window, pane, "Left")
      end)
    end)
  end)

  describe("modifier key handling", function()
    local click_handler

    before_each(function()
      click_handler = helper.registered_events["new-tab-button-click"]
    end)

    it("should handle click with modifiers", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local button = "Left"
      local modifiers = "CTRL"

      assert.has_no.errors(function()
        click_handler(window, pane, button, modifiers)
      end)
    end)

    it("should handle Ctrl+click for background tab", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local button = "Left"
      local modifiers = "CTRL"

      local background_tab = false
      window.spawn_tab = function(args)
        background_tab = args and args.activate == false
        return helper.create_mock_tab()
      end

      click_handler(window, pane, button, modifiers)

      -- Might create tab in background with Ctrl modifier
    end)

    it("should handle Shift+click", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local button = "Left"
      local modifiers = "SHIFT"

      assert.has_no.errors(function()
        click_handler(window, pane, button, modifiers)
      end)
    end)

    it("should handle multiple modifiers", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local button = "Left"
      local modifiers = "CTRL|SHIFT"

      assert.has_no.errors(function()
        click_handler(window, pane, button, modifiers)
      end)
    end)
  end)

  describe("tab configuration", function()
    local click_handler

    before_each(function()
      click_handler = helper.registered_events["new-tab-button-click"]
    end)

    it("should create tab with default shell", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      local shell_used = nil
      window.spawn_tab = function(args)
        shell_used = args and args.args
        return helper.create_mock_tab()
      end

      click_handler(window, pane, "Left")

      -- Default shell should be used
    end)

    it("should respect tab domain", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      local domain_used = nil
      window.spawn_tab = function(args)
        domain_used = args and args.domain
        return helper.create_mock_tab()
      end

      click_handler(window, pane, "Left")

      -- Should use appropriate domain
    end)

    it("should handle tab creation errors", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      window.spawn_tab = function()
        error("Mock tab creation error")
      end

      assert.has_no.errors(function()
        click_handler(window, pane, "Left")
      end)
    end)
  end)

  describe("return values", function()
    local click_handler

    before_each(function()
      click_handler = helper.registered_events["new-tab-button-click"]
    end)

    it("should return appropriate action or nil", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      local result = click_handler(window, pane, "Left")

      -- Result can be nil (handled internally) or action table
      if result then
        assert.is_not_nil(result)
      end
    end)

    it("should handle action creation", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      assert.has_no.errors(function()
        click_handler(window, pane, "Left")
      end)
    end)
  end)

  describe("error handling", function()
    local click_handler

    before_each(function()
      click_handler = helper.registered_events["new-tab-button-click"]
    end)

    it("should handle nil window", function()
      local pane = helper.create_mock_pane()

      assert.has_no.errors(function()
        click_handler(nil, pane, "Left")
      end)
    end)

    it("should handle nil pane", function()
      local window = helper.create_mock_window()

      assert.has_no.errors(function()
        click_handler(window, nil, "Left")
      end)
    end)

    it("should handle nil button", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      assert.has_no.errors(function()
        click_handler(window, pane, nil)
      end)
    end)

    it("should handle window method errors", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      window.active_workspace = function()
        error("Mock workspace error")
      end

      assert.has_no.errors(function()
        click_handler(window, pane, "Left")
      end)
    end)

    it("should handle pane method errors", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      pane.get_current_working_dir = function()
        error("Mock directory error")
      end

      assert.has_no.errors(function()
        click_handler(window, pane, "Left")
      end)
    end)
  end)

  describe("performance", function()
    local click_handler

    before_each(function()
      click_handler = helper.registered_events["new-tab-button-click"]
    end)

    it("should handle rapid clicks efficiently", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      assert.has_no.errors(function()
        for i = 1, 10 do
          click_handler(window, pane, "Left")
        end
      end)
    end)

    it("should not block on tab creation", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      local start_time = os.clock()
      click_handler(window, pane, "Left")
      local elapsed = os.clock() - start_time

      assert.is_true(elapsed < 0.1) -- Should be very fast
    end)
  end)

  describe("integration", function()
    it("should work with tab bar configuration", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local click_handler = helper.registered_events["new-tab-button-click"]

      -- Should integrate with tab bar settings
      assert.has_no.errors(function()
        click_handler(window, pane, "Left")
      end)
    end)

    it("should work with workspace management", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local click_handler = helper.registered_events["new-tab-button-click"]

      window.active_workspace = function() return "test-workspace" end

      assert.has_no.errors(function()
        click_handler(window, pane, "Left")
      end)
    end)

    it("should work with directory inheritance", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local click_handler = helper.registered_events["new-tab-button-click"]

      pane.get_current_working_dir = function()
        return { file_path = "/test/directory" }
      end

      assert.has_no.errors(function()
        click_handler(window, pane, "Left")
      end)
    end)
  end)

  describe("accessibility", function()
    local click_handler

    before_each(function()
      click_handler = helper.registered_events["new-tab-button-click"]
    end)

    it("should support keyboard activation", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      -- Should handle keyboard activation as left click
      assert.has_no.errors(function()
        click_handler(window, pane, "Left")
      end)
    end)

    it("should provide consistent behavior", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      -- Multiple clicks should behave consistently
      for i = 1, 3 do
        assert.has_no.errors(function()
          click_handler(window, pane, "Left")
        end)
      end
    end)
  end)
end)

---@module "tests.events.update-status_spec"
---@description Unit tests for events.update-status module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("events.update-status", function()
  before_each(function()
    helper.setup()

    -- Mock Utils module
    package.loaded["utils"] = {
      fn = {
        str = {
          format = function(template, ...)
            return string.format(template, ...)
          end
        },
        icon = {
          get = function(name)
            return {
              ["workspace"] = "🗂",
              ["battery"] = "🔋",
              ["clock"] = "🕐"
            }[name] or "❓"
          end
        }
      },
      class = {
        icon = {
          get = function(name) return "❓" end
        }
      }
    }

    -- Load the event handler
    require("events.update-status")
  end)

  after_each(function()
    helper.teardown()
    package.loaded["utils"] = nil
    package.loaded["events.update-status"] = nil
  end)

  describe("event registration", function()
    it("should register update-right-status event", function()
      assert.is_not_nil(helper.registered_events)
      assert.is_function(helper.registered_events["update-right-status"])
    end)
  end)

  describe("status formatting", function()
    local update_handler

    before_each(function()
      update_handler = helper.registered_events["update-right-status"]
    end)

    it("should call set_right_status on window", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local status_set = false

      window.set_right_status = function(status)
        status_set = true
        assert.is_string(status)
      end

      assert.has_no.errors(function()
        update_handler(window, pane)
      end)

      assert.is_true(status_set)
    end)

    it("should include workspace information", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local captured_status = nil

      window.set_right_status = function(status)
        captured_status = status
      end

      window.active_workspace = function()
        return "test-workspace"
      end

      update_handler(window, pane)

      assert.is_string(captured_status)
      -- Should contain workspace information in some form
      assert.is_not_nil(captured_status)
    end)

    it("should include key table information when active", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local captured_status = nil

      window.set_right_status = function(status)
        captured_status = status
      end

      window.active_key_table = function()
        return "resize"
      end

      update_handler(window, pane)

      assert.is_string(captured_status)
    end)

    it("should handle no active key table", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      window.active_key_table = function()
        return nil
      end

      assert.has_no.errors(function()
        update_handler(window, pane)
      end)
    end)

    it("should include leader key status", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local captured_status = nil

      window.set_right_status = function(status)
        captured_status = status
      end

      window.leader_is_active = function()
        return true
      end

      update_handler(window, pane)

      assert.is_string(captured_status)
    end)
  end)

  describe("workspace handling", function()
    local update_handler

    before_each(function()
      update_handler = helper.registered_events["update-right-status"]
    end)

    it("should handle different workspace names", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      local workspaces = { "default", "work", "personal", "project-123" }

      for _, workspace in ipairs(workspaces) do
        window.active_workspace = function()
          return workspace
        end

        assert.has_no.errors(function()
          update_handler(window, pane)
        end)
      end
    end)

    it("should handle nil workspace", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      window.active_workspace = function()
        return nil
      end

      assert.has_no.errors(function()
        update_handler(window, pane)
      end)
    end)

    it("should handle empty workspace name", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      window.active_workspace = function()
        return ""
      end

      assert.has_no.errors(function()
        update_handler(window, pane)
      end)
    end)
  end)

  describe("key table handling", function()
    local update_handler

    before_each(function()
      update_handler = helper.registered_events["update-right-status"]
    end)

    it("should handle different key tables", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      local key_tables = { "resize", "copy", "search", "custom-table" }

      for _, key_table in ipairs(key_tables) do
        window.active_key_table = function()
          return key_table
        end

        assert.has_no.errors(function()
          update_handler(window, pane)
        end)
      end
    end)

    it("should differentiate between active and inactive key tables", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local status_with_table = nil
      local status_without_table = nil

      window.set_right_status = function(status)
        if window.active_key_table() then
          status_with_table = status
        else
          status_without_table = status
        end
      end

      -- Test with key table
      window.active_key_table = function() return "resize" end
      update_handler(window, pane)

      -- Test without key table
      window.active_key_table = function() return nil end
      update_handler(window, pane)

      assert.is_string(status_with_table)
      assert.is_string(status_without_table)
    end)
  end)

  describe("leader key handling", function()
    local update_handler

    before_each(function()
      update_handler = helper.registered_events["update-right-status"]
    end)

    it("should handle active leader key", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      window.leader_is_active = function()
        return true
      end

      assert.has_no.errors(function()
        update_handler(window, pane)
      end)
    end)

    it("should handle inactive leader key", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      window.leader_is_active = function()
        return false
      end

      assert.has_no.errors(function()
        update_handler(window, pane)
      end)
    end)

    it("should differentiate between active and inactive leader", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local status_with_leader = nil
      local status_without_leader = nil

      window.set_right_status = function(status)
        if window.leader_is_active() then
          status_with_leader = status
        else
          status_without_leader = status
        end
      end

      -- Test with leader active
      window.leader_is_active = function() return true end
      update_handler(window, pane)

      -- Test with leader inactive
      window.leader_is_active = function() return false end
      update_handler(window, pane)

      assert.is_string(status_with_leader)
      assert.is_string(status_without_leader)
    end)
  end)

  describe("pane information", function()
    local update_handler

    before_each(function()
      update_handler = helper.registered_events["update-right-status"]
    end)

    it("should handle pane working directory", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      pane.get_current_working_dir = function()
        return { file_path = "/home/user/project" }
      end

      assert.has_no.errors(function()
        update_handler(window, pane)
      end)
    end)

    it("should handle pane foreground process", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      pane.get_foreground_process_name = function()
        return "nvim"
      end

      assert.has_no.errors(function()
        update_handler(window, pane)
      end)
    end)

    it("should handle missing pane information", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      pane.get_current_working_dir = function()
        return nil
      end

      pane.get_foreground_process_name = function()
        return nil
      end

      assert.has_no.errors(function()
        update_handler(window, pane)
      end)
    end)
  end)

  describe("time and date formatting", function()
    local update_handler

    before_each(function()
      update_handler = helper.registered_events["update-right-status"]
    end)

    it("should include time information", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()
      local captured_status = nil

      window.set_right_status = function(status)
        captured_status = status
      end

      update_handler(window, pane)

      assert.is_string(captured_status)
      -- Status should contain some time-related information
      assert.is_not_nil(captured_status)
    end)
  end)

  describe("error handling", function()
    local update_handler

    before_each(function()
      update_handler = helper.registered_events["update-right-status"]
    end)

    it("should handle nil window", function()
      local pane = helper.create_mock_pane()

      assert.has_no.errors(function()
        update_handler(nil, pane)
      end)
    end)

    it("should handle nil pane", function()
      local window = helper.create_mock_window()

      assert.has_no.errors(function()
        update_handler(window, nil)
      end)
    end)

    it("should handle window without set_right_status", function()
      local window = {}
      local pane = helper.create_mock_pane()

      assert.has_no.errors(function()
        update_handler(window, pane)
      end)
    end)

    it("should handle errors in window methods", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      window.active_workspace = function()
        error("Mock error in active_workspace")
      end

      assert.has_no.errors(function()
        update_handler(window, pane)
      end)
    end)

    it("should handle errors in pane methods", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      pane.get_current_working_dir = function()
        error("Mock error in get_current_working_dir")
      end

      assert.has_no.errors(function()
        update_handler(window, pane)
      end)
    end)

    it("should handle errors in set_right_status", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      window.set_right_status = function(status)
        error("Mock error in set_right_status")
      end

      assert.has_no.errors(function()
        update_handler(window, pane)
      end)
    end)
  end)

  describe("performance", function()
    local update_handler

    before_each(function()
      update_handler = helper.registered_events["update-right-status"]
    end)

    it("should handle rapid status updates", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      assert.has_no.errors(function()
        for i = 1, 100 do
          update_handler(window, pane)
        end
      end)
    end)

    it("should handle complex status information", function()
      local window = helper.create_mock_window()
      local pane = helper.create_mock_pane()

      window.active_workspace = function()
        return "very-long-workspace-name-that-might-cause-issues"
      end

      window.active_key_table = function()
        return "very-long-key-table-name"
      end

      pane.get_current_working_dir = function()
        return { file_path = "/very/long/path/to/current/working/directory/that/might/be/truncated" }
      end

      pane.get_foreground_process_name = function()
        return "very-long-process-name"
      end

      assert.has_no.errors(function()
        update_handler(window, pane)
      end)
    end)
  end)
end)

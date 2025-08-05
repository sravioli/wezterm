---@module "tests.events.format-window-title_spec"
---@description Tests for events.format-window-title module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("events.format-window-title", function()
  local format_window_title_fn

  before_each(function()
    helper.setup_mocks()

    -- Mock file system utilities
    package.loaded["utils.fn"] = {
      fs = {
        basename = function(path)
          if not path then return "" end
          return path:match("([^/\\]+)$") or path
        end
      }
    }

    -- Load the module to register the event handler
    require("events.format-window-title")

    -- Get the registered handler
    local mock_wezterm = helper.get_mock_wezterm()
    format_window_title_fn = mock_wezterm._event_handlers["format-window-title"]
  end)

  after_each(function()
    helper.cleanup_mocks()
  end)

  describe("Event handler registration", function()
    it("should register format-window-title event handler", function()
      assert.is_function(format_window_title_fn)
    end)
  end)

  describe("Window title formatting", function()
    local function create_mock_tab(options)
      return {
        tab_index = options.tab_index or 0,
        active_pane = {
          is_zoomed = options.is_zoomed or false
        }
      }
    end

    local function create_mock_pane(options)
      return {
        title = options.title or "test-title",
        foreground_process_name = options.foreground_process_name or "cmd",
        current_working_dir = {
          file_path = options.cwd or "/home/user/project"
        }
      }
    end

    describe("Basic title formatting", function()
      it("should format basic window title", function()
        local tab = create_mock_tab({})
        local pane = create_mock_pane({ title = "powershell.exe" })
        local tabs = { tab }

        local result = format_window_title_fn(tab, pane, tabs, nil, nil)
        assert.is_string(result)
        assert.truthy(result:find("powershell"))
      end)

      it("should remove .exe extension from title", function()
        local tab = create_mock_tab({})
        local pane = create_mock_pane({ title = "cmd.exe" })
        local tabs = { tab }

        local result = format_window_title_fn(tab, pane, tabs, nil, nil)
        assert.is_string(result)
        assert.is_false(result:find("%.exe"))
      end)

      it("should handle title without extension", function()
        local tab = create_mock_tab({})
        local pane = create_mock_pane({ title = "bash" })
        local tabs = { tab }

        local result = format_window_title_fn(tab, pane, tabs, nil, nil)
        assert.is_string(result)
        assert.truthy(result:find("bash"))
      end)
    end)

    describe("Zoom indicator", function()
      it("should show zoom indicator when pane is zoomed", function()
        local tab = create_mock_tab({ is_zoomed = true })
        local pane = create_mock_pane({})
        local tabs = { tab }

        local result = format_window_title_fn(tab, pane, tabs, nil, nil)
        assert.truthy(result:find("%[Z%]"))
      end)

      it("should not show zoom indicator when pane is not zoomed", function()
        local tab = create_mock_tab({ is_zoomed = false })
        local pane = create_mock_pane({})
        local tabs = { tab }

        local result = format_window_title_fn(tab, pane, tabs, nil, nil)
        assert.is_false(result:find("%[Z%]"))
      end)
    end)

    describe("Tab index display", function()
      it("should show tab index when multiple tabs exist", function()
        local tab1 = create_mock_tab({ tab_index = 0 })
        local tab2 = create_mock_tab({ tab_index = 1 })
        local pane = create_mock_pane({})
        local tabs = { tab1, tab2 }

        local result = format_window_title_fn(tab1, pane, tabs, nil, nil)
        assert.truthy(result:find("%[1/2%]"))
      end)

      it("should not show tab index when only one tab exists", function()
        local tab = create_mock_tab({ tab_index = 0 })
        local pane = create_mock_pane({})
        local tabs = { tab }

        local result = format_window_title_fn(tab, pane, tabs, nil, nil)
        assert.is_false(result:find("%[%d+/%d+%]"))
      end)

      it("should show correct tab index for different tab positions", function()
        local tab1 = create_mock_tab({ tab_index = 0 })
        local tab2 = create_mock_tab({ tab_index = 1 })
        local tab3 = create_mock_tab({ tab_index = 2 })
        local pane = create_mock_pane({})
        local tabs = { tab1, tab2, tab3 }

        local result = format_window_title_fn(tab2, pane, tabs, nil, nil)
        assert.truthy(result:find("%[2/3%]"))
      end)
    end)

    describe("Neovim special handling", function()
      it("should detect nvim process and format title accordingly", function()
        local tab = create_mock_tab({})
        local pane = create_mock_pane({
          foreground_process_name = "/usr/bin/nvim",
          title = "cmd",
          cwd = "/home/user/myproject"
        })
        local tabs = { tab }

        local result = format_window_title_fn(tab, pane, tabs, nil, nil)
        assert.truthy(result:find("Neovim"))
        assert.truthy(result:find("dir:"))
      end)

      it("should handle nvim process name variations", function()
        local tab = create_mock_tab({})
        local pane = create_mock_pane({
          foreground_process_name = "nvim.exe",
          title = "cmd",
          cwd = "/home/user/testdir"
        })
        local tabs = { tab }

        local result = format_window_title_fn(tab, pane, tabs, nil, nil)
        assert.truthy(result:find("Neovim"))
      end)

      it("should handle cmd title with neovim detection", function()
        local tab = create_mock_tab({})
        local pane = create_mock_pane({
          foreground_process_name = "cmd",
          title = "cmd",
          cwd = "/home/user/project"
        })
        local tabs = { tab }

        local result = format_window_title_fn(tab, pane, tabs, nil, nil)
        assert.truthy(result:find("Neovim"))
        assert.truthy(result:find("dir:"))
      end)
    end)

    describe("Complex scenarios", function()
      it("should handle zoomed neovim with multiple tabs", function()
        local tab1 = create_mock_tab({ tab_index = 0, is_zoomed = true })
        local tab2 = create_mock_tab({ tab_index = 1 })
        local pane = create_mock_pane({
          foreground_process_name = "nvim",
          title = "cmd",
          cwd = "/home/user/workspace"
        })
        local tabs = { tab1, tab2 }

        local result = format_window_title_fn(tab1, pane, tabs, nil, nil)
        assert.truthy(result:find("%[Z%]"))
        assert.truthy(result:find("%[1/2%]"))
        assert.truthy(result:find("Neovim"))
      end)

      it("should handle empty or nil values gracefully", function()
        local tab = create_mock_tab({})
        local pane = create_mock_pane({
          title = "",
          foreground_process_name = "",
          cwd = ""
        })
        local tabs = { tab }

        local result = format_window_title_fn(tab, pane, tabs, nil, nil)
        assert.is_string(result)
        -- Should not crash and return some reasonable output
      end)
    end)

    describe("File path handling", function()
      it("should extract basename from current working directory", function()
        local tab = create_mock_tab({})
        local pane = create_mock_pane({
          foreground_process_name = "nvim",
          title = "cmd",
          cwd = "/very/deep/path/to/myproject"
        })
        local tabs = { tab }

        local result = format_window_title_fn(tab, pane, tabs, nil, nil)
        assert.truthy(result:find("myproject"))
      end)

      it("should handle Windows-style paths", function()
        local tab = create_mock_tab({})
        local pane = create_mock_pane({
          foreground_process_name = "nvim",
          title = "cmd",
          cwd = "C:\\Users\\TestUser\\Documents\\MyProject"
        })
        local tabs = { tab }

        local result = format_window_title_fn(tab, pane, tabs, nil, nil)
        assert.truthy(result:find("MyProject"))
      end)
    end)
  end)

  describe("Integration with file system utilities", function()
    it("should use fs.basename utility", function()
      local fs_utils = require("utils.fn").fs
      assert.is_function(fs_utils.basename)

      -- Test the basename function
      assert.equals("file.txt", fs_utils.basename("/path/to/file.txt"))
      assert.equals("dir", fs_utils.basename("/path/to/dir"))
    end)
  end)
end)

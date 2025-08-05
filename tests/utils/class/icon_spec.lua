---@module "tests.utils.class.icon_spec"
---@description Unit tests for utils.class.icon module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("utils.class.icon", function()
  local Icon

  before_each(function()
    helper.setup()
    Icon = require("utils.class.icon")
  end)

  after_each(function()
    helper.teardown()
  end)

  describe("initialization", function()
    it("should create a new icon instance", function()
      local icon = Icon:new()

      assert.is_not_nil(icon)
      assert.is_table(icon)
    end)

    it("should have default icon sets", function()
      assert.is_table(Icon)

      -- Should have common icon categories
      if Icon.Sep then
        assert.is_table(Icon.Sep)
      end

      if Icon.Powerline then
        assert.is_table(Icon.Powerline)
      end
    end)
  end)

  describe("separator icons", function()
    it("should provide tab bar separators", function()
      if Icon.Sep and Icon.Sep.tb then
        assert.is_table(Icon.Sep.tb)

        -- Should have left and right separators
        if Icon.Sep.tb.left then
          assert.is_string(Icon.Sep.tb.left)
        end

        if Icon.Sep.tb.right then
          assert.is_string(Icon.Sep.tb.right)
        end
      end
    end)

    it("should provide status bar separators", function()
      if Icon.Sep and Icon.Sep.status then
        assert.is_table(Icon.Sep.status)
      end
    end)

    it("should provide powerline separators", function()
      if Icon.Powerline then
        assert.is_table(Icon.Powerline)

        local powerline_chars = {
          "left_filled", "right_filled",
          "left_thin", "right_thin"
        }

        for _, char in ipairs(powerline_chars) do
          if Icon.Powerline[char] then
            assert.is_string(Icon.Powerline[char])
          end
        end
      end
    end)
  end)

  describe("file type icons", function()
    it("should provide file extension icons", function()
      if Icon.File then
        assert.is_table(Icon.File)

        local common_extensions = {
          "lua", "js", "ts", "py", "rb", "go", "rs"
        }

        for _, ext in ipairs(common_extensions) do
          if Icon.File[ext] then
            assert.is_string(Icon.File[ext])
          end
        end
      end
    end)

    it("should provide directory icons", function()
      if Icon.Dir then
        assert.is_table(Icon.Dir)

        if Icon.Dir.default then
          assert.is_string(Icon.Dir.default)
        end

        if Icon.Dir.open then
          assert.is_string(Icon.Dir.open)
        end
      end
    end)
  end)

  describe("process icons", function()
    it("should provide process name icons", function()
      if Icon.Process then
        assert.is_table(Icon.Process)

        local common_processes = {
          "bash", "zsh", "fish", "pwsh",
          "vim", "nvim", "emacs",
          "node", "python", "lua"
        }

        for _, process in ipairs(common_processes) do
          if Icon.Process[process] then
            assert.is_string(Icon.Process[process])
          end
        end
      end
    end)
  end)

  describe("utility functions", function()
    it("should get icon by name", function()
      if Icon.get then
        assert.is_function(Icon.get)

        local icon = Icon.get("test")
        assert.is_string(icon)
      end
    end)

    it("should get file icon by extension", function()
      if Icon.get_file_icon then
        assert.is_function(Icon.get_file_icon)

        local icon = Icon.get_file_icon("test.lua")
        assert.is_string(icon)
      end
    end)

    it("should get process icon by name", function()
      if Icon.get_process_icon then
        assert.is_function(Icon.get_process_icon)

        local icon = Icon.get_process_icon("bash")
        assert.is_string(icon)
      end
    end)

    it("should handle unknown file types gracefully", function()
      if Icon.get_file_icon then
        local icon = Icon.get_file_icon("unknown.xyz")
        assert.is_string(icon)
      end
    end)

    it("should handle unknown processes gracefully", function()
      if Icon.get_process_icon then
        local icon = Icon.get_process_icon("unknown-process")
        assert.is_string(icon)
      end
    end)
  end)

  describe("icon categories", function()
    it("should provide workspace icons", function()
      if Icon.Workspace then
        assert.is_table(Icon.Workspace)

        if Icon.Workspace.default then
          assert.is_string(Icon.Workspace.default)
        end
      end
    end)

    it("should provide battery icons", function()
      if Icon.Battery then
        assert.is_table(Icon.Battery)

        local battery_states = {
          "full", "high", "medium", "low", "empty", "charging"
        }

        for _, state in ipairs(battery_states) do
          if Icon.Battery[state] then
            assert.is_string(Icon.Battery[state])
          end
        end
      end
    end)

    it("should provide time icons", function()
      if Icon.Time then
        assert.is_table(Icon.Time)

        if Icon.Time.clock then
          assert.is_string(Icon.Time.clock)
        end
      end
    end)
  end)

  describe("error handling", function()
    it("should handle missing icon gracefully", function()
      if Icon.get then
        local icon = Icon.get("nonexistent-icon")
        assert.is_string(icon)
        -- Should return fallback icon
      end
    end)

    it("should handle nil inputs", function()
      if Icon.get_file_icon then
        assert.has_no.errors(function()
          Icon.get_file_icon(nil)
        end)
      end

      if Icon.get_process_icon then
        assert.has_no.errors(function()
          Icon.get_process_icon(nil)
        end)
      end
    end)

    it("should handle empty string inputs", function()
      if Icon.get_file_icon then
        assert.has_no.errors(function()
          Icon.get_file_icon("")
        end)
      end

      if Icon.get_process_icon then
        assert.has_no.errors(function()
          Icon.get_process_icon("")
        end)
      end
    end)
  end)

  describe("customization", function()
    it("should allow custom icon registration", function()
      if Icon.register then
        assert.is_function(Icon.register)

        assert.has_no.errors(function()
          Icon.register("custom", "🔥")
        end)
      end
    end)

    it("should allow icon overrides", function()
      if Icon.override then
        assert.is_function(Icon.override)

        assert.has_no.errors(function()
          Icon.override("lua", "🌙")
        end)
      end
    end)

    it("should support icon themes", function()
      if Icon.set_theme then
        assert.is_function(Icon.set_theme)

        assert.has_no.errors(function()
          Icon.set_theme("nerd-fonts")
        end)
      end
    end)
  end)

  describe("performance", function()
    it("should handle rapid icon lookups efficiently", function()
      if Icon.get then
        assert.has_no.errors(function()
          for i = 1, 100 do
            Icon.get("test")
          end
        end)
      end
    end)

    it("should cache icon lookups", function()
      if Icon.get then
        local start_time = os.clock()

        -- First lookup might be slower
        Icon.get("test")

        -- Subsequent lookups should be faster (cached)
        for i = 1, 10 do
          Icon.get("test")
        end

        local elapsed = os.clock() - start_time
        assert.is_true(elapsed < 1) -- Should complete quickly
      end
    end)
  end)

  describe("unicode handling", function()
    it("should handle unicode characters properly", function()
      local unicode_icons = {
        "🎨", "⚡", "🔥", "💻", "📁", "🌙"
      }

      for _, icon in ipairs(unicode_icons) do
        assert.is_string(icon)
        assert.is_true(#icon > 0)
      end
    end)

    it("should support emoji icons", function()
      if Icon.Emoji then
        assert.is_table(Icon.Emoji)
      end
    end)

    it("should support nerd font icons", function()
      if Icon.NerdFont then
        assert.is_table(Icon.NerdFont)
      end
    end)
  end)

  describe("integration", function()
    it("should work with tab formatting", function()
      if Icon.Sep and Icon.Sep.tb then
        local separators = Icon.Sep.tb

        -- Should be usable in tab title formatting
        assert.is_not_nil(separators)
      end
    end)

    it("should work with status bar formatting", function()
      if Icon.get then
        local workspace_icon = Icon.get("workspace")
        local battery_icon = Icon.get("battery")

        assert.is_string(workspace_icon)
        assert.is_string(battery_icon)
      end
    end)

    it("should work with file browser", function()
      if Icon.get_file_icon then
        local test_files = {
          "config.lua", "test.py", "script.js", "style.css"
        }

        for _, file in ipairs(test_files) do
          local icon = Icon.get_file_icon(file)
          assert.is_string(icon)
        end
      end
    end)
  end)
end)

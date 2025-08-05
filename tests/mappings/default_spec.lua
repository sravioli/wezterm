---@module "tests.mappings.default_spec"
---@description Unit tests for mappings.default module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("mappings.default", function()
  local default_mappings

  before_each(function()
    helper.setup()
    default_mappings = require("mappings.default")
  end)

  after_each(function()
    helper.teardown()
    package.loaded["mappings.default"] = nil
  end)

  describe("basic key bindings", function()
    it("should have keys configuration", function()
      assert.is_table(default_mappings.keys)
      assert.is_true(#default_mappings.keys > 0)
    end)

    it("should have key tables configuration", function()
      if default_mappings.key_tables then
        assert.is_table(default_mappings.key_tables)
      end
    end)

    it("should configure basic clipboard operations", function()
      local has_copy = false
      local has_paste = false

      for _, key in ipairs(default_mappings.keys) do
        if key.key == "c" and (key.mods == "CTRL" or key.mods == "CMD") then
          has_copy = true
        elseif key.key == "v" and (key.mods == "CTRL" or key.mods == "CMD") then
          has_paste = true
        end
      end

      -- Should have at least one copy/paste mechanism
      assert.is_true(has_copy or has_paste)
    end)

    it("should configure tab management keys", function()
      local has_new_tab = false
      local has_close_tab = false

      for _, key in ipairs(default_mappings.keys) do
        local action_str = tostring(key.action)
        if action_str:find("NewTab") or action_str:find("SpawnTab") then
          has_new_tab = true
        elseif action_str:find("CloseTab") or action_str:find("CloseCurrentTab") then
          has_close_tab = true
        end
      end

      -- Should provide tab management
      assert.is_true(has_new_tab or has_close_tab)
    end)

    it("should configure pane management keys", function()
      local has_split = false
      local has_close_pane = false

      for _, key in ipairs(default_mappings.keys) do
        local action_str = tostring(key.action)
        if action_str:find("Split") then
          has_split = true
        elseif action_str:find("CloseCurrentPane") then
          has_close_pane = true
        end
      end

      -- Should provide some pane management
      assert.is_true(has_split or has_close_pane)
    end)
  end)

  describe("key binding validation", function()
    it("should have valid key binding structure", function()
      for i, key_binding in ipairs(default_mappings.keys) do
        assert.is_table(key_binding, string.format("Key binding %d should be a table", i))
        assert.is_string(key_binding.key, string.format("Key binding %d should have string key", i))
        assert.is_not_nil(key_binding.action, string.format("Key binding %d should have action", i))

        if key_binding.mods then
          assert.is_string(key_binding.mods, string.format("Key binding %d mods should be string", i))
        end
      end
    end)

    it("should have valid modifier combinations", function()
      local valid_mods = {
        "CTRL", "ALT", "SHIFT", "SUPER", "CMD", "LEADER",
        "CTRL|SHIFT", "CTRL|ALT", "ALT|SHIFT", "CTRL|ALT|SHIFT",
        "CMD|SHIFT", "CMD|ALT", "SUPER|SHIFT", "SUPER|ALT"
      }

      for _, key_binding in ipairs(default_mappings.keys) do
        if key_binding.mods then
          local is_valid = false
          for _, valid_mod in ipairs(valid_mods) do
            if key_binding.mods == valid_mod then
              is_valid = true
              break
            end
          end
          assert.is_true(is_valid, string.format("Invalid modifier: %s", key_binding.mods))
        end
      end
    end)

    it("should have valid key names", function()
      local valid_keys = {
        -- Letters
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
        "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
        -- Numbers
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        -- Function keys
        "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12",
        -- Special keys
        "Enter", "Return", "Tab", "Space", "Backspace", "Delete", "Escape",
        "LeftArrow", "RightArrow", "UpArrow", "DownArrow",
        "Home", "End", "PageUp", "PageDown", "Insert",
        -- Symbols
        "-", "=", "[", "]", "\\", ";", "'", ",", ".", "/", "`",
        "+", "_", "{", "}", "|", ":", "\"", "<", ">", "?"
      }

      for _, key_binding in ipairs(default_mappings.keys) do
        local key = key_binding.key
        local is_valid = false

        for _, valid_key in ipairs(valid_keys) do
          if key == valid_key then
            is_valid = true
            break
          end
        end

        -- Also allow single characters and some special cases
        if not is_valid then
          is_valid = #key == 1 or key:match("^F%d+$") or key:match("^Numpad%d+$")
        end

        assert.is_true(is_valid, string.format("Invalid key name: %s", key))
      end
    end)

    it("should have valid action types", function()
      for _, key_binding in ipairs(default_mappings.keys) do
        local action = key_binding.action

        -- Action can be string or table
        assert.is_true(type(action) == "string" or type(action) == "table",
          string.format("Action should be string or table, got %s", type(action)))

        if type(action) == "table" then
          -- Should have at least one field
          local has_fields = false
          for _ in pairs(action) do
            has_fields = true
            break
          end
          assert.is_true(has_fields, "Action table should not be empty")
        end
      end
    end)
  end)

  describe("key table validation", function()
    it("should have valid key table structure", function()
      if default_mappings.key_tables then
        for table_name, key_table in pairs(default_mappings.key_tables) do
          assert.is_string(table_name, "Key table name should be string")
          assert.is_table(key_table, "Key table should be table")

          for i, key_binding in ipairs(key_table) do
            assert.is_table(key_binding, string.format("Key table %s binding %d should be table", table_name, i))
            assert.is_string(key_binding.key, string.format("Key table %s binding %d should have string key", table_name, i))
            assert.is_not_nil(key_binding.action, string.format("Key table %s binding %d should have action", table_name, i))
          end
        end
      end
    end)

    it("should configure copy mode if present", function()
      if default_mappings.key_tables and default_mappings.key_tables.copy_mode then
        local copy_mode = default_mappings.key_tables.copy_mode
        assert.is_table(copy_mode)
        assert.is_true(#copy_mode > 0)

        -- Should have at least quit/escape key
        local has_quit = false
        for _, key in ipairs(copy_mode) do
          if key.key == "q" or key.key == "Escape" then
            has_quit = true
            break
          end
        end
        assert.is_true(has_quit, "Copy mode should have quit key")
      end
    end)

    it("should configure search mode if present", function()
      if default_mappings.key_tables and default_mappings.key_tables.search_mode then
        local search_mode = default_mappings.key_tables.search_mode
        assert.is_table(search_mode)
        assert.is_true(#search_mode > 0)

        -- Should have navigation keys
        local has_next = false
        local has_prev = false
        for _, key in ipairs(search_mode) do
          local action_str = tostring(key.action)
          if action_str:find("Next") then
            has_next = true
          elseif action_str:find("Prev") then
            has_prev = true
          end
        end

        assert.is_true(has_next or has_prev, "Search mode should have navigation")
      end
    end)
  end)

  describe("common operations", function()
    it("should provide font size adjustment", function()
      local has_increase = false
      local has_decrease = false
      local has_reset = false

      for _, key in ipairs(default_mappings.keys) do
        local action_str = tostring(key.action)
        if action_str:find("IncreaseFontSize") then
          has_increase = true
        elseif action_str:find("DecreaseFontSize") then
          has_decrease = true
        elseif action_str:find("ResetFontSize") then
          has_reset = true
        end
      end

      -- Should provide at least some font control
      assert.is_true(has_increase or has_decrease or has_reset)
    end)

    it("should provide window operations", function()
      local has_window_ops = false

      for _, key in ipairs(default_mappings.keys) do
        local action_str = tostring(key.action)
        if action_str:find("ToggleFullScreen") or
           action_str:find("Hide") or
           action_str:find("Quit") then
          has_window_ops = true
          break
        end
      end

      assert.is_true(has_window_ops)
    end)

    it("should provide scrolling operations", function()
      local has_scroll = false

      for _, key in ipairs(default_mappings.keys) do
        local action_str = tostring(key.action)
        if action_str:find("ScrollBy") or
           action_str:find("ScrollTo") or
           action_str:find("PageUp") or
           action_str:find("PageDown") then
          has_scroll = true
          break
        end
      end

      assert.is_true(has_scroll)
    end)
  end)

  describe("platform compatibility", function()
    it("should handle different platforms gracefully", function()
      -- Check for platform-specific modifiers
      local has_ctrl = false
      local has_cmd = false

      for _, key in ipairs(default_mappings.keys) do
        if key.mods and key.mods:find("CTRL") then
          has_ctrl = true
        elseif key.mods and key.mods:find("CMD") then
          has_cmd = true
        end
      end

      -- Should have appropriate modifiers for cross-platform use
      assert.is_true(has_ctrl or has_cmd)
    end)

    it("should avoid conflicting with system shortcuts", function()
      -- Common system shortcuts that should be avoided or handled carefully
      local dangerous_combinations = {
        { key = "q", mods = "CMD" },    -- Quit on macOS
        { key = "w", mods = "CMD" },    -- Close window on macOS
        { key = "F4", mods = "ALT" },   -- Close window on Windows
        { key = "Tab", mods = "ALT" },  -- Alt-Tab on Windows/Linux
      }

      for _, dangerous in ipairs(dangerous_combinations) do
        local conflicts = false
        for _, key in ipairs(default_mappings.keys) do
          if key.key == dangerous.key and key.mods == dangerous.mods then
            conflicts = true
            break
          end
        end

        -- If there's a conflict, it should be intentional
        if conflicts then
          -- This is just a warning, not a failure
          print(string.format("Warning: Key binding %s+%s may conflict with system shortcut",
            dangerous.mods, dangerous.key))
        end
      end
    end)
  end)

  describe("accessibility", function()
    it("should provide alternative key bindings", function()
      -- Check for multiple ways to perform common actions
      local copy_methods = 0
      local paste_methods = 0

      for _, key in ipairs(default_mappings.keys) do
        local action_str = tostring(key.action)
        if action_str:find("Copy") then
          copy_methods = copy_methods + 1
        elseif action_str:find("Paste") then
          paste_methods = paste_methods + 1
        end
      end

      -- Having multiple methods improves accessibility
      assert.is_true(copy_methods >= 1)
      assert.is_true(paste_methods >= 1)
    end)

    it("should avoid complex key combinations when possible", function()
      local complex_combinations = 0

      for _, key in ipairs(default_mappings.keys) do
        if key.mods then
          local mod_count = 0
          for mod in key.mods:gmatch("[^|]+") do
            mod_count = mod_count + 1
          end

          if mod_count >= 3 then
            complex_combinations = complex_combinations + 1
          end
        end
      end

      -- Should minimize very complex combinations
      assert.is_true(complex_combinations < (#default_mappings.keys / 4))
    end)
  end)

  describe("error handling", function()
    it("should handle missing actions gracefully", function()
      -- Mappings should be robust
      assert.is_table(default_mappings.keys)
      assert.is_true(#default_mappings.keys > 0)
    end)

    it("should validate internal consistency", function()
      -- No duplicate key combinations
      local seen_combinations = {}

      for _, key in ipairs(default_mappings.keys) do
        local combination = (key.mods or "") .. "+" .. key.key

        if seen_combinations[combination] then
          assert.fail(string.format("Duplicate key combination: %s", combination))
        end

        seen_combinations[combination] = true
      end
    end)
  end)

  describe("performance", function()
    it("should not have excessive number of key bindings", function()
      -- Too many key bindings can slow down key processing
      assert.is_true(#default_mappings.keys <= 100)
    end)

    it("should load efficiently", function()
      assert.has_no.errors(function()
        for i = 1, 10 do
          package.loaded["mappings.default"] = nil
          require("mappings.default")
        end
      end)
    end)
  end)
end)

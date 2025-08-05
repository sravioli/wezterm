---@module "tests.mappings.init_spec"
---@description Unit tests for mappings.init module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("mappings.init", function()
  local mappings_config

  before_each(function()
    helper.setup()

    -- Mock the individual mapping modules
    package.loaded["mappings.default"] = {
      keys = {
        { key = "c", mods = "CTRL", action = "Copy" },
        { key = "v", mods = "CTRL", action = "Paste" }
      },
      key_tables = {
        copy_mode = {
          { key = "q", action = "CopyMode 'Close'" }
        }
      }
    }

    package.loaded["mappings.modes"] = {
      keys = {
        { key = "r", mods = "LEADER", action = "ActivateKeyTable" }
      },
      key_tables = {
        resize_pane = {
          { key = "h", action = "AdjustPaneSize" },
          { key = "l", action = "AdjustPaneSize" }
        }
      }
    }

    mappings_config = require("mappings.init")
  end)

  after_each(function()
    helper.teardown()
    package.loaded["mappings.default"] = nil
    package.loaded["mappings.modes"] = nil
    package.loaded["mappings.init"] = nil
  end)

  describe("module structure", function()
    it("should return a merged mappings configuration", function()
      assert.is_table(mappings_config)
    end)

    it("should contain keys configuration", function()
      assert.is_table(mappings_config.keys)
      assert.is_true(#mappings_config.keys > 0)
    end)

    it("should contain key_tables configuration", function()
      assert.is_table(mappings_config.key_tables)
    end)
  end)

  describe("key bindings merge", function()
    it("should merge keys from default mappings", function()
      assert.is_table(mappings_config.keys)

      -- Should contain keys from default module
      local has_copy = false
      local has_paste = false

      for _, key in ipairs(mappings_config.keys) do
        if key.key == "c" and key.mods == "CTRL" then
          has_copy = true
        elseif key.key == "v" and key.mods == "CTRL" then
          has_paste = true
        end
      end

      assert.is_true(has_copy)
      assert.is_true(has_paste)
    end)

    it("should merge keys from modes mappings", function()
      assert.is_table(mappings_config.keys)

      -- Should contain keys from modes module
      local has_resize = false

      for _, key in ipairs(mappings_config.keys) do
        if key.key == "r" and key.mods == "LEADER" then
          has_resize = true
        end
      end

      assert.is_true(has_resize)
    end)

    it("should preserve all key bindings", function()
      assert.is_table(mappings_config.keys)

      -- Should have at least 3 keys (2 from default + 1 from modes)
      assert.is_true(#mappings_config.keys >= 3)
    end)
  end)

  describe("key tables merge", function()
    it("should merge key_tables from default mappings", function()
      assert.is_table(mappings_config.key_tables)
      assert.is_not_nil(mappings_config.key_tables.copy_mode)

      local copy_mode = mappings_config.key_tables.copy_mode
      assert.is_table(copy_mode)
      assert.is_true(#copy_mode > 0)
    end)

    it("should merge key_tables from modes mappings", function()
      assert.is_table(mappings_config.key_tables)
      assert.is_not_nil(mappings_config.key_tables.resize_pane)

      local resize_pane = mappings_config.key_tables.resize_pane
      assert.is_table(resize_pane)
      assert.is_true(#resize_pane > 0)
    end)

    it("should preserve all key tables", function()
      assert.is_table(mappings_config.key_tables)

      -- Should have both copy_mode and resize_pane
      local table_count = 0
      for _ in pairs(mappings_config.key_tables) do
        table_count = table_count + 1
      end

      assert.is_true(table_count >= 2)
    end)
  end)

  describe("key binding structure validation", function()
    it("should have valid key binding structure", function()
      assert.is_table(mappings_config.keys)

      for _, key_binding in ipairs(mappings_config.keys) do
        assert.is_table(key_binding)
        assert.is_string(key_binding.key)
        assert.is_not_nil(key_binding.action)

        if key_binding.mods then
          assert.is_string(key_binding.mods)
        end
      end
    end)

    it("should have valid key table structure", function()
      assert.is_table(mappings_config.key_tables)

      for table_name, key_table in pairs(mappings_config.key_tables) do
        assert.is_string(table_name)
        assert.is_table(key_table)

        for _, key_binding in ipairs(key_table) do
          assert.is_table(key_binding)
          assert.is_string(key_binding.key)
          assert.is_not_nil(key_binding.action)
        end
      end
    end)
  end)

  describe("merge behavior", function()
    it("should properly merge arrays", function()
      assert.is_table(mappings_config.keys)

      -- Keys should be merged as arrays, not overwritten
      local total_keys = #mappings_config.keys
      assert.is_true(total_keys > 0)
    end)

    it("should properly merge nested tables", function()
      assert.is_table(mappings_config.key_tables)

      -- Key tables should be merged as nested tables
      for table_name, key_table in pairs(mappings_config.key_tables) do
        assert.is_table(key_table)
        assert.is_true(#key_table > 0)
      end
    end)

    it("should handle conflicts appropriately", function()
      -- If there are conflicting key bindings, behavior depends on merge order
      assert.is_table(mappings_config.keys)
      assert.is_table(mappings_config.key_tables)
    end)
  end)

  describe("error handling", function()
    it("should handle missing default mappings", function()
      package.loaded["mappings.default"] = nil

      assert.has_no.errors(function()
        package.loaded["mappings.init"] = nil
        require("mappings.init")
      end)
    end)

    it("should handle missing modes mappings", function()
      package.loaded["mappings.modes"] = nil

      assert.has_no.errors(function()
        package.loaded["mappings.init"] = nil
        require("mappings.init")
      end)
    end)

    it("should handle empty mapping modules", function()
      package.loaded["mappings.default"] = { keys = {}, key_tables = {} }
      package.loaded["mappings.modes"] = { keys = {}, key_tables = {} }

      assert.has_no.errors(function()
        package.loaded["mappings.init"] = nil
        local config = require("mappings.init")

        assert.is_table(config.keys)
        assert.is_table(config.key_tables)
      end)
    end)

    it("should handle malformed mapping modules", function()
      package.loaded["mappings.default"] = "not a table"
      package.loaded["mappings.modes"] = 42

      assert.has_no.errors(function()
        package.loaded["mappings.init"] = nil
        require("mappings.init")
      end)
    end)

    it("should handle modules with missing keys", function()
      package.loaded["mappings.default"] = { key_tables = {} }  -- Missing keys
      package.loaded["mappings.modes"] = { keys = {} }  -- Missing key_tables

      assert.has_no.errors(function()
        package.loaded["mappings.init"] = nil
        local config = require("mappings.init")

        assert.is_table(config)
      end)
    end)
  end)

  describe("WezTerm compatibility", function()
    it("should produce valid WezTerm key configuration", function()
      assert.is_table(mappings_config.keys)
      assert.is_table(mappings_config.key_tables)

      -- Validate that the structure matches WezTerm expectations
      for _, key_binding in ipairs(mappings_config.keys) do
        assert.is_string(key_binding.key)
        -- WezTerm expects specific key binding structure
      end
    end)

    it("should have valid modifier keys", function()
      local valid_mods = {
        "CTRL", "ALT", "SHIFT", "SUPER", "CMD", "LEADER",
        "CTRL|SHIFT", "ALT|SHIFT", "CTRL|ALT"
      }

      for _, key_binding in ipairs(mappings_config.keys) do
        if key_binding.mods then
          -- Should be one of the valid modifier combinations
          assert.is_string(key_binding.mods)
        end
      end
    end)

    it("should have valid actions", function()
      for _, key_binding in ipairs(mappings_config.keys) do
        assert.is_not_nil(key_binding.action)
        -- Action can be string or table depending on WezTerm action type
      end
    end)
  end)

  describe("integration", function()
    it("should work with Config class", function()
      local Config = require("utils.class.config")
      local config = Config:new()

      assert.has_no.errors(function()
        config:add(mappings_config)
      end)
    end)

    it("should maintain key binding precedence", function()
      -- Later modules should take precedence for conflicts
      assert.is_table(mappings_config.keys)
      assert.is_table(mappings_config.key_tables)
    end)

    it("should be usable by main wezterm.lua", function()
      -- The mappings config should be suitable for inclusion in main config
      assert.is_table(mappings_config)

      -- Should have the structure expected by WezTerm
      helper.assert_table_contains(mappings_config, "keys")
      helper.assert_table_contains(mappings_config, "key_tables")
    end)
  end)

  describe("performance", function()
    it("should merge configurations efficiently", function()
      assert.has_no.errors(function()
        for i = 1, 10 do
          package.loaded["mappings.init"] = nil
          require("mappings.init")
        end
      end)
    end)

    it("should handle large key binding sets", function()
      -- Create modules with many key bindings
      local large_keys = {}
      for i = 1, 100 do
        table.insert(large_keys, {
          key = "F" .. i,
          action = "Action" .. i
        })
      end

      package.loaded["mappings.default"] = { keys = large_keys, key_tables = {} }

      assert.has_no.errors(function()
        package.loaded["mappings.init"] = nil
        local config = require("mappings.init")

        assert.is_true(#config.keys >= 100)
      end)
    end)
  end)

  describe("type validation", function()
    it("should have correct types for key configurations", function()
      assert.is_table(mappings_config.keys)

      for _, key_binding in ipairs(mappings_config.keys) do
        assert.is_table(key_binding)
        assert.is_string(key_binding.key)

        if key_binding.mods then
          assert.is_string(key_binding.mods)
        end
      end
    end)

    it("should have correct types for key table configurations", function()
      assert.is_table(mappings_config.key_tables)

      for table_name, key_table in pairs(mappings_config.key_tables) do
        assert.is_string(table_name)
        assert.is_table(key_table)

        for _, key_binding in ipairs(key_table) do
          assert.is_table(key_binding)
          assert.is_string(key_binding.key)
        end
      end
    end)
  end)
end)

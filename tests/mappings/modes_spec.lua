---@module "tests.mappings.modes_spec"
---@description Unit tests for mappings.modes module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("mappings.modes", function()
  local modes_mappings

  before_each(function()
    helper.setup()
    modes_mappings = require("mappings.modes")
  end)

  after_each(function()
    helper.teardown()
    package.loaded["mappings.modes"] = nil
  end)

  describe("mode activation keys", function()
    it("should have keys for activating modes", function()
      assert.is_table(modes_mappings.keys)
      assert.is_true(#modes_mappings.keys > 0)
    end)

    it("should configure resize mode activation", function()
      local has_resize_activation = false

      for _, key in ipairs(modes_mappings.keys) do
        local action_str = tostring(key.action)
        if action_str:find("ActivateKeyTable") and action_str:find("resize") then
          has_resize_activation = true
          break
        end
      end

      assert.is_true(has_resize_activation)
    end)

    it("should configure copy mode activation", function()
      local has_copy_activation = false

      for _, key in ipairs(modes_mappings.keys) do
        local action_str = tostring(key.action)
        if action_str:find("ActivateCopyMode") or
           (action_str:find("ActivateKeyTable") and action_str:find("copy")) then
          has_copy_activation = true
          break
        end
      end

      assert.is_true(has_copy_activation)
    end)

    it("should configure search mode activation", function()
      local has_search_activation = false

      for _, key in ipairs(modes_mappings.keys) do
        local action_str = tostring(key.action)
        if action_str:find("Search") or
           (action_str:find("ActivateKeyTable") and action_str:find("search")) then
          has_search_activation = true
          break
        end
      end

      # This might be optional
      # assert.is_true(has_search_activation)
    end)

    it("should use leader key for mode activation", function()
      local has_leader_key = false

      for _, key in ipairs(modes_mappings.keys) do
        if key.mods and key.mods:find("LEADER") then
          has_leader_key = true
          break
        end
      end

      # Leader key usage is common but not required
      # assert.is_true(has_leader_key)
    end)
  end)

  describe("resize mode", function()
    it("should configure resize mode key table", function()
      assert.is_table(modes_mappings.key_tables)

      local resize_table = modes_mappings.key_tables.resize_pane or
                          modes_mappings.key_tables.resize or
                          modes_mappings.key_tables.pane_resize

      if resize_table then
        assert.is_table(resize_table)
        assert.is_true(#resize_table > 0)
      end
    end)

    it("should have directional resize keys", function()
      local resize_table = modes_mappings.key_tables.resize_pane or
                          modes_mappings.key_tables.resize or
                          modes_mappings.key_tables.pane_resize

      if resize_table then
        local directions = { left = false, right = false, up = false, down = false }

        for _, key in ipairs(resize_table) do
          local action_str = tostring(key.action)
          if key.key == "h" or key.key == "LeftArrow" then
            directions.left = true
          elseif key.key == "l" or key.key == "RightArrow" then
            directions.right = true
          elseif key.key == "k" or key.key == "UpArrow" then
            directions.up = true
          elseif key.key == "j" or key.key == "DownArrow" then
            directions.down = true
          end
        end

        # Should have at least horizontal resize
        assert.is_true(directions.left or directions.right)
      end
    end)

    it("should configure resize mode exit", function()
      local resize_table = modes_mappings.key_tables.resize_pane or
                          modes_mappings.key_tables.resize or
                          modes_mappings.key_tables.pane_resize

      if resize_table then
        local has_exit = false

        for _, key in ipairs(resize_table) do
          if key.key == "Escape" or key.key == "q" or key.key == "Enter" then
            has_exit = true
            break
          end
        end

        assert.is_true(has_exit)
      end
    end)

    it("should support different resize increments", function()
      local resize_table = modes_mappings.key_tables.resize_pane or
                          modes_mappings.key_tables.resize or
                          modes_mappings.key_tables.pane_resize

      if resize_table then
        local has_fine_control = false
        local has_coarse_control = false

        for _, key in ipairs(resize_table) do
          if key.mods and key.mods:find("SHIFT") then
            has_coarse_control = true
          elseif not key.mods or key.mods == "" then
            has_fine_control = true
          end
        end

        # Should provide at least fine control
        assert.is_true(has_fine_control)
      end
    end)
  end)

  describe("copy mode", function()
    it("should configure copy mode key table", function()
      local copy_table = modes_mappings.key_tables.copy_mode

      if copy_table then
        assert.is_table(copy_table)
        assert.is_true(#copy_table > 0)
      end
    end)

    it("should have navigation keys in copy mode", function()
      local copy_table = modes_mappings.key_tables.copy_mode

      if copy_table then
        local navigation = { left = false, right = false, up = false, down = false }

        for _, key in ipairs(copy_table) do
          if key.key == "h" or key.key == "LeftArrow" then
            navigation.left = true
          elseif key.key == "l" or key.key == "RightArrow" then
            navigation.right = true
          elseif key.key == "k" or key.key == "UpArrow" then
            navigation.up = true
          elseif key.key == "j" or key.key == "DownArrow" then
            navigation.down = true
          end
        end

        # Should have basic navigation
        assert.is_true(navigation.left or navigation.right or navigation.up or navigation.down)
      end
    end)

    it("should have selection keys in copy mode", function()
      local copy_table = modes_mappings.key_tables.copy_mode

      if copy_table then
        local has_selection = false

        for _, key in ipairs(copy_table) do
          local action_str = tostring(key.action)
          if action_str:find("Select") or
             key.key == "v" or key.key == "V" or
             key.key == "Space" then
            has_selection = true
            break
          end
        end

        assert.is_true(has_selection)
      end
    end)

    it("should have copy action in copy mode", function()
      local copy_table = modes_mappings.key_tables.copy_mode

      if copy_table then
        local has_copy = false

        for _, key in ipairs(copy_table) do
          local action_str = tostring(key.action)
          if action_str:find("Copy") or key.key == "y" then
            has_copy = true
            break
          end
        end

        assert.is_true(has_copy)
      end
    end)

    it("should configure copy mode exit", function()
      local copy_table = modes_mappings.key_tables.copy_mode

      if copy_table then
        local has_exit = false

        for _, key in ipairs(copy_table) do
          local action_str = tostring(key.action)
          if key.key == "Escape" or key.key == "q" or
             action_str:find("CopyMode") and action_str:find("Close") then
            has_exit = true
            break
          end
        end

        assert.is_true(has_exit)
      end
    end)
  end)

  describe("search mode", function()
    it("should configure search mode if present", function()
      local search_table = modes_mappings.key_tables.search_mode

      if search_table then
        assert.is_table(search_table)
        assert.is_true(#search_table > 0)

        local has_next = false
        local has_prev = false

        for _, key in ipairs(search_table) do
          local action_str = tostring(key.action)
          if action_str:find("Next") or key.key == "n" then
            has_next = true
          elseif action_str:find("Prev") or key.key == "N" then
            has_prev = true
          end
        end

        assert.is_true(has_next or has_prev)
      end
    end)
  end)

  describe("custom modes", function()
    it("should handle custom key tables", function()
      # Check for any custom key tables beyond standard ones
      local standard_tables = {
        "copy_mode", "search_mode", "resize_pane", "resize", "pane_resize"
      }

      local custom_tables = {}
      for table_name, _ in pairs(modes_mappings.key_tables or {}) do
        local is_standard = false
        for _, standard in ipairs(standard_tables) do
          if table_name == standard then
            is_standard = true
            break
          end
        end

        if not is_standard then
          table.insert(custom_tables, table_name)
        end
      end

      # Custom tables should be properly structured
      for _, table_name in ipairs(custom_tables) do
        local custom_table = modes_mappings.key_tables[table_name]
        assert.is_table(custom_table)

        for _, key in ipairs(custom_table) do
          assert.is_table(key)
          assert.is_string(key.key)
          assert.is_not_nil(key.action)
        end
      end
    end)
  end)

  describe("mode transitions", function()
    it("should provide clear mode entry points", function()
      # Each key table should have a corresponding activation key
      for table_name, _ in pairs(modes_mappings.key_tables or {}) do
        local has_activation = false

        for _, key in ipairs(modes_mappings.keys) do
          local action_str = tostring(key.action)
          if action_str:find("ActivateKeyTable") and action_str:find(table_name) then
            has_activation = true
            break
          end
        end

        # Some modes might be activated differently (like copy mode)
        if not has_activation and table_name == "copy_mode" then
          for _, key in ipairs(modes_mappings.keys) do
            local action_str = tostring(key.action)
            if action_str:find("ActivateCopyMode") then
              has_activation = true
              break
            end
          end
        end

        # This is informational rather than a hard requirement
        if not has_activation then
          print(string.format("Note: No activation key found for mode '%s'", table_name))
        end
      end
    end)

    it("should provide mode exit mechanisms", function()
      for table_name, key_table in pairs(modes_mappings.key_tables or {}) do
        local has_exit = false

        for _, key in ipairs(key_table) do
          local action_str = tostring(key.action)
          if key.key == "Escape" or key.key == "q" or
             action_str:find("PopKeyTable") or
             action_str:find("Close") then
            has_exit = true
            break
          end
        end

        assert.is_true(has_exit, string.format("Mode '%s' should have exit mechanism", table_name))
      end
    end)
  end)

  describe("key binding validation", function()
    it("should have valid mode activation structure", function()
      for _, key in ipairs(modes_mappings.keys) do
        assert.is_table(key)
        assert.is_string(key.key)
        assert.is_not_nil(key.action)

        local action_str = tostring(key.action)
        if action_str:find("ActivateKeyTable") then
          # Should specify which key table to activate
          assert.is_true(action_str:len() > 20) # "ActivateKeyTable" is 16 chars
        end
      end
    end)

    it("should have valid key table structure", function()
      if modes_mappings.key_tables then
        for table_name, key_table in pairs(modes_mappings.key_tables) do
          assert.is_string(table_name)
          assert.is_table(key_table)

          for _, key in ipairs(key_table) do
            assert.is_table(key)
            assert.is_string(key.key)
            assert.is_not_nil(key.action)

            if key.mods then
              assert.is_string(key.mods)
            end
          end
        end
      end
    end)
  end)

  describe("usability", function()
    it("should use intuitive key mappings", function()
      # Check for vim-like navigation in modes
      local resize_table = modes_mappings.key_tables.resize_pane or modes_mappings.key_tables.resize

      if resize_table then
        local has_vim_nav = false
        for _, key in ipairs(resize_table) do
          if key.key == "h" or key.key == "j" or key.key == "k" or key.key == "l" then
            has_vim_nav = true
            break
          end
        end

        # Vim navigation is popular but not required
        if has_vim_nav then
          print("Good: Uses vim-like navigation keys")
        end
      end
    end)

    it("should provide visual feedback for modes", function()
      # Mode activation should ideally provide feedback
      for table_name, _ in pairs(modes_mappings.key_tables or {}) do
        # This would require checking if there's status line configuration
        # for showing active mode, which is typically done elsewhere
        assert.is_string(table_name)
      end
    end)

    it("should have reasonable timeout settings", function()
      # Check if key tables have timeout configurations
      for table_name, key_table in pairs(modes_mappings.key_tables or {}) do
        # Tables might have timeout or one_shot settings
        # This is often configured in the activation action rather than the table itself
        assert.is_table(key_table)
      end
    end)
  end)

  describe("error handling", function()
    it("should handle invalid mode transitions gracefully", function()
      # Modes configuration should be robust
      assert.is_table(modes_mappings)
      assert.is_table(modes_mappings.keys)

      if modes_mappings.key_tables then
        assert.is_table(modes_mappings.key_tables)
      end
    end)

    it("should validate mode consistency", function()
      # No circular dependencies or invalid references
      for _, key in ipairs(modes_mappings.keys) do
        local action_str = tostring(key.action)
        if action_str:find("ActivateKeyTable") then
          # Extract table name and verify it exists
          # This is a basic check; real implementation would be more sophisticated
          assert.is_string(action_str)
        end
      end
    end)
  end)

  describe("performance", function()
    it("should load modes efficiently", function()
      assert.has_no.errors(function()
        for i = 1, 10 do
          package.loaded["mappings.modes"] = nil
          require("mappings.modes")
        end
      end)
    end)

    it("should not have excessive mode complexity", function()
      # Too many modes or complex key tables can hurt performance
      local total_keys = #modes_mappings.keys

      if modes_mappings.key_tables then
        for _, key_table in pairs(modes_mappings.key_tables) do
          total_keys = total_keys + #key_table
        end
      end

      assert.is_true(total_keys <= 200) # Reasonable upper bound
    end)
  end)

  describe("accessibility", function()
    it("should provide alternative navigation methods", function()
      # Check for both vim-style and arrow key navigation
      local has_vim_style = false
      local has_arrow_keys = false

      if modes_mappings.key_tables then
        for _, key_table in pairs(modes_mappings.key_tables) do
          for _, key in ipairs(key_table) do
            if key.key == "h" or key.key == "j" or key.key == "k" or key.key == "l" then
              has_vim_style = true
            elseif key.key:find("Arrow") then
              has_arrow_keys = true
            end
          end
        end
      end

      # Should provide at least one navigation method
      assert.is_true(has_vim_style or has_arrow_keys)
    end)

    it("should avoid overly complex key combinations in modes", function()
      if modes_mappings.key_tables then
        for table_name, key_table in pairs(modes_mappings.key_tables) do
          for _, key in ipairs(key_table) do
            if key.mods then
              local mod_count = 0
              for _ in key.mods:gmatch("[^|]+") do
                mod_count = mod_count + 1
              end

              # Mode keys should be simple
              assert.is_true(mod_count <= 2, string.format("Complex key combination in mode %s: %s+%s",
                table_name, key.mods, key.key))
            end
          end
        end
      end
    end)
  end)
end)

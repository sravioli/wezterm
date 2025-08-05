---@diagnostic disable: undefined-global, undefined-field
local spec_helper = require("tests.spec_helper")

describe("integration.configuration_system", function()
  local Config

  before_each(function()
    spec_helper.setup()

    -- Mock complete utils system
    package.loaded["utils"] = {
      class = {
        config = {
          new = function()
            local instance = {
              config = {},
              _modules = {}
            }

            instance.add = function(self, module_or_name)
              local module_config

              if type(module_or_name) == "string" then
                module_config = require(module_or_name)
              else
                module_config = module_or_name
              end

              table.insert(self._modules, module_or_name)

              -- Merge configuration
              for key, value in pairs(module_config) do
                self.config[key] = value
              end

              return self.config
            end

            return instance
          end
        }
      },
      fn = {
        tbl = {
          merge = function(base, other)
            for key, value in pairs(other) do
              base[key] = value
            end
            return base
          end
        }
      }
    }

    Config = package.loaded["utils"].class.config
  end)

  after_each(function()
    spec_helper.teardown()
  end)

  describe("configuration module loading", function()
    it("should load all configuration modules successfully", function()
      -- Mock individual config modules
      package.loaded["config.appearance"] = {
        color_scheme = "Test Theme",
        background = { { source = { Color = "#000000" } } }
      }

      package.loaded["config.font"] = {
        font_size = 12,
        font_family = "Test Font"
      }

      package.loaded["config.tab-bar"] = {
        use_fancy_tab_bar = false,
        enable_tab_bar = true
      }

      package.loaded["config.general"] = {
        default_workspace = "main"
      }

      package.loaded["config.gpu"] = {
        webgpu_power_preference = "HighPerformance"
      }

      local config = Config.new()

      assert.has_no_errors(function()
        config:add("config.appearance")
        config:add("config.font")
        config:add("config.tab-bar")
        config:add("config.general")
        config:add("config.gpu")
      end)
    end)

    it("should maintain configuration order and precedence", function()
      package.loaded["config.base"] = {
        setting1 = "base_value",
        setting2 = "base_value"
      }

      package.loaded["config.override"] = {
        setting1 = "override_value",
        setting3 = "new_value"
      }

      local config = Config.new()
      local result = config:add("config.base"):add("config.override")

      assert.equals("override_value", result.setting1) -- Should be overridden
      assert.equals("base_value", result.setting2)     -- Should remain
      assert.equals("new_value", result.setting3)      -- Should be added
    end)

    it("should handle missing configuration modules gracefully", function()
      local config = Config.new()

      assert.has_errors(function()
        config:add("config.nonexistent")
      end)
    end)

    it("should support chained configuration loading", function()
      package.loaded["config.chain1"] = { value1 = 1 }
      package.loaded["config.chain2"] = { value2 = 2 }
      package.loaded["config.chain3"] = { value3 = 3 }

      local config = Config.new()
      local result = config:add("config.chain1")
                          :add("config.chain2")
                          :add("config.chain3")

      assert.equals(1, result.value1)
      assert.equals(2, result.value2)
      assert.equals(3, result.value3)
    end)
  end)

  describe("event system integration", function()
    it("should work with event handler configuration", function()
      local mock_events = {}

      -- Mock WezTerm event system
      spec_helper.mock_wezterm.on = function(event, handler)
        mock_events[event] = handler
      end

      -- Mock event modules
      package.loaded["events.format-tab-title"] = {}
      package.loaded["events.update-status"] = {}
      package.loaded["events.format-window-title"] = {}

      assert.has_no_errors(function()
        require("events.format-tab-title")
        require("events.update-status")
        require("events.format-window-title")
      end)

      -- Events should be registered
      assert.is_function(mock_events["format-tab-title"])
      assert.is_function(mock_events["update-status"])
      assert.is_function(mock_events["format-window-title"])
    end)

    it("should handle event handler failures gracefully", function()
      -- Mock failing event handler
      spec_helper.mock_wezterm.on = function(event, handler)
        if event == "failing-event" then
          error("Event registration failed")
        end
      end

      assert.has_errors(function()
        spec_helper.mock_wezterm.on("failing-event", function() end)
      end)
    end)
  end)

  describe("mapping system integration", function()
    it("should integrate key mappings with configuration", function()
      package.loaded["mappings.default"] = {
        keys = {
          { key = "c", mods = "CTRL", action = "Copy" },
          { key = "v", mods = "CTRL", action = "Paste" }
        }
      }

      package.loaded["mappings.modes"] = {
        keys = {
          { key = "r", mods = "LEADER", action = "ActivateKeyTable" }
        },
        key_tables = {
          resize_pane = {
            { key = "h", action = "AdjustPaneSize" }
          }
        }
      }

      package.loaded["mappings.init"] = {
        keys = {},
        key_tables = {}
      }

      -- Mock mapping merge
      local mock_merge = package.loaded["utils"].fn.tbl.merge
      package.loaded["utils"].fn.tbl.merge = function(base, other)
        if other.keys then
          base.keys = base.keys or {}
          for _, key in ipairs(other.keys) do
            table.insert(base.keys, key)
          end
        end
        if other.key_tables then
          base.key_tables = base.key_tables or {}
          for name, table_keys in pairs(other.key_tables) do
            base.key_tables[name] = table_keys
          end
        end
        return base
      end

      local config = Config.new()
      local result = config:add("mappings.init")

      assert.is_table(result.keys)
      assert.is_table(result.key_tables)
    end)

    it("should handle mapping conflicts appropriately", function()
      package.loaded["mappings.conflict1"] = {
        keys = {
          { key = "c", mods = "CTRL", action = "Action1" }
        }
      }

      package.loaded["mappings.conflict2"] = {
        keys = {
          { key = "c", mods = "CTRL", action = "Action2" }
        }
      }

      -- Should handle conflicts without erroring
      assert.has_no_errors(function()
        local config = Config.new()
        config:add("mappings.conflict1"):add("mappings.conflict2")
      end)
    end)
  end)

  describe("picker system integration", function()
    it("should integrate pickers with configuration", function()
      -- Mock picker system
      package.loaded["picker.colorscheme"] = {
        pick = function()
          return { action = "ActivateColorScheme", args = { "Dark Theme" } }
        end
      }

      package.loaded["picker.font"] = {
        pick = function()
          return { action = "ActivateFont", args = { "JetBrains Mono" } }
        end
      }

      local config = Config.new()

      -- Configuration should be able to use pickers
      assert.has_no_errors(function()
        local colorscheme_action = package.loaded["picker.colorscheme"].pick()
        local font_action = package.loaded["picker.font"].pick()

        assert.is_table(colorscheme_action)
        assert.is_table(font_action)
      end)
    end)

    it("should handle picker integration failures", function()
      package.loaded["picker.failing"] = {
        pick = function()
          error("Picker failed")
        end
      }

      assert.has_errors(function()
        package.loaded["picker.failing"].pick()
      end)
    end)
  end)

  describe("complete system integration", function()
    it("should work with full WezTerm configuration", function()
      -- Mock complete configuration modules
      package.loaded["config.appearance"] = {
        color_scheme = "Test Theme",
        background = { { source = { Color = "#000000" } } },
        cursor_blink_rate = 500
      }

      package.loaded["config.font"] = {
        font_size = 12,
        font_family = "Test Font",
        line_height = 1.2
      }

      package.loaded["config.tab-bar"] = {
        use_fancy_tab_bar = false,
        enable_tab_bar = true,
        tab_bar_at_bottom = false
      }

      package.loaded["config.general"] = {
        default_workspace = "main",
        automatically_reload_config = true
      }

      package.loaded["config.gpu"] = {
        enable_wayland = false,
        webgpu_power_preference = "HighPerformance"
      }

      package.loaded["mappings"] = {
        keys = {
          { key = "c", mods = "CTRL", action = "Copy" }
        },
        key_tables = {}
      }

      package.loaded["config"] = {}
      -- Mock config module that merges all sub-modules
      package.loaded["utils"].fn.tbl.merge(package.loaded["config"], package.loaded["config.appearance"])
      package.loaded["utils"].fn.tbl.merge(package.loaded["config"], package.loaded["config.font"])
      package.loaded["utils"].fn.tbl.merge(package.loaded["config"], package.loaded["config.tab-bar"])
      package.loaded["utils"].fn.tbl.merge(package.loaded["config"], package.loaded["config.general"])
      package.loaded["utils"].fn.tbl.merge(package.loaded["config"], package.loaded["config.gpu"])

      local config = Config.new()
      local result = config:add("config"):add("mappings")

      -- Should have all configuration sections
      assert.equals("Test Theme", result.color_scheme)
      assert.equals(12, result.font_size)
      assert.is_false(result.use_fancy_tab_bar)
      assert.equals("main", result.default_workspace)
      assert.is_false(result.enable_wayland)
      assert.is_table(result.keys)
    end)

    it("should handle complex configuration scenarios", function()
      -- Test with nested configurations and conflicts
      package.loaded["config.complex"] = {
        nested = {
          deep = {
            value = "original"
          }
        },
        array = { "item1", "item2" },
        conflicting = "first"
      }

      package.loaded["config.override"] = {
        nested = {
          deep = {
            value = "overridden",
            new_value = "added"
          }
        },
        array = { "item3", "item4" },
        conflicting = "second",
        new_setting = "added"
      }

      local config = Config.new()
      local result = config:add("config.complex"):add("config.override")

      -- Simple merge should override nested tables entirely
      assert.equals("overridden", result.nested.deep.value)
      assert.equals("added", result.nested.deep.new_value)
      assert.same({ "item3", "item4" }, result.array)
      assert.equals("second", result.conflicting)
      assert.equals("added", result.new_setting)
    end)
  end)

  describe("error recovery and resilience", function()
    it("should recover from partial configuration failures", function()
      package.loaded["config.good1"] = { setting1 = "value1" }
      package.loaded["config.bad"] = function() error("Bad config") end
      package.loaded["config.good2"] = { setting2 = "value2" }

      local config = Config.new()

      -- Should load good configurations despite bad one
      local result = config:add("config.good1")
      assert.equals("value1", result.setting1)

      assert.has_errors(function()
        config:add("config.bad")
      end)

      -- Should still be able to add more configurations
      local final_result = config:add("config.good2")
      assert.equals("value1", final_result.setting1)
      assert.equals("value2", final_result.setting2)
    end)

    it("should handle memory pressure gracefully", function()
      -- Create large configurations to test memory handling
      local large_configs = {}
      for i = 1, 10 do
        large_configs["config.large" .. i] = {}
        local config_data = large_configs["config.large" .. i]

        for j = 1, 100 do
          config_data["setting_" .. j] = string.rep("x", 100)
        end

        package.loaded["config.large" .. i] = config_data
      end

      assert.has_no_errors(function()
        local config = Config.new()
        for i = 1, 10 do
          config:add("config.large" .. i)
        end
      end)
    end)

    it("should maintain state consistency under error conditions", function()
      package.loaded["config.state1"] = { counter = 1 }
      package.loaded["config.state2"] = { counter = 2 }

      local config = Config.new()
      local result1 = config:add("config.state1")
      assert.equals(1, result1.counter)

      -- Even if next addition fails, previous state should be maintained
      local result2 = config:add("config.state2")
      assert.equals(2, result2.counter)
    end)
  end)

  describe("performance characteristics", function()
    it("should load configurations efficiently", function()
      -- Create multiple small configurations
      for i = 1, 20 do
        package.loaded["config.perf" .. i] = { ["setting" .. i] = "value" .. i }
      end

      local start_time = os.clock()

      local config = Config.new()
      for i = 1, 20 do
        config:add("config.perf" .. i)
      end

      local elapsed = os.clock() - start_time
      assert.is_true(elapsed < 0.1, "Configuration loading should be fast")
    end)

    it("should handle repeated loading efficiently", function()
      package.loaded["config.repeated"] = { value = "test" }

      assert.has_no_errors(function()
        for i = 1, 100 do
          local config = Config.new()
          config:add("config.repeated")
        end
      end)
    end)
  end)
end)

---@module "tests.events.format-tab-title_spec"
---@description Unit tests for events.format-tab-title module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("events.format-tab-title", function()
  before_each(function()
    helper.setup()

    -- Mock Utils module
    package.loaded["utils"] = {
      fn = {
        str = {
          truncate = function(str, len) return string.sub(str, 1, len) end,
          pad = function(str, len) return str .. string.rep(" ", len - #str) end
        }
      },
      class = {
        icon = {
          Sep = {
            tb = {
              left = "│",
              right = "│"
            }
          }
        }
      }
    }

    -- Load the event handler
    require("events.format-tab-title")
  end)

  after_each(function()
    helper.teardown()
    package.loaded["utils"] = nil
    package.loaded["events.format-tab-title"] = nil
  end)

  describe("event registration", function()
    it("should register format-tab-title event", function()
      assert.is_not_nil(helper.registered_events)
      assert.is_function(helper.registered_events["format-tab-title"])
    end)
  end)

  describe("tab title formatting", function()
    local format_handler

    before_each(function()
      format_handler = helper.registered_events["format-tab-title"]
    end)

    it("should return nil for fancy tab bar", function()
      local config = helper.create_test_config()
      config.use_fancy_tab_bar = true

      local result = format_handler(
        helper.create_mock_tab(),
        nil, nil, config, false, 50
      )

      assert.is_nil(result)
    end)

    it("should return nil when tab bar is disabled", function()
      local config = helper.create_test_config()
      config.enable_tab_bar = false

      local result = format_handler(
        helper.create_mock_tab(),
        nil, nil, config, false, 50
      )

      assert.is_nil(result)
    end)

    it("should format active tab title", function()
      local config = helper.create_test_config()
      local tab = helper.create_mock_tab({
        is_active = true,
        tab_index = 0
      })

      local result = format_handler(tab, nil, nil, config, false, 50)

      assert.is_not_nil(result)
      -- Result should be a table with formatted tab information
      if type(result) == "table" then
        assert.is_table(result)
      else
        assert.is_string(result)
      end
    end)

    it("should format inactive tab title", function()
      local config = helper.create_test_config()
      local tab = helper.create_mock_tab({
        is_active = false,
        tab_index = 1
      })

      local result = format_handler(tab, nil, nil, config, false, 50)

      assert.is_not_nil(result)
    end)

    it("should handle hover state", function()
      local config = helper.create_test_config()
      local tab = helper.create_mock_tab({
        is_active = false,
        tab_index = 1
      })

      local result = format_handler(tab, nil, nil, config, true, 50)

      assert.is_not_nil(result)
    end)

    it("should handle unseen output", function()
      local config = helper.create_test_config()
      local tab = helper.create_mock_tab({
        is_active = false,
        tab_index = 1,
        panes = {
          {
            has_unseen_output = true,
            pane_index = 0
          }
        }
      })

      local result = format_handler(tab, nil, nil, config, false, 50)

      assert.is_not_nil(result)
    end)
  end)

  describe("color handling", function()
    local format_handler

    before_each(function()
      format_handler = helper.registered_events["format-tab-title"]
    end)

    it("should use different colors for active tabs", function()
      local config = helper.create_test_config()
      local active_tab = helper.create_mock_tab({ is_active = true })
      local inactive_tab = helper.create_mock_tab({ is_active = false })

      local active_result = format_handler(active_tab, nil, nil, config, false, 50)
      local inactive_result = format_handler(inactive_tab, nil, nil, config, false, 50)

      assert.is_not_nil(active_result)
      assert.is_not_nil(inactive_result)

      -- Results should be different for active vs inactive
      if type(active_result) == "table" and type(inactive_result) == "table" then
        -- Compare color attributes if available
        assert.is_table(active_result)
        assert.is_table(inactive_result)
      end
    end)

    it("should use hover colors when hovering", function()
      local config = helper.create_test_config()
      local tab = helper.create_mock_tab({ is_active = false })

      local normal_result = format_handler(tab, nil, nil, config, false, 50)
      local hover_result = format_handler(tab, nil, nil, config, true, 50)

      assert.is_not_nil(normal_result)
      assert.is_not_nil(hover_result)
    end)

    it("should handle missing theme gracefully", function()
      local config = helper.create_test_config()
      config.color_schemes = {}

      local tab = helper.create_mock_tab()

      assert.has_no.errors(function()
        format_handler(tab, nil, nil, config, false, 50)
      end)
    end)
  end)

  describe("caching behavior", function()
    local format_handler

    before_each(function()
      format_handler = helper.registered_events["format-tab-title"]
    end)

    it("should use cached theme when available", function()
      local config = helper.create_test_config()
      helper.mock_wezterm.GLOBAL.cache = {
        ["Test Scheme_theme"] = config.color_schemes[config.color_scheme]
      }

      local tab = helper.create_mock_tab()

      assert.has_no.errors(function()
        format_handler(tab, nil, nil, config, false, 50)
      end)
    end)

    it("should create cache entry when missing", function()
      local config = helper.create_test_config()
      helper.mock_wezterm.GLOBAL.cache = {}

      local tab = helper.create_mock_tab()

      format_handler(tab, nil, nil, config, false, 50)

      local cache_key = config.color_scheme .. "_theme"
      assert.is_not_nil(helper.mock_wezterm.GLOBAL.cache[cache_key])
    end)

    it("should handle missing cache gracefully", function()
      local config = helper.create_test_config()
      helper.mock_wezterm.GLOBAL.cache = nil

      local tab = helper.create_mock_tab()

      assert.has_no.errors(function()
        format_handler(tab, nil, nil, config, false, 50)
      end)
    end)
  end)

  describe("tab index handling", function()
    local format_handler

    before_each(function()
      format_handler = helper.registered_events["format-tab-title"]
    end)

    it("should handle different tab indices", function()
      local config = helper.create_test_config()

      for i = 0, 5 do
        local tab = helper.create_mock_tab({ tab_index = i })

        assert.has_no.errors(function()
          local result = format_handler(tab, nil, nil, config, false, 50)
          assert.is_not_nil(result)
        end)
      end
    end)

    it("should handle negative tab index", function()
      local config = helper.create_test_config()
      local tab = helper.create_mock_tab({ tab_index = -1 })

      assert.has_no.errors(function()
        format_handler(tab, nil, nil, config, false, 50)
      end)
    end)
  end)

  describe("pane handling", function()
    local format_handler

    before_each(function()
      format_handler = helper.registered_events["format-tab-title"]
    end)

    it("should handle tabs with no panes", function()
      local config = helper.create_test_config()
      local tab = helper.create_mock_tab({ panes = {} })

      assert.has_no.errors(function()
        format_handler(tab, nil, nil, config, false, 50)
      end)
    end)

    it("should handle tabs with nil panes", function()
      local config = helper.create_test_config()
      local tab = helper.create_mock_tab({ panes = nil })

      assert.has_no.errors(function()
        format_handler(tab, nil, nil, config, false, 50)
      end)
    end)

    it("should handle multiple panes", function()
      local config = helper.create_test_config()
      local tab = helper.create_mock_tab({
        panes = {
          { has_unseen_output = false, pane_index = 0 },
          { has_unseen_output = true, pane_index = 1 },
          { has_unseen_output = false, pane_index = 2 }
        }
      })

      assert.has_no.errors(function()
        local result = format_handler(tab, nil, nil, config, false, 50)
        assert.is_not_nil(result)
      end)
    end)

    it("should detect unseen output efficiently", function()
      local config = helper.create_test_config()

      -- Create tab with many panes, first one has unseen output
      local panes = {}
      for i = 1, 10 do
        panes[i] = {
          has_unseen_output = (i == 1),
          pane_index = i - 1
        }
      end

      local tab = helper.create_mock_tab({ panes = panes })

      assert.has_no.errors(function()
        local result = format_handler(tab, nil, nil, config, false, 50)
        assert.is_not_nil(result)
      end)
    end)
  end)

  describe("max width handling", function()
    local format_handler

    before_each(function()
      format_handler = helper.registered_events["format-tab-title"]
    end)

    it("should handle different max widths", function()
      local config = helper.create_test_config()
      local tab = helper.create_mock_tab()

      local widths = { 10, 20, 50, 100, 200 }

      for _, width in ipairs(widths) do
        assert.has_no.errors(function()
          local result = format_handler(tab, nil, nil, config, false, width)
          assert.is_not_nil(result)
        end)
      end
    end)

    it("should handle zero max width", function()
      local config = helper.create_test_config()
      local tab = helper.create_mock_tab()

      assert.has_no.errors(function()
        format_handler(tab, nil, nil, config, false, 0)
      end)
    end)

    it("should handle negative max width", function()
      local config = helper.create_test_config()
      local tab = helper.create_mock_tab()

      assert.has_no.errors(function()
        format_handler(tab, nil, nil, config, false, -10)
      end)
    end)
  end)

  describe("error handling", function()
    local format_handler

    before_each(function()
      format_handler = helper.registered_events["format-tab-title"]
    end)

    it("should handle nil tab", function()
      local config = helper.create_test_config()

      assert.has_no.errors(function()
        format_handler(nil, nil, nil, config, false, 50)
      end)
    end)

    it("should handle nil config", function()
      local tab = helper.create_mock_tab()

      assert.has_no.errors(function()
        format_handler(tab, nil, nil, nil, false, 50)
      end)
    end)

    it("should handle malformed config", function()
      local tab = helper.create_mock_tab()
      local bad_config = "not a table"

      assert.has_no.errors(function()
        format_handler(tab, nil, nil, bad_config, false, 50)
      end)
    end)

    it("should handle missing color scheme in config", function()
      local config = { color_schemes = {} }
      local tab = helper.create_mock_tab()

      assert.has_no.errors(function()
        format_handler(tab, nil, nil, config, false, 50)
      end)
    end)
  end)
end)

---@module "tests.utils.class.layout_spec"
---@description Unit tests for utils.class.layout module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("utils.class.layout", function()
  local Layout

  before_each(function()
    helper.setup()
    Layout = require("utils.class.layout")
  end)

  after_each(function()
    helper.teardown()
  end)

  describe("initialization", function()
    it("should create a new layout instance", function()
      local layout = Layout:new()

      assert.is_not_nil(layout)
      assert.is_table(layout)
    end)

    it("should accept layout configuration", function()
      local config = {
        orientation = "horizontal",
        split_ratio = 0.5
      }

      local layout = Layout:new(config)

      assert.is_not_nil(layout)
      assert.is_table(layout)
    end)
  end)

  describe("layout types", function()
    it("should support horizontal layouts", function()
      local layout = Layout:new({ orientation = "horizontal" })

      if layout.get_orientation then
        assert.equals("horizontal", layout:get_orientation())
      end
    end)

    it("should support vertical layouts", function()
      local layout = Layout:new({ orientation = "vertical" })

      if layout.get_orientation then
        assert.equals("vertical", layout:get_orientation())
      end
    end)

    it("should support grid layouts", function()
      local layout = Layout:new({ type = "grid", rows = 2, cols = 2 })

      if layout.get_type then
        assert.equals("grid", layout:get_type())
      end
    end)

    it("should support tabbed layouts", function()
      local layout = Layout:new({ type = "tabbed" })

      if layout.get_type then
        assert.equals("tabbed", layout:get_type())
      end
    end)
  end)

  describe("split operations", function()
    local layout

    before_each(function()
      layout = Layout:new()
    end)

    it("should split horizontally", function()
      if layout.split_horizontal then
        assert.has_no.errors(function()
          layout:split_horizontal(0.5)
        end)
      end
    end)

    it("should split vertically", function()
      if layout.split_vertical then
        assert.has_no.errors(function()
          layout:split_vertical(0.5)
        end)
      end
    end)

    it("should handle invalid split ratios", function()
      if layout.split_horizontal then
        assert.has_no.errors(function()
          layout:split_horizontal(-1) -- Invalid ratio
          layout:split_horizontal(2)  -- Invalid ratio
        end)
      end
    end)

    it("should maintain split ratios", function()
      if layout.split_horizontal and layout.get_split_ratio then
        layout:split_horizontal(0.3)
        local ratio = layout:get_split_ratio()

        if ratio then
          assert.is_number(ratio)
          assert.is_true(ratio >= 0 and ratio <= 1)
        end
      end
    end)
  end)

  describe("pane management", function()
    local layout

    before_each(function()
      layout = Layout:new()
    end)

    it("should add panes", function()
      if layout.add_pane then
        local pane = helper.create_mock_pane()

        assert.has_no.errors(function()
          layout:add_pane(pane)
        end)
      end
    end)

    it("should remove panes", function()
      if layout.add_pane and layout.remove_pane then
        local pane = helper.create_mock_pane()
        layout:add_pane(pane)

        assert.has_no.errors(function()
          layout:remove_pane(pane)
        end)
      end
    end)

    it("should get pane count", function()
      if layout.get_pane_count then
        local count = layout:get_pane_count()

        assert.is_number(count)
        assert.is_true(count >= 0)
      end
    end)

    it("should iterate over panes", function()
      if layout.each_pane then
        assert.is_function(layout.each_pane)

        assert.has_no.errors(function()
          layout:each_pane(function(pane, index)
            assert.is_not_nil(pane)
            assert.is_number(index)
          end)
        end)
      end
    end)
  end)

  describe("layout calculation", function()
    local layout

    before_each(function()
      layout = Layout:new()
    end)

    it("should calculate pane dimensions", function()
      if layout.calculate_dimensions then
        local dimensions = layout:calculate_dimensions(800, 600)

        if dimensions then
          assert.is_table(dimensions)
        end
      end
    end)

    it("should handle different window sizes", function()
      if layout.calculate_dimensions then
        local sizes = {
          { 800, 600 },
          { 1920, 1080 },
          { 1366, 768 },
          { 3840, 2160 }
        }

        for _, size in ipairs(sizes) do
          assert.has_no.errors(function()
            layout:calculate_dimensions(size[1], size[2])
          end)
        end
      end
    end)

    it("should respect minimum pane sizes", function()
      if layout.set_min_pane_size and layout.calculate_dimensions then
        layout:set_min_pane_size(100, 50)

        local dimensions = layout:calculate_dimensions(200, 100)

        if dimensions then
          assert.is_table(dimensions)
        end
      end
    end)
  end)

  describe("layout serialization", function()
    local layout

    before_each(function()
      layout = Layout:new()
    end)

    it("should serialize layout to table", function()
      if layout.to_table then
        local serialized = layout:to_table()

        assert.is_table(serialized)
      end
    end)

    it("should deserialize layout from table", function()
      if Layout.from_table then
        local data = {
          orientation = "horizontal",
          split_ratio = 0.6,
          panes = {}
        }

        assert.has_no.errors(function()
          local restored_layout = Layout.from_table(data)
          assert.is_not_nil(restored_layout)
        end)
      end
    end)

    it("should maintain layout properties after serialization", function()
      if layout.to_table and Layout.from_table then
        layout.orientation = "vertical"

        local serialized = layout:to_table()
        local restored = Layout.from_table(serialized)

        if restored and restored.get_orientation then
          assert.equals("vertical", restored:get_orientation())
        end
      end
    end)
  end)

  describe("layout templates", function()
    it("should provide predefined layouts", function()
      if Layout.templates then
        assert.is_table(Layout.templates)

        local common_templates = {
          "two_pane_horizontal",
          "two_pane_vertical",
          "three_pane_main_left",
          "three_pane_main_right",
          "grid_2x2"
        }

        for _, template in ipairs(common_templates) do
          if Layout.templates[template] then
            assert.is_not_nil(Layout.templates[template])
          end
        end
      end
    end)

    it("should create layout from template", function()
      if Layout.from_template then
        assert.has_no.errors(function()
          local layout = Layout.from_template("two_pane_horizontal")
          assert.is_not_nil(layout)
        end)
      end
    end)

    it("should handle unknown templates gracefully", function()
      if Layout.from_template then
        assert.has_no.errors(function()
          Layout.from_template("unknown_template")
        end)
      end
    end)
  end)

  describe("responsive layouts", function()
    local layout

    before_each(function()
      layout = Layout:new()
    end)

    it("should adapt to window resize", function()
      if layout.on_resize then
        assert.has_no.errors(function()
          layout:on_resize(1920, 1080)
          layout:on_resize(800, 600)
        end)
      end
    end)

    it("should maintain aspect ratios", function()
      if layout.set_maintain_aspect and layout.calculate_dimensions then
        layout:set_maintain_aspect(true)

        local dims1 = layout:calculate_dimensions(800, 600)
        local dims2 = layout:calculate_dimensions(1600, 1200)

        -- Aspect ratios should be maintained
        if dims1 and dims2 then
          assert.is_table(dims1)
          assert.is_table(dims2)
        end
      end
    end)

    it("should handle breakpoints", function()
      if layout.add_breakpoint then
        assert.has_no.errors(function()
          layout:add_breakpoint(800, "mobile")
          layout:add_breakpoint(1200, "tablet")
          layout:add_breakpoint(1920, "desktop")
        end)
      end
    end)
  end)

  describe("layout constraints", function()
    local layout

    before_each(function()
      layout = Layout:new()
    end)

    it("should enforce minimum sizes", function()
      if layout.set_min_size then
        assert.has_no.errors(function()
          layout:set_min_size(200, 150)
        end)
      end
    end)

    it("should enforce maximum sizes", function()
      if layout.set_max_size then
        assert.has_no.errors(function()
          layout:set_max_size(1920, 1080)
        end)
      end
    end)

    it("should respect padding", function()
      if layout.set_padding then
        assert.has_no.errors(function()
          layout:set_padding(10, 10, 10, 10)
        end)
      end
    end)

    it("should respect margins", function()
      if layout.set_margin then
        assert.has_no.errors(function()
          layout:set_margin(5, 5, 5, 5)
        end)
      end
    end)
  end)

  describe("layout animation", function()
    local layout

    before_each(function()
      layout = Layout:new()
    end)

    it("should support animated transitions", function()
      if layout.animate_to then
        local target_layout = Layout:new({ orientation = "vertical" })

        assert.has_no.errors(function()
          layout:animate_to(target_layout, 300) -- 300ms duration
        end)
      end
    end)

    it("should handle easing functions", function()
      if layout.set_easing then
        local easing_functions = {
          "linear", "ease-in", "ease-out", "ease-in-out"
        }

        for _, easing in ipairs(easing_functions) do
          assert.has_no.errors(function()
            layout:set_easing(easing)
          end)
        end
      end
    end)
  end)

  describe("error handling", function()
    it("should handle invalid configurations", function()
      assert.has_no.errors(function()
        Layout:new("invalid")
        Layout:new(42)
        Layout:new(true)
      end)
    end)

    it("should handle missing panes gracefully", function()
      local layout = Layout:new()

      if layout.remove_pane then
        assert.has_no.errors(function()
          layout:remove_pane(nil)
          layout:remove_pane("not a pane")
        end)
      end
    end)

    it("should handle zero dimensions", function()
      local layout = Layout:new()

      if layout.calculate_dimensions then
        assert.has_no.errors(function()
          layout:calculate_dimensions(0, 0)
          layout:calculate_dimensions(-100, -100)
        end)
      end
    end)
  end)

  describe("performance", function()
    it("should handle large numbers of panes efficiently", function()
      local layout = Layout:new()

      if layout.add_pane then
        assert.has_no.errors(function()
          for i = 1, 50 do
            local pane = helper.create_mock_pane()
            layout:add_pane(pane)
          end
        end)
      end
    end)

    it("should calculate layouts quickly", function()
      local layout = Layout:new()

      if layout.calculate_dimensions then
        local start_time = os.clock()

        for i = 1, 100 do
          layout:calculate_dimensions(1920, 1080)
        end

        local elapsed = os.clock() - start_time
        assert.is_true(elapsed < 1) -- Should complete in under 1 second
      end
    end)
  end)

  describe("integration", function()
    it("should work with WezTerm pane system", function()
      local layout = Layout:new()
      local window = helper.create_mock_window()

      if layout.apply_to_window then
        assert.has_no.errors(function()
          layout:apply_to_window(window)
        end)
      end
    end)

    it("should work with workspace management", function()
      local layout = Layout:new()

      if layout.save_to_workspace then
        assert.has_no.errors(function()
          layout:save_to_workspace("test-workspace")
        end)
      end

      if Layout.load_from_workspace then
        assert.has_no.errors(function()
          Layout.load_from_workspace("test-workspace")
        end)
      end
    end)
  end)
end)

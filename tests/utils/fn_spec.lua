---@module "tests.utils.fn_spec"
---@description Unit tests for utils.fn module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("utils.fn", function()
  local fn

  before_each(function()
    helper.setup()
    fn = require("utils.fn")
  end)

  after_each(function()
    helper.teardown()
  end)

  describe("table utilities", function()
    describe("tbl.merge", function()
      it("should merge two simple tables", function()
        local base = { a = 1, b = 2 }
        local other = { b = 3, c = 4 }

        local result = fn.tbl.merge(base, other)

        assert.equals(1, result.a)
        assert.equals(3, result.b)  -- should overwrite
        assert.equals(4, result.c)
        assert.equals(base, result)  -- should modify in place
      end)

      it("should merge nested tables recursively", function()
        local base = {
          a = 1,
          nested = { x = 1, y = 2 }
        }
        local other = {
          nested = { y = 3, z = 4 },
          b = 2
        }

        local result = fn.tbl.merge(base, other)

        assert.equals(1, result.a)
        assert.equals(2, result.b)
        assert.equals(1, result.nested.x)
        assert.equals(3, result.nested.y)  -- should overwrite
        assert.equals(4, result.nested.z)
      end)

      it("should handle multiple tables", function()
        local base = { a = 1 }
        local second = { b = 2 }
        local third = { c = 3 }

        local result = fn.tbl.merge(base, second, third)

        assert.equals(1, result.a)
        assert.equals(2, result.b)
        assert.equals(3, result.c)
      end)

      it("should handle empty tables", function()
        local base = { a = 1 }
        local empty = {}

        local result = fn.tbl.merge(base, empty)

        assert.equals(1, result.a)
        assert.same(base, result)
      end)

      it("should overwrite non-table values with table values", function()
        local base = { a = "string" }
        local other = { a = { nested = "table" } }

        local result = fn.tbl.merge(base, other)

        assert.is_table(result.a)
        assert.equals("table", result.a.nested)
      end)
    end)

    describe("tbl.cartesian", function()
      it("should compute cartesian product of two sets", function()
        local sets = {
          { "a", "b" },
          { 1, 2 }
        }

        local result = fn.tbl.cartesian(sets)

        assert.equals(4, #result)
        assert.same({ "a", 1 }, result[1])
        assert.same({ "a", 2 }, result[2])
        assert.same({ "b", 1 }, result[3])
        assert.same({ "b", 2 }, result[4])
      end)

      it("should handle empty sets", function()
        local sets = {}
        local result = fn.tbl.cartesian(sets)
        assert.is_table(result)
      end)

      it("should handle single set", function()
        local sets = { { "a", "b", "c" } }
        local result = fn.tbl.cartesian(sets)

        assert.equals(3, #result)
        assert.same({ "a" }, result[1])
        assert.same({ "b" }, result[2])
        assert.same({ "c" }, result[3])
      end)
    end)
  end)

  describe("string utilities", function()
    describe("str functions", function()
      it("should provide string utility functions", function()
        assert.is_table(fn.str)
        -- Add more specific string function tests as needed
      end)
    end)
  end)

  describe("filesystem utilities", function()
    describe("fs functions", function()
      it("should provide filesystem utility functions", function()
        assert.is_table(fn.fs)
        -- Add more specific filesystem function tests as needed
      end)
    end)
  end)

  describe("color utilities", function()
    describe("color functions", function()
      it("should provide color utility functions", function()
        assert.is_table(fn.color)
        -- Test color scheme retrieval
        if fn.color.get_schemes then
          local schemes = fn.color.get_schemes()
          assert.is_table(schemes)
        end
      end)
    end)
  end)

  describe("icon utilities", function()
    describe("icon functions", function()
      it("should provide icon utility functions", function()
        assert.is_table(fn.icon)
        -- Add more specific icon function tests as needed
      end)
    end)
  end)

  describe("math utilities", function()
    describe("math functions", function()
      it("should provide math utility functions", function()
        assert.is_table(fn.math)
        -- Add more specific math function tests as needed
      end)
    end)
  end)

  describe("module structure", function()
    it("should have the expected structure", function()
      assert.is_table(fn)
      assert.is_table(fn.tbl)
      assert.is_function(fn.tbl.merge)
      assert.is_function(fn.tbl.cartesian)
    end)

    it("should be properly documented", function()
      -- Verify that key functions exist and are callable
      assert.is_function(fn.tbl.merge)
      assert.is_function(fn.tbl.cartesian)
    end)
  end)
end)

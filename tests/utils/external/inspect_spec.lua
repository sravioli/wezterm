---@diagnostic disable: undefined-global, undefined-field
local spec_helper = require("tests.spec_helper")

describe("utils.external.inspect", function()
  local inspect

  before_each(function()
    spec_helper.setup()

    -- Load the inspect module
    inspect = require("utils.external.inspect")
  end)

  after_each(function()
    spec_helper.teardown()
  end)

  describe("module structure", function()
    it("should be a function", function()
      assert.is_function(inspect)
    end)

    it("should have version information", function()
      assert.is_string(inspect._VERSION)
      assert.truthy(inspect._VERSION:match("inspect%.lua"))
    end)

    it("should have URL and description", function()
      assert.is_string(inspect._URL)
      assert.is_string(inspect._DESCRIPTION)
      assert.is_string(inspect._LICENSE)
    end)

    it("should have special marker objects", function()
      assert.is_not_nil(inspect.KEY)
      assert.is_not_nil(inspect.METATABLE)
    end)
  end)

  describe("basic inspection", function()
    it("should inspect simple values", function()
      assert.equals('"hello"', inspect("hello"))
      assert.equals("42", inspect(42))
      assert.equals("true", inspect(true))
      assert.equals("false", inspect(false))
      assert.equals("nil", inspect(nil))
    end)

    it("should inspect simple tables", function()
      local result = inspect({ a = 1, b = 2 })

      assert.is_string(result)
      assert.truthy(result:match("{"))
      assert.truthy(result:match("}"))
      assert.truthy(result:match("a"))
      assert.truthy(result:match("b"))
    end)

    it("should handle empty tables", function()
      local result = inspect({})
      assert.equals("{}", result)
    end)

    it("should handle arrays", function()
      local result = inspect({ "a", "b", "c" })

      assert.is_string(result)
      assert.truthy(result:match('"a"'))
      assert.truthy(result:match('"b"'))
      assert.truthy(result:match('"c"'))
    end)
  end)

  describe("complex data structures", function()
    it("should handle nested tables", function()
      local nested = {
        level1 = {
          level2 = {
            value = "deep"
          }
        }
      }

      local result = inspect(nested)

      assert.is_string(result)
      assert.truthy(result:match("level1"))
      assert.truthy(result:match("level2"))
      assert.truthy(result:match("deep"))
    end)

    it("should handle mixed key types", function()
      local mixed = {
        [1] = "numeric",
        string_key = "string",
        [true] = "boolean"
      }

      local result = inspect(mixed)

      assert.is_string(result)
      assert.truthy(result:match("numeric"))
      assert.truthy(result:match("string_key"))
    end)

    it("should handle functions", function()
      local with_function = {
        func = function() return "test" end
      }

      local result = inspect(with_function)

      assert.is_string(result)
      assert.truthy(result:match("function"))
    end)
  end)

  describe("special cases", function()
    it("should handle circular references", function()
      local circular = { name = "parent" }
      circular.self = circular

      assert.has_no_errors(function()
        local result = inspect(circular)
        assert.is_string(result)
      end)
    end)

    it("should handle metatables", function()
      local obj = { value = 1 }
      local mt = { __tostring = function() return "custom" end }
      setmetatable(obj, mt)

      local result = inspect(obj)

      assert.is_string(result)
      assert.truthy(result:match("metatable"))
    end)

    it("should handle string escaping", function()
      local special_strings = {
        "hello\nworld",
        "quote\"test",
        "tab\there",
        "backslash\\test"
      }

      for _, str in ipairs(special_strings) do
        local result = inspect(str)
        assert.is_string(result)
        assert.truthy(result:match('"'))
      end
    end)
  end)

  describe("options", function()
    it("should respect depth option", function()
      local deep = {
        l1 = { l2 = { l3 = { l4 = "deep" } } }
      }

      local shallow = inspect(deep, { depth = 2 })
      local deeper = inspect(deep, { depth = 4 })

      assert.is_string(shallow)
      assert.is_string(deeper)
      -- Shallow should have less detail than deeper
      assert.is_true(#shallow < #deeper)
    end)

    it("should respect indent option", function()
      local data = { a = { b = 1 } }

      local default_indent = inspect(data)
      local custom_indent = inspect(data, { indent = "    " })

      assert.is_string(default_indent)
      assert.is_string(custom_indent)
    end)

    it("should respect newline option", function()
      local data = { a = 1, b = 2 }

      local default_newline = inspect(data)
      local custom_newline = inspect(data, { newline = "\r\n" })

      assert.is_string(default_newline)
      assert.is_string(custom_newline)
    end)

    it("should handle process option", function()
      local data = { secret = "hidden", public = "visible" }

      local processed = inspect(data, {
        process = function(item, path)
          if type(item) == "table" then
            local result = {}
            for k, v in pairs(item) do
              if k ~= "secret" then
                result[k] = v
              end
            end
            return result
          end
          return item
        end
      })

      assert.is_string(processed)
      assert.truthy(processed:match("visible"))
      assert.falsy(processed:match("hidden"))
    end)
  end)

  describe("performance", function()
    it("should handle large tables efficiently", function()
      local large_table = {}
      for i = 1, 100 do
        large_table[i] = { id = i, data = string.rep("x", 10) }
      end

      assert.has_no_errors(function()
        local result = inspect(large_table)
        assert.is_string(result)
      end)
    end)

    it("should not hang on deep nesting", function()
      local deep = {}
      local current = deep
      for i = 1, 50 do
        current.next = { level = i }
        current = current.next
      end

      assert.has_no_errors(function()
        local result = inspect(deep, { depth = 10 })
        assert.is_string(result)
      end)
    end)
  end)

  describe("callable interface", function()
    it("should work as callable table", function()
      -- inspect can be called as a function due to __call metamethod
      local result = inspect({ test = "value" })
      assert.is_string(result)
    end)

    it("should work with inspect.inspect explicitly", function()
      local result = inspect.inspect({ test = "value" })
      assert.is_string(result)
    end)
  end)

  describe("integration with WezTerm configuration", function()
    it("should inspect WezTerm configuration objects", function()
      local wezterm_config = {
        color_scheme = "Test Scheme",
        font_size = 12,
        keys = {
          { key = "c", mods = "CTRL", action = "Copy" }
        }
      }

      local result = inspect(wezterm_config)

      assert.is_string(result)
      assert.truthy(result:match("color_scheme"))
      assert.truthy(result:match("font_size"))
      assert.truthy(result:match("keys"))
    end)

    it("should handle picker configurations", function()
      local picker_config = {
        title = "Test Picker",
        items = {
          { id = "item1", label = "Item 1" },
          { id = "item2", label = "Item 2" }
        },
        on_select = function() end
      }

      local result = inspect(picker_config)

      assert.is_string(result)
      assert.truthy(result:match("title"))
      assert.truthy(result:match("items"))
    end)

    it("should inspect logger output for debugging", function()
      local log_entry = {
        level = "INFO",
        timestamp = "2023-01-01T00:00:00",
        message = "Test message",
        module = "test.module"
      }

      local result = inspect(log_entry)

      assert.is_string(result)
      assert.truthy(result:match("INFO"))
      assert.truthy(result:match("Test message"))
    end)
  end)

  describe("error handling", function()
    it("should handle userdata gracefully", function()
      -- Userdata might be present in WezTerm context
      assert.has_no_errors(function()
        inspect(io.stdout) -- userdata example
      end)
    end)

    it("should handle thread objects", function()
      assert.has_no_errors(function()
        local thread = coroutine.create(function() end)
        inspect(thread)
      end)
    end)

    it("should handle invalid options gracefully", function()
      assert.has_no_errors(function()
        inspect({ test = 1 }, { invalid_option = true })
      end)
    end)
  end)
end)

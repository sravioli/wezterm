---@diagnostic disable: undefined-global, undefined-field
local spec_helper = require("tests.spec_helper")

describe("utils.init", function()
  local utils

  before_each(function()
    spec_helper.setup()
    -- Clear require cache for fresh module loading
    package.loaded["utils"] = nil
    package.loaded["utils.class"] = nil
    package.loaded["utils.fn"] = nil
    package.loaded["utils.gpu"] = nil
    package.loaded["utils.perf"] = nil
    utils = require("utils")
  end)

  after_each(function()
    spec_helper.teardown()
  end)

  describe("module structure", function()
    it("should be a table", function()
      assert.is_table(utils)
    end)

    it("should have metatable for lazy loading", function()
      local mt = getmetatable(utils)
      assert.is_table(mt)
      assert.is_function(mt.__index)
    end)
  end)

  describe("lazy loading", function()
    it("should load class module on first access", function()
      local class_module = utils.class
      assert.is_table(class_module)
      -- Should be cached now
      assert.equals(class_module, utils.class)
    end)

    it("should load fn module on first access", function()
      local fn_module = utils.fn
      assert.is_table(fn_module)
      -- Should be cached now
      assert.equals(fn_module, utils.fn)
    end)

    it("should load gpu module on first access", function()
      local gpu_module = utils.gpu
      assert.is_table(gpu_module)
      -- Should be cached now
      assert.equals(gpu_module, utils.gpu)
    end)

    it("should load perf module on first access", function()
      local perf_module = utils.perf
      assert.is_table(perf_module)
      -- Should be cached now
      assert.equals(perf_module, utils.perf)
    end)
  end)

  describe("module caching", function()
    it("should cache loaded modules", function()
      local class1 = utils.class
      local class2 = utils.class
      assert.equals(class1, class2)
    end)

    it("should work with multiple modules", function()
      local class_module = utils.class
      local fn_module = utils.fn
      local gpu_module = utils.gpu

      -- Second access should return cached versions
      assert.equals(class_module, utils.class)
      assert.equals(fn_module, utils.fn)
      assert.equals(gpu_module, utils.gpu)
    end)
  end)

  describe("error handling", function()
    it("should handle invalid module requests gracefully", function()
      -- This might throw an error depending on implementation
      -- We test that the mechanism doesn't break
      local ok, result = pcall(function()
        return utils.nonexistent
      end)

      -- Either succeeds with nil or fails with proper error
      if ok then
        assert.is_nil(result)
      else
        assert.is_string(result)
      end
    end)
  end)

  describe("integration", function()
    it("should provide access to all expected submodules", function()
      local expected_modules = { "class", "fn", "gpu", "perf" }

      for _, module_name in ipairs(expected_modules) do
        local module_obj = utils[module_name]
        assert.is_table(module_obj, "Expected " .. module_name .. " to be a table")
      end
    end)

    it("should maintain separate namespace for each module", function()
      local class_module = utils.class
      local fn_module = utils.fn

      assert.not_equals(class_module, fn_module)
      assert.is_table(class_module)
      assert.is_table(fn_module)
    end)
  end)
end)

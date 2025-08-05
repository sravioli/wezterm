---@module "tests.utils.class.logger_spec"
---@description Unit tests for utils.class.logger module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("utils.class.logger", function()
  local Logger

  before_each(function()
    helper.setup()
    Logger = require("utils.class.logger")
  end)

  after_each(function()
    helper.teardown()
  end)

  describe("initialization", function()
    it("should create a new logger instance", function()
      local logger = Logger:new("TestLogger")

      assert.is_not_nil(logger)
      assert.equals("TestLogger", logger.identifier)
      assert.is_boolean(logger.enabled)
      assert.is_number(logger.log_level)
    end)

    it("should have default configuration", function()
      local logger = Logger:new("TestLogger")

      assert.is_true(logger.enabled)
      assert.is_number(logger.log_level)
    end)

    it("should accept custom configuration", function()
      local logger = Logger:new("TestLogger", { enabled = false, log_level = 2 })

      assert.equals("TestLogger", logger.identifier)
      assert.is_false(logger.enabled)
      assert.equals(2, logger.log_level)
    end)
  end)

  describe("log levels", function()
    local logger

    before_each(function()
      logger = Logger:new("TestLogger")
    end)

    it("should have debug method", function()
      assert.is_function(logger.debug)

      -- Should not error when called
      assert.has_no.errors(function()
        logger:debug("Debug message")
      end)
    end)

    it("should have info method", function()
      assert.is_function(logger.info)

      assert.has_no.errors(function()
        logger:info("Info message")
      end)
    end)

    it("should have warn method", function()
      assert.is_function(logger.warn)

      assert.has_no.errors(function()
        logger:warn("Warning message")
      end)
    end)

    it("should have error method", function()
      assert.is_function(logger.error)

      assert.has_no.errors(function()
        logger:error("Error message")
      end)
    end)

    it("should handle formatted messages", function()
      assert.has_no.errors(function()
        logger:info("Test message with %s and %d", "string", 42)
      end)
    end)

    it("should handle complex objects", function()
      local complex_obj = {
        nested = { key = "value" },
        array = { 1, 2, 3 },
        func = function() end
      }

      assert.has_no.errors(function()
        logger:debug("Complex object: %s", complex_obj)
      end)
    end)
  end)

  describe("configuration", function()
    it("should respect enabled flag", function()
      local disabled_logger = Logger:new("DisabledLogger", { enabled = false })

      -- Should still have methods but might skip actual logging
      assert.is_function(disabled_logger.debug)
      assert.is_function(disabled_logger.info)
      assert.is_function(disabled_logger.warn)
      assert.is_function(disabled_logger.error)
    end)

    it("should respect log level", function()
      local high_level_logger = Logger:new("HighLevelLogger", { log_level = 3 })

      -- Should still be callable regardless of level
      assert.has_no.errors(function()
        high_level_logger:debug("This might be filtered")
        high_level_logger:error("This should appear")
      end)
    end)

    it("should handle string log levels", function()
      local logger_with_string_level = Logger:new("StringLevelLogger", { log_level = "WARN" })

      assert.is_not_nil(logger_with_string_level)
      assert.is_number(logger_with_string_level.log_level)
    end)
  end)

  describe("helper functions", function()
    it("should stringify various types", function()
      local logger = Logger:new("TestLogger")

      -- Test with different data types
      assert.has_no.errors(function()
        logger:info("String: %s", "test")
        logger:info("Number: %s", 42)
        logger:info("Boolean: %s", true)
        logger:info("Table: %s", { key = "value" })
        logger:info("Nil: %s", nil)
      end)
    end)

    it("should handle userdata", function()
      local logger = Logger:new("TestLogger")

      -- Mock userdata (in real tests this would be actual userdata)
      local mock_userdata = setmetatable({}, {
        __tostring = function() return "mock_userdata" end
      })

      assert.has_no.errors(function()
        logger:info("Userdata: %s", mock_userdata)
      end)
    end)
  end)

  describe("error handling", function()
    local logger

    before_each(function()
      logger = Logger:new("TestLogger")
    end)

    it("should handle nil messages", function()
      assert.has_no.errors(function()
        logger:info(nil)
      end)
    end)

    it("should handle empty messages", function()
      assert.has_no.errors(function()
        logger:info("")
      end)
    end)

    it("should handle invalid format strings", function()
      assert.has_no.errors(function()
        logger:info("Invalid format %q %z", "test")
      end)
    end)

    it("should handle missing format arguments", function()
      assert.has_no.errors(function()
        logger:info("Missing arg: %s %s", "only_one")
      end)
    end)

    it("should handle too many format arguments", function()
      assert.has_no.errors(function()
        logger:info("One arg: %s", "first", "second", "third")
      end)
    end)
  end)

  describe("integration", function()
    it("should work with WezTerm's logging system", function()
      local logger = Logger:new("IntegrationTest")

      -- Should integrate with mocked WezTerm logging
      assert.has_no.errors(function()
        logger:info("Integration test message")
        logger:warn("Integration test warning")
        logger:error("Integration test error")
      end)
    end)

    it("should work in Config class context", function()
      -- Test that logger works when used by Config class
      local config_logger = Logger:new("Config")

      assert.has_no.errors(function()
        config_logger:debug("Wezterm's config builder is available")
        config_logger:warn("Wezterm's config builder is unavailable")
        config_logger:error("Unable to require module %s", "some.module")
      end)
    end)

    it("should handle rapid logging", function()
      local logger = Logger:new("RapidTest")

      assert.has_no.errors(function()
        for i = 1, 100 do
          logger:debug("Rapid log message %d", i)
        end
      end)
    end)
  end)

  describe("metatable behavior", function()
    it("should properly implement __index", function()
      local logger = Logger:new("MetaTest")

      -- Should have access to all logger methods
      assert.is_function(logger.debug)
      assert.is_function(logger.info)
      assert.is_function(logger.warn)
      assert.is_function(logger.error)
    end)

    it("should maintain instance identity", function()
      local logger1 = Logger:new("Logger1")
      local logger2 = Logger:new("Logger2")

      assert.not_equals(logger1, logger2)
      assert.equals("Logger1", logger1.identifier)
      assert.equals("Logger2", logger2.identifier)
    end)
  end)
end)

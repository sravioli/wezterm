---@module "tests.config.general_spec"
---@description Tests for config.general module
---@author Test Suite

local helper = require("tests.spec_helper")

describe("config.general", function()
  local general_config

  before_each(function()
    helper.setup_mocks()
    -- Mock platform detection
    package.loaded["utils.fn"] = {
      fs = {
        platform = function()
          return {
            is_win = true,
            is_mac = false,
            is_linux = false
          }
        end,
        home = function()
          return "C:\\Users\\TestUser"
        end
      }
    }

    -- Mock icons
    package.loaded["utils.class.icon"] = {
      Progs = {
        ["pwsh.exe"] = "󰨊",
        ["git"] = ""
      }
    }

    general_config = require("config.general")
  end)

  after_each(function()
    helper.cleanup_mocks()
  end)

  describe("Windows platform configuration", function()
    it("should set PowerShell as default program", function()
      assert.is_table(general_config.default_prog)
      assert.same({
        "pwsh", "-NoLogo", "-ExecutionPolicy",
        "RemoteSigned", "-NoProfileLoadTime"
      }, general_config.default_prog)
    end)

    it("should include PowerShell V7 in launch menu", function()
      assert.is_table(general_config.launch_menu)
      local pwsh_v7 = general_config.launch_menu[1]
      assert.is_string(pwsh_v7.label)
      assert.truthy(pwsh_v7.label:find("PowerShell V7"))
      assert.same({
        "pwsh", "-NoLogo", "-ExecutionPolicy",
        "RemoteSigned", "-NoProfileLoadTime"
      }, pwsh_v7.args)
      assert.equals("~", pwsh_v7.cwd)
    end)

    it("should include PowerShell V5 in launch menu", function()
      local pwsh_v5 = general_config.launch_menu[2]
      assert.truthy(pwsh_v5.label:find("PowerShell V5"))
      assert.same({ "powershell" }, pwsh_v5.args)
      assert.equals("~", pwsh_v5.cwd)
    end)

    it("should include Command Prompt in launch menu", function()
      local cmd = general_config.launch_menu[3]
      assert.equals("Command Prompt", cmd.label)
      assert.same({ "cmd.exe" }, cmd.args)
      assert.equals("~", cmd.cwd)
    end)

    it("should include Git bash in launch menu", function()
      local git_bash = general_config.launch_menu[4]
      assert.truthy(git_bash.label:find("Git bash"))
      assert.same({ "sh", "-l" }, git_bash.args)
      assert.equals("~", git_bash.cwd)
    end)

    it("should configure WSL domains", function()
      assert.is_table(general_config.wsl_domains)
      assert.equals(2, #general_config.wsl_domains)

      local ubuntu = general_config.wsl_domains[1]
      assert.equals("WSL:Ubuntu", ubuntu.name)
      assert.equals("Ubuntu", ubuntu.distribution)
      assert.equals("sravioli", ubuntu.username)
      assert.equals("~", ubuntu.default_cwd)
      assert.same({ "bash", "-i", "-l" }, ubuntu.default_prog)

      local alpine = general_config.wsl_domains[2]
      assert.equals("WSL:Alpine", alpine.name)
      assert.equals("Alpine", alpine.distribution)
      assert.equals("sravioli", alpine.username)
      assert.equals("/home/sravioli", alpine.default_cwd)
    end)
  end)

  describe("Cross-platform configuration", function()
    it("should set default_cwd to home directory", function()
      assert.equals("C:\\Users\\TestUser", general_config.default_cwd)
    end)
  end)

  describe("Non-Windows platform", function()
    before_each(function()
      -- Reset and mock non-Windows platform
      package.loaded["config.general"] = nil
      package.loaded["utils.fn"] = {
        fs = {
          platform = function()
            return {
              is_win = false,
              is_mac = true,
              is_linux = false
            }
          end,
          home = function()
            return "/Users/testuser"
          end
        }
      }
      general_config = require("config.general")
    end)

    it("should not set Windows-specific configurations", function()
      assert.is_nil(general_config.default_prog)
      assert.is_nil(general_config.launch_menu)
      assert.is_nil(general_config.wsl_domains)
    end)

    it("should still set default_cwd", function()
      assert.equals("/Users/testuser", general_config.default_cwd)
    end)
  end)

  describe("Configuration validation", function()
    it("should be a valid table", function()
      assert.is_table(general_config)
    end)

    it("should have required properties for Windows", function()
      assert.is_not_nil(general_config.default_cwd)
    end)

    it("should have properly formatted launch menu entries", function()
      if general_config.launch_menu then
        for _, entry in ipairs(general_config.launch_menu) do
          assert.is_string(entry.label)
          assert.is_table(entry.args)
          assert.is_string(entry.cwd)
        end
      end
    end)

    it("should have properly formatted WSL domains", function()
      if general_config.wsl_domains then
        for _, domain in ipairs(general_config.wsl_domains) do
          assert.is_string(domain.name)
          assert.is_string(domain.distribution)
          assert.is_string(domain.username)
          assert.is_string(domain.default_cwd)
        end
      end
    end)
  end)

  describe("Icon integration", function()
    it("should include icons in launch menu labels", function()
      if general_config.launch_menu then
        local pwsh_entry = general_config.launch_menu[1]
        assert.truthy(pwsh_entry.label:find("󰨊"))

        local git_entry = general_config.launch_menu[4]
        assert.truthy(git_entry.label:find(""))
      end
    end)
  end)
end)

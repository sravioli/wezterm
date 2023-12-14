---@class WezTerm
local wez = require "wezterm"

---@class Icons
local icons = require "utils.icons"

---@class Config
local Config = {}

Config.default_prog =
  { "pwsh", "-NoLogo", "-ExecutionPolicy", "RemoteSigned", "-NoProfileLoadTime" }

Config.default_cwd = wez.home_dir

Config.launch_menu = {
  {
    label = icons.Pwsh .. " PowerShell V7",
    args = { "pwsh", "-NoLogo", "-ExecutionPolicy", "RemoteSigned", "-NoProfileLoadTime" },
    cwd = "~",
  },
  { label = icons.Pwsh .. " PowerShell V5", args = { "powershell" }, cwd = "~" },
  { label = "Command Prompt", args = { "cmd.exe" }, cwd = "~" },
  { label = icons.Git .. " Git bash", args = { "sh", "-l" }, cwd = "~" },
}

-- ref: https://wezfurlong.org/wezterm/config/lua/SshDomain.html
Config.ssh_domains = {}

-- ref: https://wezfurlong.org/wezterm/multiplexing.html#unix-domains
Config.unix_domains = {}

-- ref: https://wezfurlong.org/wezterm/config/lua/WslDomain.html
Config.wsl_domains = {
  {
    name = "WSL:Ubuntu",
    distribution = "Ubuntu",
    username = "sravioli",
    default_cwd = "/home/sRavioli",
    default_prog = { "bash" },
  },
  {
    name = "WSL:Alpine",
    distribution = "Alpin",
    username = "sravioli",
    default_cwd = "/home/sravioli",
    default_prog = { "ash" },
  },
}

return Config


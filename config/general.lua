---@diagnostic disable: undefined-field
---@class WezTerm
local wez = require "wezterm"

---@class config
local config = {}

---If no `prog` is specified on the command line, use this instead of running the
---user's shell.
---
---For example, to have `wezterm` always run `top` by default, you'd use this:
---
---```lua
---config.default_prog = { 'top' }
---```
---
---`default_prog` is implemented as an array where the 0th element is the command to
---run and the rest of the elements are passed as the positional arguments to that
---command.
config.default_prog = { "pwsh" }

---Sets the default current working directory used by the initial window.
---
---The value is a string specifying the absolute path that should be used for the home
---directory. Using strings like `~` or `~username` that are typically expanded by the
---shell is **not supported**. You can use wezterm.home_dir to explicitly refer to
---your home directory.
---
---If `wezterm start --cwd /some/path` is used to specify the current working directory,
---that will take precedence.
---
---Commands launched using `SpawnCommand` will use the `cwd` specified in the
---`SpawnCommand`, if any.
---
---Panes/Tabs/Windows created after the first will generally try to resolve the current
---working directory of the current Pane, preferring a value set by OSC 7 and falling
---back to attempting to lookup the `cwd` of the current process group leader attached
---to a local Pane. If no `cwd` can be resolved, then the `default_cwd` will be used.
---If `default_cwd` is not specified, then the home directory of the user will be used.
---
---On Windows, there isn't a process group leader concept, but `wezterm` will examine
---the process tree of the program that it started in the current pane and use some
---heuristics to determine an approximate equivalent.
config.default_cwd = wez.home_dir

---The launcher menu is accessed from the new tab button in the tab bar UI; the `+`
---button to the right of the tabs. Left clicking on the button will spawn a new tab,
---but right clicking on it will open the launcher menu. You may also bind a key to
---the ShowLauncher or ShowLauncherArgs action to trigger the menu.
---
---The launcher menu by default lists the various multiplexer domains and offers the
---option of connecting and spawning tabs/windows in those domains.
---
---You can define your own entries using the launch_menu configuration setting. The
---snippet below adds two new entries to the menu; one that runs the `top` program to
---monitor process activity and a second one that explicitly launches the `bash` shell.
---
---Each entry in `launch_menu` is an instance of a SpawnCommand object.
config.launch_menu = {
  { label = "PowerShell v7", args = { "pwsh.exe" }, cwd = "~" },
  { label = "PowerShell v5", args = { "powershell.exe" }, cwd = "~" },
  { label = "Command Prompt", args = { "cmd.exe" }, cwd = "~" },
  { label = "Git Bash", args = { "C:/Program Files/Git/bin/bash.exe" }, cwd = "~" },
}

return config

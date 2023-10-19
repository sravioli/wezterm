---@class config
local config = {}

---Defines the set of exit codes that are considered to be a "clean" exit by `exit_behavior`
---when the program running in the terminal completes.
---
---Acceptable values are an array of integer exit codes that you wish to treat as
---successful.
---
---For example, if you often `CTRL-C` a program and then `CTRL-D`, bash will typically
---exit with status `130` to indicate that a program was terminated with SIGINT, but
---that bash itself wasn't. In that situation you may wish to set this config to treat
---`130` as OK:
---
---```lua
---config.clean_exit_codes = { 130 }
---```
---
---Note that `0` is always treated as a clean exit code and can be omitted from the
---list.
config.clean_exit_codes = { 0 }

---Controls the behavior when the shell program spawned by the terminal exits. There
---are three possible values:
---
---* `"Close"` - close the corresponding pane as soon as the program exits.
---* `"Hold"` - keep the pane open after the program exits. The pane must be manually
---  closed via CloseCurrentPane, CloseCurrentTab or closing the window.
---* `"CloseOnCleanExit"` - if the shell program exited with a successful status,
---  behave like `"Close"`, otherwise, behave like `"Hold"`. This is the default
---  setting.
---
---```lua
---console.exit_behavior = 'Hold'
---```
---
---Note that most unix shells will exit with the status of the last command that it
---ran if you don't specify an exit status.
---
---For example, if you interrupt a command and then use `exit` (with no arguments), or
---CTRL-D to send EOF to the shell, the shell will return an unsuccessful exit status.
---The same thing holds if you were to run:
---
---```sh
---$ false
---$ exit
---```
---
---With the default `exit_behavior="CloseOnCleanExit"` setting, that will cause the
---pane to remain open.
---
---_Since: Version 20220624-141144-bd1b7c5d_
---The default is now `"Close"`.
---@see config.clean_exit_codes for fine tuning what is considered to be a clean exit status.
config.exit_behavior = "CloseOnCleanExit"

---Controls how wezterm indicates the exit status of the spawned process in a pane
---when it terminates.
---
---If exit_behavior is set to keep the pane open after the process has completed,
---wezterm will display a message to let you know that it has finished.
---
---This option controls that message. It can have one of the following values:
---
---* `"Verbose"` - Shows 2-3 lines of explanation, including the process name, its
---  exit status and a link to the exit_behavior documentation.
---* `"Brief"` - Like `"Verbose"`, but the link to the documentation is not included.
---* `"Terse"` - A very short indication of the exit status is shown in square brackets.
---* `"None"` - No message is shown.
---
---In earlier versions of wezterm, this was not configurable and behaved equivalently
---to the `"Verbose"` setting.
---
---**Example of a failing process with Verbose messaging**
---
---```sh
---$ wezterm -n --config 'default_prog={"false"}' \
---    --config 'exit_behavior="Hold"' \
---    --config 'exit_behavior_messaging="Verbose"'
---
---⚠️  Process "false" in domain "local" didn't exit cleanly
---Exited with code 1
---This message is shown because exit_behavior="Hold"
---```
---
---**Example of a failing process with Brief messaging**
---
---```sh
---$ wezterm -n --config 'default_prog={"false"}' \
---     --config 'exit_behavior="Hold"' \
---     --config 'exit_behavior_messaging="Brief"'
---
---⚠️  Process "false" in domain "local" didn't exit cleanly
---Exited with code 1
---```
---
---**Example of a failing process with Terse messaging**
---
---```sh
---$ wezterm -n --config 'default_prog={"false"}' \
---     --config 'exit_behavior="Hold"' \
---     --config 'exit_behavior_messaging="Terse"'
---
---[Exited with code 1]
---```
---
---**Example of a successful process with Verbose messaging**
---
---```
---$ wezterm -n --config 'default_prog={"true"}' \
---     --config 'exit_behavior="Hold"' \
---     --config 'exit_behavior_messaging="Verbose"'
---
---👍 Process "true" in domain "local" completed.
---This message is shown because exit_behavior="Hold"
---```
---
---Example of a successful process with Brief messaging
---
---```sh
---$ wezterm -n --config 'default_prog={"true"}' \
---     --config 'exit_behavior="Hold"' \
---     --config 'exit_behavior_messaging="Brief"'
---
---👍 Process "true" in domain "local" completed.
---```
---
---**Example of a successful process with Terse messaging**
---
---```sh
---$ wezterm -n --config 'default_prog={"true"}' \
---     --config 'exit_behavior="Hold"' \
---     --config 'exit_behavior_messaging="Terse"'
---
---[done]
---```
config.exit_behavior_messaging = "Verbose"

---This configuration specifies a list of process names that are considered to be
---"stateless" and that are safe to close without prompting when closing windows,
---panes or tabs.
---
---When closing a pane wezterm will try to determine the processes that were spawned
---by the program that was started in the pane. If all of those process names match
---one of the names in the `skip_close_confirmation_for_processes_named` list then
---it will not prompt for closing that particular pane.
---
---The default value for this setting is shown below:
---
---```lua
---config.skip_close_confirmation_for_processes_named = {
---  'bash',
---  'sh',
---  'zsh',
---  'fish',
---  'tmux',
---  'nu',
---  'cmd.exe',
---  'pwsh.exe',
---  'powershell.exe',
---}
---```
---
---More advanced control over this behavior can be achieved by defining a
---mux-is-process-stateful event handler.
config.skip_close_confirmation_for_processes_named = {
  "bash",
  "sh",
  "zsh",
  "fish",
  "tmux",
  "nu",
  "cmd.exe",
  "pwsh.exe",
  "powershell.exe",
}

---Whether to display a confirmation prompt when the window is closed by the windowing
---environment, either because the user closed it with the window decorations, or
---instructed their window manager to close it.
---
---Set this to `"NeverPrompt"` if you don't like confirming closing windows every time.
---
---```lua
---config.window_close_confirmation = 'AlwaysPrompt'
---```
---
---Note that this `window_close_confirmation` option doesn't apply to the default
---`CTRL-SHIFT-W` or `CMD-w` key assignments; if you want to change prompts for those,
---you will need to override the key shortcut as shown in the `CloseCurrentTab`
---documentation.
---@see config.skip_close_confirmation_for_processes_named.
config.window_close_confirmation = "AlwaysPrompt"

return config

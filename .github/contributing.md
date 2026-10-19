<!-- omit in toc -->
# Contributing to sravioli/wezterm

Thanks for taking the time to contribute.

This guide explains how to ask questions, report bugs, suggest changes, and
submit code or documentation updates. Read the section that matches the work you
want to do before opening an issue or pull request.

> If you like the project but do not have time to contribute, you can still help:
> - Star the project
> - Tweet about it
> - Refer this project in your project's readme
> - Mention the project at local meetups and tell your friends/colleagues

<!-- omit in toc -->
## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [I Have a Question](#i-have-a-question)
- [I Want To Contribute](#i-want-to-contribute)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)
- [Your First Code Contribution](#your-first-code-contribution)
- [Improving The Documentation](#improving-the-documentation)
- [Styleguides](#styleguides)
- [Commit Messages](#commit-messages)
- [Code Style](#code-style)
- [Join The Project Team](#join-the-project-team)


## Code of Conduct

This project and everyone participating in it is governed by the
[sravioli/wezterm Code of Conduct](https://github.com/sravioli/wezterm/blob/main/.github/code_of_conduct.md).
By participating, you are expected to uphold this code. Please report unacceptable behavior
to .


## I Have a Question

> If you want to ask a question, we assume that you have read the available [Documentation](https://github.com/sravioli/wezterm/wiki).

Before you ask a question, search existing
[issues](https://github.com/sravioli/wezterm/issues). If an issue already
covers the topic but needs more detail, add your question there. It is also
worth checking the WezTerm documentation and search results first.

If you still need help:

- Open an [Issue](https://github.com/sravioli/wezterm/issues/new).
- Provide as much context as you can about what you're running into.
- Provide your WezTerm version (`wezterm --version`), OS, and any relevant details about your environment.

Someone will follow up when they can.

## I Want To Contribute

> ### Legal Notice <!-- omit in toc -->
> When contributing to this project, you must agree that you have authored 100% of the content, that you have the necessary rights to the content and that the content you contribute may be provided under the project licence.

### Reporting Bugs

<!-- omit in toc -->
#### Before Submitting a Bug Report

A good bug report includes enough detail for someone else to reproduce the
problem. Before opening one:

- Make sure that you are using the latest version.
- Check whether the issue comes from an unsupported WezTerm version,
  platform-specific setup, or local override.
- Search the [bug tracker](https://github.com/sravioli/wezterm/issues?q=label%3Abug)
  for the same error.
- Search the web as well, including Stack Overflow, in case the behavior comes
  from WezTerm or the terminal environment.
- Collect information about the bug:
  - WezTerm version (`wezterm --version`)
  - OS, Platform and Version (Windows, Linux, macOS, x86, ARM)
  - Error output from WezTerm's debug overlay (`Ctrl+Shift+L`)
  - GPU information if the issue is rendering-related (`wezterm ls-fonts --list-system` or Lantern GPU output)
  - Any relevant files in your `overrides/` directory
  - Your input and the output
  - Whether you can reproduce the issue reliably, and whether older versions
    behave the same way.

<!-- omit in toc -->
#### How Do I Submit a Good Bug Report?

> You must never report security related issues, vulnerabilities or bugs including sensitive information to the issue tracker, or elsewhere in public. Instead sensitive bugs must be sent by email to .
<!-- You may add a PGP key to allow the messages to be sent encrypted as well. -->

We use GitHub issues to track bugs and errors. If you run into an issue with the project:

- Open an [issue](https://github.com/sravioli/wezterm/issues/new).
- Explain the behavior you would expect and the actual behavior.
- Provide the *reproduction steps* that someone else can follow. Include the
  relevant config snippet or a reduced test case when possible.
- Provide the information you collected in the previous section.

Once it's filed:

- The project team will label the issue.
- A maintainer will try to reproduce it. If the issue does not include enough
  detail, it may be marked `needs-repro`.
- Once the issue is reproducible, it can be marked `needs-fix` and picked up by
  a contributor.

<!-- You might want to create an issue template for bugs and errors that can be used as a guide and that defines the structure of the information to be included. If you do so, reference it here in the description. -->


### Suggesting Enhancements

Use this section for new feature ideas and smaller improvements to existing
behavior.

<!-- omit in toc -->
#### Before Submitting an Enhancement

- Make sure that you are using the latest version.
- Read the [documentation](https://github.com/sravioli/wezterm/wiki) and check
  whether the behavior is already possible through configuration or overrides.
- Search existing [issues](https://github.com/sravioli/wezterm/issues). If the
  idea already exists, add context there instead of opening a duplicate.
- Make sure the idea fits the project. Narrow personal workflows may be better
  as an override or standalone plugin.

<!-- omit in toc -->
#### How Do I Submit a Good Enhancement Suggestion?

Enhancement suggestions are tracked as [GitHub issues](https://github.com/sravioli/wezterm/issues).

- Use a clear title.
- Describe the change in concrete steps.
- Explain the current behavior, the behavior you expected, and any alternatives
  that do not work for you.
- Include screenshots or recordings when they make the request easier to
  understand.
- Explain why the change belongs in this config rather than in a personal
  override.

<!-- You might want to create an issue template for enhancement suggestions that can be used as a guide and that defines the structure of the information to be included. If you do so, reference it here in the description. -->

### Your First Code Contribution

#### Prerequisites

- [WezTerm](https://wezfurlong.org/wezterm/) installed
- [Git](https://git-scm.com/)
- [StyLua](https://github.com/JohnnyMorganz/StyLua) formatter (`cargo install stylua` or grab a binary from the [releases page](https://github.com/JohnnyMorganz/StyLua/releases))

#### Setup

1. **Fork** the repository on GitHub - either through the GitHub web UI or with the [GitHub CLI](https://cli.github.com/):

   ```sh
   gh repo fork sravioli/wezterm --clone=false
   ```

2. **Backup your existing WezTerm config** (if you have one):

   Linux / macOS:
   ```sh
   cp -r ~/.config/wezterm ~/.config/wezterm.bak
   ```

   Windows (PowerShell):
   ```powershell
   Copy-Item -Recurse "$env:USERPROFILE\.config\wezterm" "$env:USERPROFILE\.config\wezterm.bak"
   ```

3. **Clone your fork** into the WezTerm config directory:

   Linux / macOS:
   ```sh
   gh repo clone <your-username>/wezterm ~/.config/wezterm
   # or without gh:
   git clone https://github.com/<your-username>/wezterm.git ~/.config/wezterm
   ```

   Windows (PowerShell):
   ```powershell
   gh repo clone <your-username>/wezterm "$env:USERPROFILE\.config\wezterm"
   # or without gh:
   git clone https://github.com/<your-username>/wezterm.git "$env:USERPROFILE\.config\wezterm"
   ```

   > [!NOTE]
   > `gh repo clone` automatically sets the `upstream` remote for you. If you used `gh`, you can skip step 4.

4. **Add the upstream remote** (only needed if you cloned with `git clone`):
   ```sh
   cd ~/.config/wezterm   # or $env:USERPROFILE\.config\wezterm on Windows
   git remote add upstream https://github.com/sravioli/wezterm.git
   ```

#### Restoring your original config

When you're done contributing and want to restore your original config, run:

Linux / macOS:
```sh
rm -rf ~/.config/wezterm && mv ~/.config/wezterm.bak ~/.config/wezterm
```

Windows (PowerShell):
```powershell
Remove-Item -Recurse -Force "$env:USERPROFILE\.config\wezterm"
Rename-Item "$env:USERPROFILE\.config\wezterm.bak" "wezterm"
```

#### Architecture overview

This is a modular WezTerm configuration written in Lua. The main pieces are:

- **`wezterm.lua`** - Entry point. Loads events (side-effect), builds the config via `Config:add()` chaining, applies mapping overrides through Chord, then registers Chord commands.
- **`config/`** - Config modules (appearance, font, GPU, tab bar, general). Each returns a table of WezTerm options.
- **`events/`** - WezTerm event handlers (status bar, tab title, window title, etc.). Conditionally loaded based on `Opts`.
- **`mappings/`** - Keybindings using Vim-style notation (`<C-S-a>`, `<leader>w`). Split into `default.lua` (global keys) and `modes.lua` (modal key tables).
- **`opts/`** - Central configuration registry. Controls feature flags, statusbar modules, and local config-builder options. Optional features check `Opts.X.enabled` before loading.
- **`plugs/`** - Central plugin wrappers. Consumer modules require `plugs.<name>` instead of calling `wezterm.plugin.require()` directly.
- **`utils/`** - Shared utilities that remain local to this config: config builder, renderer, bar budget, conditions, color helpers, and assertion helpers.
- **`plugins/`** - Local source checkouts for standalone `.wz` plugins. Published plugins are loaded through `plugs/`.
- **`overrides/`** - **User customization layer.** Each subdirectory (`config/`, `events/`, `mappings/`, `opts/`) is loaded with `pcall(require, "overrides.<module>")`. If the file exists it's merged in, otherwise it's silently skipped.

> [!IMPORTANT]
> Never modify core files for personal tweaks. Use the `overrides/` directory
> instead. It lets you customize the config without changing upstream files.

#### Key conventions

- **Modules return tables.** Config modules return a table of WezTerm options; event modules register handlers as a side effect.
- **Opts-driven feature flags.** Every optional feature checks `Opts.X.enabled` before loading.
- **Vim-style key notation.** All keybindings use human-readable Vim notation (e.g. `<C-S-c>` for Ctrl+Shift+C).
- **Deep merge strategy.** `tbl.merge("force", base, overrides)` is the standard pattern for merging config tables.

#### Testing changes

Run the picker/status integration regression specs from the config root with
`busted spec/statusbar_spec.lua`. They use Chord's existing Busted mock and
the local `plugins/chord.wz` checkout, with no GUI or new test dependencies.
Load the actual configuration with `wezterm --config-file wezterm.lua show-keys
--lua` after integration changes. Plugin-specific suites and lint commands
are documented in each plugin checkout.

WezTerm **live-reloads** the configuration whenever a file changes. To debug:

1. Press `Ctrl+Shift+L` to open the **debug overlay** - this shows logs, errors, and Lua print output.
2. Check the WezTerm error window that pops up on config parse errors.
3. Use the logger (configured via `Opts`) to add debug output to your modules.

### Improving The Documentation

Documentation lives on the
[GitHub wiki](https://github.com/sravioli/wezterm/wiki). Fixes, clearer
explanations, and focused examples are welcome.

When working on documentation, keep in mind:

- **Documentation license.** All documentation is licensed under [CC BY-NC 4.0](../LICENSE-DOCS).
- **LuaCATS annotations.** All Lua files use [LuaCATS annotations](https://luals.github.io/wiki/annotations/) (`---@class`, `---@param`, `---@return`, `---@module`, etc.). Please maintain and update these annotations when modifying code.
- **Changelog.** The `CHANGELOG.md` is **auto-generated** by [Cocogitto](https://docs.cocogitto.io/) from commit messages. Do not edit it manually.

## Styleguides
### Commit Messages

This project uses [Conventional Commits](https://www.conventionalcommits.org/) enforced by [Cocogitto](https://docs.cocogitto.io/). The full configuration is in [`cog.toml`](../cog.toml).

#### Format

```
type(scope): description
```

Examples:
```
feat(lantern): add Gruvbox colorscheme
fix(statusbar): correct padding calculation on resize
docs(readme): update installation instructions
refactor(chord): simplify modifier parsing
```

#### Commit types

| Type       | Description                          | Changelog section |
| ---------- | ------------------------------------ | ----------------- |
| `feat`     | A new feature                        | Features          |
| `fix`      | A bug fix                            | Bug Fixes         |
| `refactor` | Code change (no new feature/fix)     | Refactoring       |
| `docs`     | Documentation only                   | Documentation     |
| `style`    | Formatting, missing semicolons, etc. | Style             |
| `test`     | Adding or correcting tests           | Tests             |
| `perf`     | Performance improvement              | Performance       |
| `ci`       | CI configuration                     | Continuous Integration |
| `build`    | Build system or dependencies         | Build             |
| `chore`    | Miscellaneous tasks                  | *(omitted)*       |
| `hotfix`   | Urgent fix                           | Hotfixes          |
| `release`  | Release commit                       | Releases          |

#### Scopes

Scopes are freeform but should match a directory or feature area: `config`, `events`, `mappings`, `opts`, `lantern`, `chord`, `ribbon`, `sigil`, `utils`, `statusbar`, `plugins`, `renderer`, etc.

#### Additional rules

- **Versioning:** bare SemVer tags without prefix (e.g. `6.3.4`, not `v6.3.4`).
- **Merge commits** are ignored
- **Only `main`** can be version-bumped.

### Code Style

Lua code is formatted with [StyLua](https://github.com/JohnnyMorganz/StyLua), configured in [`.stylua.toml`](../.stylua.toml). **Run `stylua .` before committing.**

Key settings:

| Setting            | Value              | Notes |
| ------------------ | ------------------ | ----- |
| Indent             | 2 spaces           |       |
| Column width       | 90                 | Soft wrap guide |
| Line endings       | Unix (LF)          | Even on Windows |
| Quote style        | `AutoPreferDouble`  | Prefers `"`, falls back to `'` when fewer escapes |
| Call parentheses   | `None`             | Omit parens on single string/table arg calls (e.g. `require "foo"`) |
| Require sorting    | Enabled            | Consecutive `require` blocks are sorted automatically |

Additional guidelines:

- Use [LuaCATS annotations](https://luals.github.io/wiki/annotations/) for all public functions, classes, and module-level types.
- Use `selene` inline annotations sparingly where needed: `-- selene: allow(unused_variable)`.
- Keep modules focused - one responsibility per file.

## Join The Project Team

Interested in becoming a maintainer? Consistent, quality contributions are the way in. If you'd like to discuss a larger role, open an issue or reach out directly.

<!-- omit in toc -->
## Attribution
This guide was originally generated by [**contributing-gen**](https://github.com/bttger/contributing-gen) and has been tailored for the sravioli/wezterm project.

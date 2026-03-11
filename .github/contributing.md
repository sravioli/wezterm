<!-- omit in toc -->
# Contributing to sravioli/wezterm

First off, thanks for taking the time to contribute! ❤️

All types of contributions are encouraged and valued. See the [Table of Contents](#table-of-contents) for different ways to help and details about how this project handles them. Please make sure to read the relevant section before making your contribution. It will make it a lot easier for us maintainers and smooth out the experience for all involved. The community looks forward to your contributions. 🎉

> And if you like the project, but just don't have time to contribute, that's fine. There are other easy ways to support the project and show your appreciation, which we would also be very happy about:
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

Before you ask a question, it is best to search for existing [Issues](https://github.com/sravioli/wezterm/issues) that might help you. In case you have found a suitable issue and still need clarification, you can write your question in this issue. It is also advisable to search the internet for answers first.

If you then still feel the need to ask a question and need clarification, we recommend the following:

- Open an [Issue](https://github.com/sravioli/wezterm/issues/new).
- Provide as much context as you can about what you're running into.
- Provide your WezTerm version (`wezterm --version`), OS, and any relevant details about your environment.

We will then take care of the issue as soon as possible.

## I Want To Contribute

> ### Legal Notice <!-- omit in toc -->
> When contributing to this project, you must agree that you have authored 100% of the content, that you have the necessary rights to the content and that the content you contribute may be provided under the project licence.

### Reporting Bugs

<!-- omit in toc -->
#### Before Submitting a Bug Report

A good bug report shouldn't leave others needing to chase you up for more information. Therefore, we ask you to investigate carefully, collect information and describe the issue in detail in your report. Please complete the following steps in advance to help us fix any potential bug as fast as possible.

- Make sure that you are using the latest version.
- Determine if your bug is really a bug and not an error on your side e.g. using incompatible environment components/versions (Make sure that you have read the [documentation](https://github.com/sravioli/wezterm/wiki). If you are looking for support, you might want to check [this section](#i-have-a-question)).
- To see if other users have experienced (and potentially already solved) the same issue you are having, check if there is not already a bug report existing for your bug or error in the [bug tracker](https://github.com/sravioli/wezterm/issues?q=label%3Abug).
- Also make sure to search the internet (including Stack Overflow) to see if users outside of the GitHub community have discussed the issue.
- Collect information about the bug:
  - WezTerm version (`wezterm --version`)
  - OS, Platform and Version (Windows, Linux, macOS, x86, ARM)
  - Error output from WezTerm's debug overlay (`Ctrl+Shift+L`)
  - GPU information if the issue is rendering-related (`wezterm ls-fonts --list-system` or the GPU picker output)
  - Any relevant files in your `overrides/` directory
  - Your input and the output
  - Can you reliably reproduce the issue? And can you also reproduce it with older versions?

<!-- omit in toc -->
#### How Do I Submit a Good Bug Report?

> You must never report security related issues, vulnerabilities or bugs including sensitive information to the issue tracker, or elsewhere in public. Instead sensitive bugs must be sent by email to .
<!-- You may add a PGP key to allow the messages to be sent encrypted as well. -->

We use GitHub issues to track bugs and errors. If you run into an issue with the project:

- Open an [Issue](https://github.com/sravioli/wezterm/issues/new). (Since we can't be sure at this point whether it is a bug or not, we ask you not to talk about a bug yet and not to label the issue.)
- Explain the behavior you would expect and the actual behavior.
- Please provide as much context as possible and describe the *reproduction steps* that someone else can follow to recreate the issue on their own. This usually includes your code. For good bug reports you should isolate the problem and create a reduced test case.
- Provide the information you collected in the previous section.

Once it's filed:

- The project team will label the issue accordingly.
- A team member will try to reproduce the issue with your provided steps. If there are no reproduction steps or no obvious way to reproduce the issue, the team will ask you for those steps and mark the issue as `needs-repro`. Bugs with the `needs-repro` tag will not be addressed until they are reproduced.
- If the team is able to reproduce the issue, it will be marked `needs-fix`, as well as possibly other tags (such as `critical`), and the issue will be left to be [implemented by someone](#your-first-code-contribution).

<!-- You might want to create an issue template for bugs and errors that can be used as a guide and that defines the structure of the information to be included. If you do so, reference it here in the description. -->


### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for sravioli/wezterm, **including completely new features and minor improvements to existing functionality**. Following these guidelines will help maintainers and the community to understand your suggestion and find related suggestions.

<!-- omit in toc -->
#### Before Submitting an Enhancement

- Make sure that you are using the latest version.
- Read the [documentation](https://github.com/sravioli/wezterm/wiki) carefully and find out if the functionality is already covered, maybe by an individual configuration.
- Perform a [search](https://github.com/sravioli/wezterm/issues) to see if the enhancement has already been suggested. If it has, add a comment to the existing issue instead of opening a new one.
- Find out whether your idea fits with the scope and aims of the project. It's up to you to make a strong case to convince the project's developers of the merits of this feature. Keep in mind that we want features that will be useful to the majority of our users and not just a small subset. If you're just targeting a minority of users, consider writing an add-on/plugin library.

<!-- omit in toc -->
#### How Do I Submit a Good Enhancement Suggestion?

Enhancement suggestions are tracked as [GitHub issues](https://github.com/sravioli/wezterm/issues).

- Use a **clear and descriptive title** for the issue to identify the suggestion.
- Provide a **step-by-step description of the suggested enhancement** in as many details as possible.
- **Describe the current behavior** and **explain which behavior you expected to see instead** and why. At this point you can also tell which alternatives do not work for you.
- You may want to **include screenshots or screen recordings** which help you demonstrate the steps or point out the part which the suggestion is related to. You can use [LICEcap](https://www.cockos.com/licecap/) to record GIFs on macOS and Windows, and the built-in [screen recorder in GNOME](https://help.gnome.org/users/gnome-help/stable/screen-shot-record.html.en) or [SimpleScreenRecorder](https://github.com/MaartenBaert/ssr) on Linux. <!-- this should only be included if the project has a GUI -->
- **Explain why this enhancement would be useful** to most sravioli/wezterm users. You may also want to point out the other projects that solved it better and which could serve as inspiration.

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

The project is a modular WezTerm configuration written in Lua. Here's how it fits together:

- **`wezterm.lua`** - Entry point. Loads events (side-effect), builds the config via `Config:add()` chaining, applies mappings, then merges overrides.
- **`config/`** - Config modules (appearance, font, GPU, tab bar, general). Each returns a table of WezTerm options.
- **`events/`** - WezTerm event handlers (status bar, tab title, window title, etc.). Conditionally loaded based on `Opts`.
- **`mappings/`** - Keybindings using Vim-style notation (`<C-S-a>`, `<leader>w`). Split into `default.lua` (global keys) and `modes.lua` (modal key tables).
- **`opts/`** - Central configuration registry. Controls feature flags, statusbar layout, logger settings, and more. All features check `Opts.X.enabled` before loading.
- **`picker/`** - Interactive pickers (colorscheme, font, font size, GPU) with asset modules in `picker/assets/`.
- **`utils/`** - Shared utilities: config builder, keymapper, layout engine, renderer, logger, assertion library, string/table/color helpers.
- **`plugins/`** - Plugin system (`nap.wzt`). Plugins are loaded via `wezterm.plugin.require`.
- **`overrides/`** - **User customization layer.** Each subdirectory (`config/`, `events/`, `mappings/`, `opts/`) is loaded with `pcall(require, "overrides.<module>")`. If the file exists it's merged in, otherwise it's silently skipped.

> [!IMPORTANT]
> Never modify core files for personal tweaks. Use the `overrides/` directory instead - it's specifically designed so you can customize everything without touching upstream code.

#### Key conventions

- **Modules return tables.** Config modules return a table of WezTerm options; event modules register handlers as a side effect.
- **Opts-driven feature flags.** Every optional feature checks `Opts.X.enabled` before loading.
- **Vim-style key notation.** All keybindings use human-readable Vim notation (e.g. `<C-S-c>` for Ctrl+Shift+C).
- **Deep merge strategy.** `tbl.merge("force", base, overrides)` is the standard pattern for merging config tables.

#### Testing changes

WezTerm **live-reloads** the configuration whenever a file changes. To debug:

1. Press `Ctrl+Shift+L` to open the **debug overlay** - this shows logs, errors, and Lua print output.
2. Check the WezTerm error window that pops up on config parse errors.
3. Use the logger (configured via `Opts`) to add debug output to your modules.

### Improving The Documentation

Documentation lives on the [GitHub wiki](https://github.com/sravioli/wezterm/wiki). Contributions to the wiki (fixing typos, clarifying explanations, adding examples) are very welcome.

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
feat(picker): add Gruvbox colorscheme
fix(statusbar): correct padding calculation on resize
docs(readme): update installation instructions
refactor(keymapper): simplify modifier parsing
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

Scopes are freeform but should match a directory or feature area: `config`, `events`, `mappings`, `opts`, `picker`, `utils`, `statusbar`, `plugins`, `keymapper`, `renderer`, etc.

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
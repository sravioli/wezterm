# Changelog
All notable changes to this project will be documented in this file. See [conventional commits](https://www.conventionalcommits.org/) for commit guidelines.

- - -
## [2.0.4](https://github.com/sRavioli/wezterm/compare/2.0.3..2.0.4) - 2023-10-29
#### Hotfixes
- **(colorschemes:kanagawa)** add `tab_bar` colors, update config to use correct colors - ([e48910c](https://github.com/sRavioli/wezterm/commit/e48910cd07c750938be9c2435dfabeccc5276149)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [2.0.3](https://github.com/sRavioli/wezterm/compare/2.0.2..2.0.3) - 2023-10-29
#### Bug Fixes
- **(colorschemes:kanagawa)** update kanagawa-wave, add dragon and lotus variants - ([63d7fd9](https://github.com/sRavioli/wezterm/commit/63d7fd938cd11bc99ff73f2783a81a4d6dc95965)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [2.0.2](https://github.com/sRavioli/wezterm/compare/2.0.1..2.0.2) - 2023-10-26
#### Hotfixes
- **(events:format-tab-title)** truncate more whe showing neovim directory - ([8d240c6](https://github.com/sRavioli/wezterm/commit/8d240c6a3aed29c4c2ad3732c81368002544646c)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [2.0.1](https://github.com/sRavioli/wezterm/compare/2.0.0..2.0.1) - 2023-10-25
#### Bug Fixes
- **(utils:layout)** insert text after attributes - ([bf1d779](https://github.com/sRavioli/wezterm/commit/bf1d779367850ab8c6eaecc2d2e178e380477677)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [2.0.0](https://github.com/sRavioli/wezterm/compare/1.0.2..2.0.0) - 2023-10-25
#### Bug Fixes
- **(config:appearance)** reduce tab title max width - ([1a976b9](https://github.com/sRavioli/wezterm/commit/1a976b9486ad0236cf5476909fdc3a4586617a9a)) - [@sRavioli](https://github.com/sRavioli)
- **(event:format-tab-title)** improve trucation, improve unseen notification handling, use new `nf.Separators` class - ([6116cda](https://github.com/sRavioli/wezterm/commit/6116cdae841399c6243381ef600cee6cca3d7520)) - [@sRavioli](https://github.com/sRavioli)
- **(utils:nerdfont-icons)** remove `Powerline` and `SemiCircle` class, add the `Separators` class - ([a1fe61b](https://github.com/sRavioli/wezterm/commit/a1fe61be209a259c1ff1cb977cf7cc7d7cd580d7)) - [@sRavioli](https://github.com/sRavioli)
- **(utils:nerdfont-icons)** swap the `Circle` class with simpler `UnseenNotification` string - ([a2354bf](https://github.com/sRavioli/wezterm/commit/a2354bf1bc1103b67ad77387424af728fd762bf5)) - [@sRavioli](https://github.com/sRavioli)
- **(utils:nerdfont-icons)** remove unused icons - ([4445508](https://github.com/sRavioli/wezterm/commit/4445508fd5dcb9b9fe378b63b9147275ce9be8de)) - [@sRavioli](https://github.com/sRavioli)
#### Features
- **(events:update-status)** improve cell push cycle, when possible display the git project root - ([8678a79](https://github.com/sRavioli/wezterm/commit/8678a7986adceccd4a8a5a9b1e9d629a753cbd7c)) - [@sRavioli](https://github.com/sRavioli)
- **(utils:functions)** update `get_cwd_hostname()` to have the option to search for the git root - ([64a3913](https://github.com/sRavioli/wezterm/commit/64a39132750c104a246990eef637a8eed330927c)) - [@sRavioli](https://github.com/sRavioli)
- **(utils:functions)** implement `find_git_dir()` that given a directory finds the project git root - ([e83f41d](https://github.com/sRavioli/wezterm/commit/e83f41d1dab181b6e47f2f1c197194ee23764e91)) - [@sRavioli](https://github.com/sRavioli)
#### Style
- **(events:format-tab-title)** move includes inside the `wezterm.on()` call - ([a141adb](https://github.com/sRavioli/wezterm/commit/a141adb2a074697b65855e2535440c42fff443b3)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [1.0.2](https://github.com/sRavioli/wezterm/compare/1.0.1..1.0.2) - 2023-10-23
#### Bug Fixes
- **(config:appearance)** increase tab max width - ([6d54ff9](https://github.com/sRavioli/wezterm/commit/6d54ff9a3ef61809203911d1663591a0ac979afe)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [1.0.1](https://github.com/sRavioli/wezterm/compare/1.0.0..1.0.1) - 2023-10-23
#### Bug Fixes
- **(utils:functions)** remove `is_admin()` function - ([67cf00f](https://github.com/sRavioli/wezterm/commit/67cf00f295f8614d17a95550873bdd4c8bb77035)) - [@sRavioli](https://github.com/sRavioli)
#### Features
- **(keys:bindings)** add command to fullscreen window - ([6c0de47](https://github.com/sRavioli/wezterm/commit/6c0de477f7feacd1253dd3e014a6ca1e5c26cbba)) - [@sRavioli](https://github.com/sRavioli)
#### Refactoring
- **(events:format-tab-title)** don't check for admin, just `:gsub()` the string to the icon - ([bf5740a](https://github.com/sRavioli/wezterm/commit/bf5740a79cebe2be80cf906e9a6fff22abf705cf)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [1.0.0](https://github.com/sRavioli/wezterm/compare/0.2.0..1.0.0) - 2023-10-23
#### Bug Fixes
- **(utils:functions)** remove comments and unused function - ([fe3862f](https://github.com/sRavioli/wezterm/commit/fe3862fbc504d607f641bd5ff700ff180f0f1754)) - [@sRavioli](https://github.com/sRavioli)
#### Features
- **(colorschemes:kanagawa)** change tag bar background color - ([e62f4fd](https://github.com/sRavioli/wezterm/commit/e62f4fdc1507a8767e6896fe5f05143dc1c62ef7)) - [@sRavioli](https://github.com/sRavioli)
- **(events:update-status)** create status bar layout - ([c37d4bc](https://github.com/sRavioli/wezterm/commit/c37d4bc1610b5a62f2dc11a2d00b4410e0338c8f)) - [@sRavioli](https://github.com/sRavioli)
- **(utils:functions)** implement `mround`, `toint` and `get_cwd_hostname` functions - ([0e6d866](https://github.com/sRavioli/wezterm/commit/0e6d8665f0bdb13ab745bea3e10ac58e0b6982e5)) - [@sRavioli](https://github.com/sRavioli)
- **(utils:layout)** crate layout class with utility `:push()` method - ([810ca3c](https://github.com/sRavioli/wezterm/commit/810ca3c54385d21acd2fdea736fcfff0a0ec7212)) - [@sRavioli](https://github.com/sRavioli)
- **(utils:nerdfont-icons)** add powerline symbols - ([517dce3](https://github.com/sRavioli/wezterm/commit/517dce3e76498cfa90871f784c34f8d682f01e66)) - [@sRavioli](https://github.com/sRavioli)
#### Refactoring
- **(events:format-tab-title)** get cwd outside the call to `string.format` when formatting tab title - ([4aea4d8](https://github.com/sRavioli/wezterm/commit/4aea4d8f8d93e1ca25ef4594256cee6c6e169a48)) - [@sRavioli](https://github.com/sRavioli)
- **(events:format-tab-title)** set background once since it does not change - ([161eb99](https://github.com/sRavioli/wezterm/commit/161eb99dcba7d03d9fb9c71bfd74e36fd03e9bbe)) - [@sRavioli](https://github.com/sRavioli)
- **(events:format-tab-title)** make `layout` use the `Layout` class object - ([7f961b1](https://github.com/sRavioli/wezterm/commit/7f961b101ea8a01dd74c205aaa8e29794d681a80)) - [@sRavioli](https://github.com/sRavioli)
- **(events:format-window-title)** get cwd outside the `string.format` call when setting the title - ([c7513f4](https://github.com/sRavioli/wezterm/commit/c7513f4193efdc0a8ea83eb73c3ff01dd35b6bf9)) - [@sRavioli](https://github.com/sRavioli)
- **(utils:nerdfont-icons)** add battery icons for charging and discharging with indexes - ([7aae5c2](https://github.com/sRavioli/wezterm/commit/7aae5c24acd231a84b2ae59d707b7486d94d81fe)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [0.2.0](https://github.com/sRavioli/wezterm/compare/0.1.0..0.2.0) - 2023-10-22
#### Bug Fixes
- **(colorschemes:kanagawa)** remove comment - ([7145dff](https://github.com/sRavioli/wezterm/commit/7145dff78ab59b2cefa0dff8608a556eb7f6938d)) - [@sRavioli](https://github.com/sRavioli)
- **(config/keys)** rename `wz` to `wez` - ([262a6b1](https://github.com/sRavioli/wezterm/commit/262a6b1759af6821bdf7a259aad51bb763b99006)) - [@sRavioli](https://github.com/sRavioli)
- **(config:appearance)** reduce tab title max width - ([115e70b](https://github.com/sRavioli/wezterm/commit/115e70b48a766fa48cc7d067aafb69fb66280970)) - [@sRavioli](https://github.com/sRavioli)
- **(config:appearance)** disable fancy tab bar, move it to bottom - ([2b0a891](https://github.com/sRavioli/wezterm/commit/2b0a89199d5c094a2cac1272bbe6fa31ca76fcb1)) - [@sRavioli](https://github.com/sRavioli)
- **(config:font)** disable `NO_BITMAP` option that would prevent emojis from showing up - ([51d1e51](https://github.com/sRavioli/wezterm/commit/51d1e5119e2c056bd70389a9154f717be2abbd29)) - [@sRavioli](https://github.com/sRavioli)
- **(config:window)** do not use integrated buttons - ([6eaae36](https://github.com/sRavioli/wezterm/commit/6eaae36299d45ef56c365ba08c1624e823b4dbec)) - [@sRavioli](https://github.com/sRavioli)
#### Features
- **(config:appearance)** add documentation, add tab bar settings - ([c164e03](https://github.com/sRavioli/wezterm/commit/c164e03b9cd1895ae742178cb5c856b1548d5baa)) - [@sRavioli](https://github.com/sRavioli)
- **(config:font)** try to change underline pos based on display - ([4b59f06](https://github.com/sRavioli/wezterm/commit/4b59f06c56a0b6f56982dd31c7d45c7f62eb8f82)) - [@sRavioli](https://github.com/sRavioli)
- **(events:format-tab-title)** custom format tab title - ([5d2b1a6](https://github.com/sRavioli/wezterm/commit/5d2b1a61a54d47f51a765a7949afb7a2729a7864)) - [@sRavioli](https://github.com/sRavioli)
- **(events:format-window-title)** custom format window title - ([cb876ce](https://github.com/sRavioli/wezterm/commit/cb876ce8a40d509a9956154ffc0b1c8d7bf8f9fa)) - [@sRavioli](https://github.com/sRavioli)
- **(events:update-status)** (wip) create status bar - ([a529aec](https://github.com/sRavioli/wezterm/commit/a529aec29a6e45a1ab3aace695b4d432b103e9aa)) - [@sRavioli](https://github.com/sRavioli)
- **(utils:functions)** add some utility functions - ([f34834f](https://github.com/sRavioli/wezterm/commit/f34834ffe394ae2e7b0895603015b9058c9d185e)) - [@sRavioli](https://github.com/sRavioli)
- **(utils:nerdfont-icons)** categorize `wezterm` nerdfont icons - ([59227c3](https://github.com/sRavioli/wezterm/commit/59227c325adf62c670787db267fb946198baee0b)) - [@sRavioli](https://github.com/sRavioli)
- **(wezterm)** load events - ([f0ba708](https://github.com/sRavioli/wezterm/commit/f0ba708a42dede6d416eb81fc4a6572751b1d204)) - [@sRavioli](https://github.com/sRavioli)
#### Refactoring
- **(config:window)** move tab bar settings - ([bf839eb](https://github.com/sRavioli/wezterm/commit/bf839eb6508910299bb592a5d3b7f9c1ccfce140)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [0.1.0](https://github.com/sRavioli/wezterm/compare/0.0.2..0.1.0) - 2023-10-20
#### Bug Fixes
- **(config:font)** move underline a bit down - ([7d79450](https://github.com/sRavioli/wezterm/commit/7d79450eb6b86e2907634f6e01dd7ab03c3b774b)) - [@sRavioli](https://github.com/sRavioli)
- **(config:font)** remove deprecated font setting - ([3f64fa6](https://github.com/sRavioli/wezterm/commit/3f64fa6f77cd72173e9f48888b85bc557d5d33ef)) - [@sRavioli](https://github.com/sRavioli)
- **(config:font)** bug where the command palette would render letters wrongly - ([9e83117](https://github.com/sRavioli/wezterm/commit/9e83117269283afcd727c277711aae5440d59b60)) - [@sRavioli](https://github.com/sRavioli)
- **(config:font)** disable backslash render variant - ([f375b51](https://github.com/sRavioli/wezterm/commit/f375b51e6be7e0cd2a55ac1a09bf0767080d91e1)) - [@sRavioli](https://github.com/sRavioli)
#### Features
- **(config:appearance)** change styling for inactive panes - ([e9db4da](https://github.com/sRavioli/wezterm/commit/e9db4da757ce406bc0528864521899a31293073e)) - [@sRavioli](https://github.com/sRavioli)
- **(config:domains)** add wsl domain - ([69ec567](https://github.com/sRavioli/wezterm/commit/69ec5678134cc8aa429e19429506493472e54dc4)) - [@sRavioli](https://github.com/sRavioli)
- **(keys)** add various keybinds - ([a804ed2](https://github.com/sRavioli/wezterm/commit/a804ed24ae41cc00153d3c2358a1c7f760400d9e)) - [@sRavioli](https://github.com/sRavioli)
- **(wezterm)** load settings - ([d04a9c1](https://github.com/sRavioli/wezterm/commit/d04a9c1ba51c110e5787a502ee0d91d0481356df)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [0.0.2](https://github.com/sRavioli/wezterm/compare/0.0.1..0.0.2) - 2023-10-19
#### Bug Fixes
- **(config:font)** increase underline heigth - ([db21668](https://github.com/sRavioli/wezterm/commit/db216684548c587cf561b37f761e4f88e383f30f)) - [@sRavioli](https://github.com/sRavioli)
#### Features
- **(config:appearance)** add hyperlink rules, require colorschemes just once - ([35b12c5](https://github.com/sRavioli/wezterm/commit/35b12c57fdbdb859dd6269938eb79160b79d0ef1)) - [@sRavioli](https://github.com/sRavioli)
- **(config:general)** add some general configuration options - ([a2e42a1](https://github.com/sRavioli/wezterm/commit/a2e42a17ec4376466abd08baa9e902422c951737)) - [@sRavioli](https://github.com/sRavioli)
- **(config:window)** add window padding options - ([b6b495a](https://github.com/sRavioli/wezterm/commit/b6b495adc39cf23dbf4cbcbfe115bf5d435b14be)) - [@sRavioli](https://github.com/sRavioli)
- **(wezterm)** load configs - ([93473fd](https://github.com/sRavioli/wezterm/commit/93473fddc3cf854443259fe5256f5ed00178ba6a)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [0.0.1](https://github.com/sRavioli/wezterm/compare/1660c836279c83a7c0ec119e99d2960a9dbb70e7..0.0.1) - 2023-10-19
#### Bug Fixes
- **(colorschemes)** rename `colors` folder to `colorshemes` - ([09e7186](https://github.com/sRavioli/wezterm/commit/09e7186962a4d62f9df8cf845f8dbf85882db2e4)) - [@sRavioli](https://github.com/sRavioli)
- **(colorschemes:kanagawa)** reactivate kanagawa backround color - ([01a7372](https://github.com/sRavioli/wezterm/commit/01a737268dcaa2b13fae891cf4a1eed1a4c14538)) - [@sRavioli](https://github.com/sRavioli)
- **(config:font)** disable vertical bar style variation - ([ebca8ab](https://github.com/sRavioli/wezterm/commit/ebca8ab58622c6e8886b265fc89b57cfce9d048c)) - [@sRavioli](https://github.com/sRavioli)
- **(config:font)** move font config to it's own file - ([7c59a93](https://github.com/sRavioli/wezterm/commit/7c59a93d0ffe8e7611a23788cb77612c45fbfe62)) - [@sRavioli](https://github.com/sRavioli)
- **(config:gpu)** move gpu config to it's own file - ([5fae2d7](https://github.com/sRavioli/wezterm/commit/5fae2d77b28294d10a7df0560a4c5e5ee5512863)) - [@sRavioli](https://github.com/sRavioli)
- **(config:init)** add correct `config` usage - ([de8d86d](https://github.com/sRavioli/wezterm/commit/de8d86d62afc5b66a11e56850b658ddfa8b593f2)) - [@sRavioli](https://github.com/sRavioli)
#### Features
- **(colorscheme)** add kanagawa colorscheme from [`kanagawa.nvim`](https://github.com/rebelot/kanagawa.nvim/blob/master/extras/wezterm.lua) - ([1590c13](https://github.com/sRavioli/wezterm/commit/1590c13a7bd962a7ff8cceeb72029263e0a52b44)) - [@sRavioli](https://github.com/sRavioli)
- **(config:appearance)** add backgound color layer to improve acrylic effect - ([966d887](https://github.com/sRavioli/wezterm/commit/966d887fd3dc7770b2271ac1574b1a930a404c94)) - [@sRavioli](https://github.com/sRavioli)
- **(config:appearance)** add black transparent background, choose cpu - ([c05c588](https://github.com/sRavioli/wezterm/commit/c05c5880b8338ab79b3601361b67cc057496b1a9)) - [@sRavioli](https://github.com/sRavioli)
- **(config:appearance)** add appearance configurations - ([7f1c1ae](https://github.com/sRavioli/wezterm/commit/7f1c1aee3a0196cf396374d2706f0dc6e67127e4)) - [@sRavioli](https://github.com/sRavioli)
- **(config:bell)** add bell configuration - ([068684a](https://github.com/sRavioli/wezterm/commit/068684aa370424bc0ee6e1ed049ec55aee7a49d2)) - [@sRavioli](https://github.com/sRavioli)
- **(config:command-palette)** add config for command palette and charSelect - ([fb54f4c](https://github.com/sRavioli/wezterm/commit/fb54f4c72cae61bfd280bd24af8f04767aff6e68)) - [@sRavioli](https://github.com/sRavioli)
- **(config:cursors)** make cursor underline blink - ([3bd6964](https://github.com/sRavioli/wezterm/commit/3bd6964bfea74fe649b4798ea5a39715406bbf17)) - [@sRavioli](https://github.com/sRavioli)
- **(config:exit-behavior)** add exit behavior config - ([46b474b](https://github.com/sRavioli/wezterm/commit/46b474b8fecb6674f6eb68c5bc4d48e8b1468762)) - [@sRavioli](https://github.com/sRavioli)
- **(config:font)** add base config table for font, need to populate it - ([cb464cb](https://github.com/sRavioli/wezterm/commit/cb464cbcb05f6816c3269c5751128c430b830432)) - [@sRavioli](https://github.com/sRavioli)
- **(config:window)** add window appearance configuration - ([cedce79](https://github.com/sRavioli/wezterm/commit/cedce79a0350178dc238c02df453f9fa6b7f9c08)) - [@sRavioli](https://github.com/sRavioli)
- **(wezterm)** load additional modules - ([3279fd1](https://github.com/sRavioli/wezterm/commit/3279fd102f301564855ed504a59deb4629560045)) - [@sRavioli](https://github.com/sRavioli)
- **(wezterm)** unload old config modules - ([5c09600](https://github.com/sRavioli/wezterm/commit/5c0960065475f6cf7c4ba7a1a4ddf9342561fdb6)) - [@sRavioli](https://github.com/sRavioli)
- **(wezterm)** load new config modules - ([b987dd2](https://github.com/sRavioli/wezterm/commit/b987dd2648bc7af3f82fbb4890b3cdb8d315ff89)) - [@sRavioli](https://github.com/sRavioli)
- load wezterm config - ([440ee43](https://github.com/sRavioli/wezterm/commit/440ee43d7fdf004e3e4e55169a57c07a49236774)) - [@sRavioli](https://github.com/sRavioli)
- add functions to load config - ([198604a](https://github.com/sRavioli/wezterm/commit/198604a4f53b5d7fe97b77ae50921c300ce86316)) - [@sRavioli](https://github.com/sRavioli)
#### Miscellaneous Chores
- **(config:bell)** remove useless comment - ([449ab6a](https://github.com/sRavioli/wezterm/commit/449ab6ad9a643b0facef804bd840d212e622ff76)) - [@sRavioli](https://github.com/sRavioli)
- **(misc)** add release action, add cog and yamlfix config - ([2ad8489](https://github.com/sRavioli/wezterm/commit/2ad8489128c3909f5341a35aad9ffdb97a4dfd20)) - [@sRavioli](https://github.com/sRavioli)
- **(wezterm)** cleanup `wezterm.lua`, load options - ([17f11df](https://github.com/sRavioli/wezterm/commit/17f11dfd2f2f446e13284643d48691b3975984f1)) - [@sRavioli](https://github.com/sRavioli)
#### Refactoring
- **(config:Config)** rewrite `Config` methods, document them, use `wezterm.config_builder()` - ([7c02733](https://github.com/sRavioli/wezterm/commit/7c027332a9925bdd26cb189cb5b6004fcdd2517b)) - [@sRavioli](https://github.com/sRavioli)
- **(config:appearance)** move command palette and char select config to appearance - ([0764700](https://github.com/sRavioli/wezterm/commit/0764700bf216a8864b33f1152fd9c79bada6b33b)) - [@sRavioli](https://github.com/sRavioli)
- **(config:appearance)** move various configs to other files - ([7f9c256](https://github.com/sRavioli/wezterm/commit/7f9c2561a5ba99af5e379461d6aca4bd69ac1a6c)) - [@sRavioli](https://github.com/sRavioli)
- **(config:command-palette)** move command palette and char select config to appearance file - ([e606d50](https://github.com/sRavioli/wezterm/commit/e606d501afaccd46a289af478a49d87f0d5e9d30)) - [@sRavioli](https://github.com/sRavioli)
- **(config:init)** make usage example use markdown syntax - ([3329753](https://github.com/sRavioli/wezterm/commit/332975326fea44a06b442522cd164b6de1aeeac4)) - [@sRavioli](https://github.com/sRavioli)
- **(config:window)** remove useless comments - ([eea2e20](https://github.com/sRavioli/wezterm/commit/eea2e20f189854d2644fdcee79267cf76127c37e)) - [@sRavioli](https://github.com/sRavioli)

- - -

Changelog generated by [cocogitto](https://github.com/cocogitto/cocogitto).
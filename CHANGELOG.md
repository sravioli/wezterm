# Changelog

All notable changes to this project will be documented in this file. See [conventional commits](https://www.conventionalcommits.org/) for commit guidelines.

- - -
## [3.0.6](https://github.com/sRavioli/wezterm/compare/3.0.5..3.0.6) - 2024-01-24
#### Bug Fixes
- **(colors)** change kanagawa-lotus tab bar backround colors - ([dfe5c92](https://github.com/sRavioli/wezterm/commit/dfe5c921e5be7ddf86665d8f2f5762b8260aadf8)) - sravioli
- **(events:update-stauts)** display correct battery percentage, add padding - ([525881e](https://github.com/sRavioli/wezterm/commit/525881e2b8cb39da7ed156c2d06fbc6de3b7b313)) - sravioli
- **(mappings)** change leader key - ([6160705](https://github.com/sRavioli/wezterm/commit/61607051e20e0ba987ed8cdbddcdf0ca869d4529)) - sravioli
- **(utils:fun)** correctly retrieve the user home directory - ([3ed4dfd](https://github.com/sRavioli/wezterm/commit/3ed4dfdb4e6a6b78c384daad6fae16dded93fa18)) - sravioli
#### Features
- **(config:font)** add linux support - ([d0d309a](https://github.com/sRavioli/wezterm/commit/d0d309a008a7c3367a975fccc68f962154d8d7fb)) - sravioli
- **(config:general)** add linux support - ([7a68ea6](https://github.com/sRavioli/wezterm/commit/7a68ea648be556bcf1194264b8c438ed178bf886)) - sravioli
- **(events:lock-interface)** add event to lock the interface - ([d80dfe2](https://github.com/sRavioli/wezterm/commit/d80dfe21579f5bada297b0388f5cf1c3d2b33b88)) - sravioli
- **(events:update-status)** display real battery level - ([13b26cb](https://github.com/sRavioli/wezterm/commit/13b26cb9463a4a10ace1e485aaaca5e95bf1be8d)) - sravioli
- **(mappings)** add lock mode - ([0957fa8](https://github.com/sRavioli/wezterm/commit/0957fa8ad025f3858909352a87a872cdcffb8673)) - sravioli
- **(utils:fun)** add linux support, uppercase first letter of hostname - ([432e9ff](https://github.com/sRavioli/wezterm/commit/432e9ffe76148dfa539846da4d60e4502e9c5943)) - sravioli
- **(wezterm.lua)** source new event - ([e821785](https://github.com/sRavioli/wezterm/commit/e821785c17c8531082d0537a45b5880e76bb9193)) - sravioli
#### Miscellaneous Chores
- **(changelog)** format with markdownlint - ([bf8fd33](https://github.com/sRavioli/wezterm/commit/bf8fd33fa272468fc579783e926611faec4fd155)) - sravioli

- - -


## [3.0.5](https://github.com/sRavioli/wezterm/compare/3.0.4..3.0.5) - 2023-12-16

#### Bug Fixes

- **(config:general)** remove default program for Alpine - ([7b05ee2](https://github.com/sRavioli/wezterm/commit/7b05ee2dc7d90702f2da245f1b87cdb16667151e)) - [@sRavioli](https://github.com/sRavioli)
- **(events:format-tab-title)** don't render in fancy bar and with no bar, nil check icons - ([0743b90](https://github.com/sRavioli/wezterm/commit/0743b90cc58e3e31d99dbe216ac4728807be7e53)) - [@sRavioli](https://github.com/sRavioli)
- **(events:update-status)** add fancy tab bar support - ([9685c2a](https://github.com/sRavioli/wezterm/commit/9685c2abf3701612a847f37ae9729fa48cf69e64)) - [@sRavioli](https://github.com/sRavioli)
- **(mappings:default)** change leader key - ([fa46272](https://github.com/sRavioli/wezterm/commit/fa462726f598da1e3204b559f5aa57aebeba5796)) - [@sRavioli](https://github.com/sRavioli)
- **(mappings:modes)** change config initialization - ([11cc38c](https://github.com/sRavioli/wezterm/commit/11cc38c25e45ef69a51762311d0a739dc5413e34)) - [@sRavioli](https://github.com/sRavioli)
- **(utils:fun)** make `tbl_merge()` take a list of strings - ([e74ea0c](https://github.com/sRavioli/wezterm/commit/e74ea0cf3d8cc56a699d70141c08e869d2b60b74)) - [@sRavioli](https://github.com/sRavioli)

#### Features

- **(wezterm.lua)** load new config - ([49c6c55](https://github.com/sRavioli/wezterm/commit/49c6c5564ef97cffe6a99f7f1f5ebf19d177a509)) - [@sRavioli](https://github.com/sRavioli)
- merge config in config and mappings folder - ([1c7d50a](https://github.com/sRavioli/wezterm/commit/1c7d50a119b84e47d40ec63537c0b0422aadc04a)) - [@sRavioli](https://github.com/sRavioli)

#### Hotfixes

- **(config:general)** typo in wsl domains - ([4b88a75](https://github.com/sRavioli/wezterm/commit/4b88a75fd5987b15210133cb422c79e4489a9a22)) - [@sRavioli](https://github.com/sRavioli)

#### Refactoring

- **(utils:wcwidth)** rewrite portions of the wcwidth file - ([ba48223](https://github.com/sRavioli/wezterm/commit/ba48223a60333768a55e983404ae0608a9cebe5b)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [3.0.4](https://github.com/sRavioli/wezterm/compare/3.0.3..3.0.4) - 2023-12-15

#### Bug Fixes

- **(events:update-status)** check usable width with `<=` instead of `<` - ([c1c8972](https://github.com/sRavioli/wezterm/commit/c1c8972bd44ac66bfbaa177a4f2b1d8ccf19d4f9)) - [@sRavioli](https://github.com/sRavioli)
- **(mappings:default)** change leader key - ([5fa58a4](https://github.com/sRavioli/wezterm/commit/5fa58a47468bd608b21c203c9ed84ccf36b904f6)) - [@sRavioli](https://github.com/sRavioli)

#### Features

- **(events:format-window-title)** check for nvim and cmd - ([c078d40](https://github.com/sRavioli/wezterm/commit/c078d40587978de999cb855ba80e7daae4a4778c)) - [@sRavioli](https://github.com/sRavioli)
- **(mappings:default)** add mapping for quick window navigation - ([5994425](https://github.com/sRavioli/wezterm/commit/5994425d04439489f6ca60468b3043d4cdb84d08)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [3.0.3](https://github.com/sRavioli/wezterm/compare/3.0.2..3.0.3) - 2023-12-14

#### Bug Fixes

- **(events:update-status)** improve width calculation - ([6004de6](https://github.com/sRavioli/wezterm/commit/6004de6f683f959eaaccb1c1593a4e0629fa2807)) - [@sRavioli](https://github.com/sRavioli)
- embed showcase video - ([b31ab12](https://github.com/sRavioli/wezterm/commit/b31ab12c9437acd51d14d2bc87508dae7c09b719)) - [@sRavioli](https://github.com/sRavioli)

#### Features

- **(assets)** update flexible statusbar showcase - ([25c2c3e](https://github.com/sRavioli/wezterm/commit/25c2c3e46d4bcca888a8dea7d72433cae6d3574a)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [3.0.2](https://github.com/sRavioli/wezterm/compare/3.0.1..3.0.2) - 2023-12-14

#### Bug Fixes

- **(config:font)** don't adjust window size when changing font size - ([aa35df7](https://github.com/sRavioli/wezterm/commit/aa35df7b0869e1d7d7e9b5b5f950b0d044ba9207)) - [@sRavioli](https://github.com/sRavioli)
- **(config:font)** use correct nerd font fallback - ([7d2d1ff](https://github.com/sRavioli/wezterm/commit/7d2d1ffb3939c7f2790172c3cd5eea55fa8831c7)) - [@sRavioli](https://github.com/sRavioli)
- **(event:format-tab-title)** rename `opts` to `attributes` - ([c2fbfb9](https://github.com/sRavioli/wezterm/commit/c2fbfb97e875c698853f13da4a0fc31600b1fdd2)) - [@sRavioli](https://github.com/sRavioli)
- **(events:format-tab-title)** re-use nvim cmd hack - ([434e7d2](https://github.com/sRavioli/wezterm/commit/434e7d23fd9b48939a75d39673d81365514f8266)) - [@sRavioli](https://github.com/sRavioli)
- **(utils:fun)** use # operator for string length - ([de9f6e8](https://github.com/sRavioli/wezterm/commit/de9f6e8f692a775d2557d35eb321d5e21706f473)) - [@sRavioli](https://github.com/sRavioli)
- **(utils:layout)** documentation, add attributes option - ([7c390f0](https://github.com/sRavioli/wezterm/commit/7c390f08ebed776ced4e1aa56644330b44ba0bbb)) - [@sRavioli](https://github.com/sRavioli)
- remove copy mode indicator from tab title - ([6c9d1e2](https://github.com/sRavioli/wezterm/commit/6c9d1e2a14757725833e59c0e6e823c1f093ddd2)) - [@sRavioli](https://github.com/sRavioli)

#### Features

- **(events:update-status)** add 2 cells of padding from tab bar - ([a0b83d9](https://github.com/sRavioli/wezterm/commit/a0b83d9f361619a2d7193b41726023ff2d40ed4c)) - [@sRavioli](https://github.com/sRavioli)
- **(readme)** add README - ([a8f7f82](https://github.com/sRavioli/wezterm/commit/a8f7f82cc82e487a9969c961218879debfe6d1e6)) - [@sRavioli](https://github.com/sRavioli)

#### Hotfixes

- **(github)** wrong folder name for github workflows - ([2e0e69e](https://github.com/sRavioli/wezterm/commit/2e0e69e549d51e49194f9b2228b83505e8fa8c58)) - [@sRavioli](https://github.com/sRavioli)

#### Style

- **(mappings)** remove variable - ([e84c855](https://github.com/sRavioli/wezterm/commit/e84c855948a64f2ae601aa31cb7b2a0df4109eef)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [3.0.1](https://github.com/sRavioli/wezterm/compare/3.0.0..3.0.1) - 2023-12-14

#### Features

- update changelog - ([79a3f9b](https://github.com/sRavioli/wezterm/commit/79a3f9b0a8173cbecde6a697a1b3de33845af421)) - [@sRavioli](https://github.com/sRavioli)

#### Hotfixes

- **(github)** restore release action - ([37e5719](https://github.com/sRavioli/wezterm/commit/37e5719f93bf38cfda0682e7b31c7ea7d7eb75b8)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [3.0.0](https://github.com/sRavioli/wezterm/compare/2.1.2..3.0.0) - 2023-12-14

#### Bug Fixes

- **(colors)** remove catpuccin colorcheme, add colors to kanagawa themes - ([e6aead9](https://github.com/sRavioli/wezterm/commit/e6aead91b32bb9cd9e550823d517746a27dd0a50)) - [@sRavioli](https://github.com/sRavioli)
- **(config)** refactor config to use less files - ([a2be4b1](https://github.com/sRavioli/wezterm/commit/a2be4b1724911650725cd9a574fa22828eebf844)) - [@sRavioli](https://github.com/sRavioli)
- **(event:format-tab-title)** don't wrap in `setup()`, check nvim from foreground process - ([9139ff0](https://github.com/sRavioli/wezterm/commit/9139ff07b86564eee72918b286b25c2fe99f0488)) - [@sRavioli](https://github.com/sRavioli)
- **(event:format-window-title)** don't wrap `wezterm.on()` in a setup function - ([5765bf3](https://github.com/sRavioli/wezterm/commit/5765bf30d7c5223d7d4020635704cbb859b114d6)) - [@sRavioli](https://github.com/sRavioli)
- **(event:new-tab-button-click)** don't wrap `wezterm.on()` in a setup function - ([35f8cc2](https://github.com/sRavioli/wezterm/commit/35f8cc2cfdc697ba18ee8eeadd842fc60a671402)) - [@sRavioli](https://github.com/sRavioli)
- **(github)** typo in release workflow - ([b4e5087](https://github.com/sRavioli/wezterm/commit/b4e50876a4f7f4e4c85e7e191c71fce8f800d057)) - [@sRavioli](https://github.com/sRavioli)
- **(github)** typo in release workflow - ([a0a4b12](https://github.com/sRavioli/wezterm/commit/a0a4b12ef20d0274399c7b8ef8e3d4c77b52f8c0)) - [@sRavioli](https://github.com/sRavioli)
- **(stylua)** update stylua configuration - ([4287cb9](https://github.com/sRavioli/wezterm/commit/4287cb9cb99604127cf8e4ea8103e12ccf12f048)) - [@sRavioli](https://github.com/sRavioli)
- **(utils)** add config utils, `wcwidth()` and fix `Layout:new()` - ([936b008](https://github.com/sRavioli/wezterm/commit/936b008d375f618a6853c80b609638f3e2b8d10c)) - [@sRavioli](https://github.com/sRavioli)
- **(utils:fun)** rename to un.lua, add strwidth and key parser - ([7d1f7fc](https://github.com/sRavioli/wezterm/commit/7d1f7fc34841521e4c5bf6331d69dc3ccc4c4cce)) - [@sRavioli](https://github.com/sRavioli)
- remove changelog - ([161e264](https://github.com/sRavioli/wezterm/commit/161e2645c2b298128215b08277f9493ebe4bde1d)) - [@sRavioli](https://github.com/sRavioli)
- remove useless yamlfix - ([a4eaf51](https://github.com/sRavioli/wezterm/commit/a4eaf510893fc7d74c4a6361580ad20e4d8cec9b)) - [@sRavioli](https://github.com/sRavioli)
- remove current colorscheme file - ([5511725](https://github.com/sRavioli/wezterm/commit/55117256b5175d0a91a39b0a7fc7ff2b534f562d)) - [@sRavioli](https://github.com/sRavioli)

#### Features

- **(event:update-status)** add mode indicator, correctly calculate widths - ([a943b31](https://github.com/sRavioli/wezterm/commit/a943b310dce5ed57de82b43c05bcc68c9644c94c)) - [@sRavioli](https://github.com/sRavioli)
- **(mappings)** switch to vim-like mapping style, add modes - ([a08a2fa](https://github.com/sRavioli/wezterm/commit/a08a2fa9991928ca869a2429a9d22a1d8d11e511)) - [@sRavioli](https://github.com/sRavioli)
- **(wezterm.lua)** load new config - ([3ad7119](https://github.com/sRavioli/wezterm/commit/3ad7119ee008f9822b4776acb4d6ec518553107d)) - [@sRavioli](https://github.com/sRavioli)
- add .luarc.json - ([e0b51dd](https://github.com/sRavioli/wezterm/commit/e0b51ddc5e0651db24db6e78cf11b564d41eaeae)) - [@sRavioli](https://github.com/sRavioli)

#### Style

- format with stylua - ([85d1820](https://github.com/sRavioli/wezterm/commit/85d182058013d4d4b270a97c78cc6b9d4d937320)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [2.1.2](https://github.com/sRavioli/wezterm/compare/2.1.1..2.1.2) - 2023-12-08

#### Bug Fixes

- **(config:font)** add LegacyComputing font, reduce font size - ([309c6c2](https://github.com/sRavioli/wezterm/commit/309c6c2716b71cfa4eb54a33707df8c8ae030862)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [2.1.1](https://github.com/sRavioli/wezterm/compare/2.1.0..2.1.1) - 2023-11-17

#### Hotfixes

- **(wezterm.lua)** load new-tab-button-click event - ([31ee482](https://github.com/sRavioli/wezterm/commit/31ee4821acb4785b831b460f7630f020e5222311)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [2.1.0](https://github.com/sRavioli/wezterm/compare/2.0.10..2.1.0) - 2023-11-17

#### Bug Fixes

- **(colorschemes:kanagawa)** use correct bg and fg for tabs - ([9b62fc7](https://github.com/sRavioli/wezterm/commit/9b62fc7d4e28a21a79e02ea924c51b5b8f3b75d7)) - [@sRavioli](https://github.com/sRavioli)
- **(events:format-tab-title)** substitute `~` with home icon, remove useless stuff - ([7b29ee8](https://github.com/sRavioli/wezterm/commit/7b29ee8cfdc3deafb9e78567f7287ddf59bf79fa)) - [@sRavioli](https://github.com/sRavioli)

#### Documentation

- **(utils:functions)** format comment - ([199ce14](https://github.com/sRavioli/wezterm/commit/199ce14b4f3289c0d6976838998d2328916eda32)) - [@sRavioli](https://github.com/sRavioli)
- **(utils:layout)** add supported attributes for `layout:push()` - ([794bceb](https://github.com/sRavioli/wezterm/commit/794bcebd17b4ecc9e923cbb07a73c17fc0185207)) - [@sRavioli](https://github.com/sRavioli)
- **(utils:nerdfont-icons)** remove comments - ([851e82c](https://github.com/sRavioli/wezterm/commit/851e82c91bad20942b9b4a6c184e780a95cae4d6)) - [@sRavioli](https://github.com/sRavioli)

#### Features

- **(config:appearance)** enable the new tab button, style it - ([fe41c3a](https://github.com/sRavioli/wezterm/commit/fe41c3a50f805fdb7e4a45e6c9752b5b7aa84d26)) - [@sRavioli](https://github.com/sRavioli)
- **(events:new-tab-button-click)** launch wezterm launcher on left click of new tab button - ([64832c7](https://github.com/sRavioli/wezterm/commit/64832c708cc598ce721b9afcc04774674e957acc)) - [@sRavioli](https://github.com/sRavioli)
- **(events:update-status)** dynamically resolve status-bar rendering - ([17e948a](https://github.com/sRavioli/wezterm/commit/17e948a24837e46b9f085962f87905248fd436b9)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [2.0.10](https://github.com/sRavioli/wezterm/compare/2.0.9..2.0.10) - 2023-11-14

#### Bug Fixes

- **(config:window)** change window padding - ([2675a42](https://github.com/sRavioli/wezterm/commit/2675a4286aad5ce2b7bbc7e6e0d776489a671fb4)) - [@sRavioli](https://github.com/sRavioli)

#### Features

- **(config:font)** use MonaspaceRadon for italic and MonaspaceKrypton for bold-italic - ([63b0b3f](https://github.com/sRavioli/wezterm/commit/63b0b3fbd6be8b55658bffcef24ba26733ac6d6b)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [2.0.9](https://github.com/sRavioli/wezterm/compare/2.0.8..2.0.9) - 2023-11-11

#### Bug Fixes

- **(config:appearance)** remove `notification_handling` - ([501762c](https://github.com/sRavioli/wezterm/commit/501762cda6c24d4e74fb795fb9ac1ab05d1448de)) - [@sRavioli](https://github.com/sRavioli)

#### Features

- **(config:font)** use `font_with_fallback`, list all `harbuzz_features` - ([0549df4](https://github.com/sRavioli/wezterm/commit/0549df48e8e3e7bb359176c36c07148c12757240)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [2.0.8](https://github.com/sRavioli/wezterm/compare/2.0.7..2.0.8) - 2023-11-08

#### Features

- **(config:appearance)** suppress notification (only nightly builds) - ([9ed4b14](https://github.com/sRavioli/wezterm/commit/9ed4b14557e07f1864539f4622f5c64fa41f2e24)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [2.0.7](https://github.com/sRavioli/wezterm/compare/2.0.6..2.0.7) - 2023-11-04

#### Bug Fixes

- **(utils:layout)** use table mapping to check for attributes - ([4ce974f](https://github.com/sRavioli/wezterm/commit/4ce974f32dd990f76ee58e7afa5a71c33a33c05c)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [2.0.6](https://github.com/sRavioli/wezterm/compare/2.0.5..2.0.6) - 2023-11-02

#### Bug Fixes

- **(config:appearance)** make acrylic background a bit darker - ([f17d0a4](https://github.com/sRavioli/wezterm/commit/f17d0a4e416d8a100a31c135c799a69699933cb1)) - [@sRavioli](https://github.com/sRavioli)

- - -

## [2.0.5](https://github.com/sRavioli/wezterm/compare/2.0.4..2.0.5) - 2023-10-31

#### Bug Fixes

- **(utils:functions)** get `USERPROFILE` variable instead of combining two - ([10145fb](https://github.com/sRavioli/wezterm/commit/10145fb30b8aa2c25a29e4bceadae4ebfef84931)) - [@sRavioli](https://github.com/sRavioli)

#### Features

- make changing colorscheme easier - ([0531534](https://github.com/sRavioli/wezterm/commit/053153423b5c3741216d5d9eac466680a3377be5)) - [@sRavioli](https://github.com/sRavioli)

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

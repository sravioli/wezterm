# Changelog

All notable changes to this project will be documented in this file. See [conventional commits](https://www.conventionalcommits.org/) for commit guidelines.

- - -
## [6.3.4](https://github.com/sravioli/wezterm/compare/83e571ae02cbb604c0f22d733d532d612e99588e..6.3.4) - 2025-01-17
#### Bug Fixes
- update git clone for windows - ([83e571a](https://github.com/sravioli/wezterm/commit/83e571ae02cbb604c0f22d733d532d612e99588e)) - Dawen
#### Features
- **(update-status)** reduce complexity, add comments - ([3a42f56](https://github.com/sravioli/wezterm/commit/3a42f561bead94b993e2c7701633f65c374b4aa6)) - sravioli

- - -

## [6.3.3](https://github.com/sravioli/wezterm/compare/1950423c0ff727ce1436218cdbd08a37feed5210..6.3.3) - 2025-01-01
#### Bug Fixes
- **(update-status)** close #13 - ([e93d0af](https://github.com/sravioli/wezterm/commit/e93d0af12ba57e07d54b69affa9d169d70fee48c)) - sravioli
- battery on desktops - ([1950423](https://github.com/sravioli/wezterm/commit/1950423c0ff727ce1436218cdbd08a37feed5210)) - drzbida
#### Features
- **(icons)** add yazi icon - ([132ebe1](https://github.com/sravioli/wezterm/commit/132ebe11ae9aea447138f7a1274ec3c377487232)) - sravioli

- - -

## [6.3.2](https://github.com/sravioli/wezterm/compare/d49c76ebb93e229adc60b2b17e5bdc53cf2b2058..6.3.2) - 2024-11-24
#### Bug Fixes
- rename to fs.read_dir() to fs.ls_dir() also in docs - ([d49c76e](https://github.com/sravioli/wezterm/commit/d49c76ebb93e229adc60b2b17e5bdc53cf2b2058)) - sravioli
#### Features
- standardize picker messages and tab names - ([227583c](https://github.com/sravioli/wezterm/commit/227583cc13f74d7b00becc70d59488fbe9aa4648)) - sravioli

- - -

## [6.3.1](https://github.com/sravioli/wezterm/compare/447164147e155970af2be0abbefc2afe00e7d29e..6.3.1) - 2024-11-24
#### Bug Fixes
- **(utils:fn)** rename fs.read_dir() to fs.ls_dir() - ([f0d9193](https://github.com/sravioli/wezterm/commit/f0d9193bcd9fc7c4d6fcdf9cc6cb7e5b83cbbcec)) - sravioli
- correctly instanciate wezterm cache - ([4471641](https://github.com/sravioli/wezterm/commit/447164147e155970af2be0abbefc2afe00e7d29e)) - sravioli

- - -

## [6.3.0](https://github.com/sravioli/wezterm/compare/36ec0de9cd7b91b5de1ab3eb5cba7166ed897490..6.3.0) - 2024-11-22
#### Bug Fixes
- **(utils:gpu_adapter)** use correct class name - ([b20c03c](https://github.com/sravioli/wezterm/commit/b20c03c8022fbbb327a87c0b295d78e173c2bdd2)) - sravioli
- disable wrong linter warnings - ([36ec0de](https://github.com/sravioli/wezterm/commit/36ec0de9cd7b91b5de1ab3eb5cba7166ed897490)) - sravioli
#### Features
- **(logger)** also check for global enable_logging - ([506ba99](https://github.com/sravioli/wezterm/commit/506ba995859009359037132937fc8eeb5ea58e98)) - sravioli
- **(utils)** add gpu field, reorder comments - ([d50bb96](https://github.com/sravioli/wezterm/commit/d50bb961d1a0230386a7960f0b03417e2fa5a796)) - sravioli
- **(utils:class)** reorder comments - ([14f3308](https://github.com/sravioli/wezterm/commit/14f33081ee8847a00d89e981084f32a875a25753)) - sravioli
- improve statusbar flexibility (#19) - ([b382bb5](https://github.com/sravioli/wezterm/commit/b382bb5bd52593b7141e4900c6ddd678504967a4)) - [@sravioli](https://github.com/sravioli)
- use builtin tbl functions, minor optimizations - ([2beb355](https://github.com/sravioli/wezterm/commit/2beb355877044036593085d5c34fbae15cb2b222)) - sravioli
- organize utils better (#18) - ([8545605](https://github.com/sravioli/wezterm/commit/8545605c34bf17adf6c0c2bcfcf68eaa5bd3b390)) - [@sravioli](https://github.com/sravioli)
- use new utils.fn.tbl.merge() function - ([fa1ef35](https://github.com/sravioli/wezterm/commit/fa1ef3592a363bf51224eeb49b08aaa992c9eb10)) - sravioli
- use class instance logger - ([12ceca7](https://github.com/sravioli/wezterm/commit/12ceca7b657f2a5dc0ad57d898d2041459588392)) - sravioli
- refactor utils.fn to add more comments, improve performance - ([6f25268](https://github.com/sravioli/wezterm/commit/6f2526854b6a66f2d974b914d23f71e0888aa118)) - sravioli
- improve statusbar flexibility - ([d5ba634](https://github.com/sravioli/wezterm/commit/d5ba6340cc2b8d083db0929f9984dbcd9a088cd7)) - sravioli
#### Refactoring
- **(utils:gpu)** rename gpu_adapter to gpu - ([86ef9e5](https://github.com/sravioli/wezterm/commit/86ef9e5bcfe07321699e9cae3b7a8418b290a20b)) - sravioli

- - -

## [6.2.0](https://github.com/sravioli/wezterm/compare/b3d1a3fde7f874cd2ff90f70f716227cc41d7d7e..6.2.0) - 2024-11-17
#### Bug Fixes
- change tab title formatting signature - ([62ab5a0](https://github.com/sravioli/wezterm/commit/62ab5a05476d61f204a98c82b3e95c32235d50de)) - sravioli
- make fields optionals to silence linter warnings - ([e284fc0](https://github.com/sravioli/wezterm/commit/e284fc0c23b8553a0ee09f1c1daa10db264448cd)) - [@sravioli](https://github.com/sravioli)
- remove wcwidth (use wezterm.column.width) - ([b3d1a3f](https://github.com/sravioli/wezterm/commit/b3d1a3fde7f874cd2ff90f70f716227cc41d7d7e)) - sravioli
#### Features
- rewrite update-status, add icons, add workspace indicator - ([57d86d8](https://github.com/sravioli/wezterm/commit/57d86d8d25ae8581b871651be6bb086c07311aea)) - sravioli
- use new append function, adapt to format_tab_title signature - ([1c54511](https://github.com/sravioli/wezterm/commit/1c54511bc6028d1ae9fc04227cda417a21bef52e)) - sravioli
- add padl, padr, trim - ([3f64c57](https://github.com/sravioli/wezterm/commit/3f64c57ea1774317c571ead34d9582e4f1fea63a)) - sravioli
- add prepend function - ([17d72ea](https://github.com/sravioli/wezterm/commit/17d72ea30e4278f9da6475941b00098003979899)) - sravioli
- add new icons - ([3ac2a07](https://github.com/sravioli/wezterm/commit/3ac2a07efe472bd382de7075abc1183facba9088)) - sravioli
- add keymap to select new tab to open - ([ba524ab](https://github.com/sravioli/wezterm/commit/ba524ab9f644fdf507bcbeba544e09e63e2fe3ff)) - [@sravioli](https://github.com/sravioli)
- sort icons, change windows decorations for win - ([8e0c5e8](https://github.com/sravioli/wezterm/commit/8e0c5e82dbb6d11226e8a18b0bd931782207036c)) - [@sravioli](https://github.com/sravioli)
- minor perf tweaks - ([8bb2c5a](https://github.com/sravioli/wezterm/commit/8bb2c5afbc7f4ba9d605a4d53ddf71ddf396e3e3)) - sravioli

- - -

## [6.1.1](https://github.com/sravioli/wezterm/compare/5457911ae31620f8584c2c821d72811c8bf42acd..6.1.1) - 2024-11-08
#### Bug Fixes
- restore leader key - ([3d57fbe](https://github.com/sravioli/wezterm/commit/3d57fbedd32b6a687ab8ac6555911b6f4f87dd70)) - sravioli
#### Features
- rewrite gmemoize to actually work, add more memoization - ([5457911](https://github.com/sravioli/wezterm/commit/5457911ae31620f8584c2c821d72811c8bf42acd)) - sravioli

- - -

## [6.1.0](https://github.com/sravioli/wezterm/compare/995a31aed8ea58579e6edde900db98db894311d3..6.1.0) - 2024-11-02
#### Bug Fixes
- **(events:format-tab-title)** rm useless local - ([820566d](https://github.com/sravioli/wezterm/commit/820566da28a8ef9cacd29f24de5f4fc32fb4b45e)) - sravioli
- **(readme)** update links to files - ([991e4e9](https://github.com/sravioli/wezterm/commit/991e4e9f5bd61eb8a3f321a7b5d4874158806f80)) - [@sravioli](https://github.com/sravioli)
- **(utils:class)** update docs, minor fixes - ([985b21d](https://github.com/sravioli/wezterm/commit/985b21d712426f7e8113dd84b33a297c79c1c916)) - sravioli
- **(utils:config)** safe require of module, modify logging - ([1e9e092](https://github.com/sravioli/wezterm/commit/1e9e092a1bbb698293586d442eb4ed332bc7f3d2)) - sravioli
- **(utils:external)** move external libraries to separate folder - ([0a73acc](https://github.com/sravioli/wezterm/commit/0a73acc452af454f40461de58f0fa188d740dd8b)) - sravioli
- **(utils:fn)** simplify key.__has() function - ([9f9c726](https://github.com/sravioli/wezterm/commit/9f9c726541d143e407c47dbc76084bc90b82f5bf)) - sravioli
- **(utils:layout)** implement missing colors, add logging - ([d87355b](https://github.com/sravioli/wezterm/commit/d87355b4f968c92dd4d80cc040afe2c96019fe66)) - sravioli
- **(utils:logger)** enable logging by default at warn min level - ([f19daa5](https://github.com/sravioli/wezterm/commit/f19daa51a0dc5e380b79912424eb6f172466d583)) - sravioli
- status bar spacing, use wt.column_width - ([dff7b21](https://github.com/sravioli/wezterm/commit/dff7b214857ce345116705f65e7efb6d43b906f6)) - sravioli
- allow setting bg opacity (fixes #16) - ([923c39c](https://github.com/sravioli/wezterm/commit/923c39c8831fcb26e7c115327e8281149dff9fe8)) - sravioli
- add pick mode keymaps in readme - ([56e584f](https://github.com/sravioli/wezterm/commit/56e584f4753cfca559a5d49fe5445534caf23973)) - sravioli
- change colorscheme picker keymap in readme - ([995a31a](https://github.com/sravioli/wezterm/commit/995a31aed8ea58579e6edde900db98db894311d3)) - sravioli
#### Documentation
- **(utils:class)** update class documentation - ([277905e](https://github.com/sravioli/wezterm/commit/277905e96685225a5d6df4a2a7aa6eccb1c33ab3)) - sravioli
#### Features
- **(events)** add layout names for logging purposes - ([3695273](https://github.com/sravioli/wezterm/commit/36952733900967ff2da13956906bfeeb9d242f50)) - sravioli
- **(picker:colorscheme)** add layout name for logging purposes - ([6093714](https://github.com/sravioli/wezterm/commit/6093714ec103206c866c62f0a076e53cdf27ba1f)) - sravioli
- **(utils)** add logging - ([d1bcc4d](https://github.com/sravioli/wezterm/commit/d1bcc4d8f9e8793541a7e7ef920865b3632b321c)) - sravioli
- **(utils)** get mod name using `...` - ([d885d04](https://github.com/sravioli/wezterm/commit/d885d0470c0691cad45169fd57b58b5c93529ae2)) - sravioli
- **(utils:fn)** split key.map() fn in multiple ones - ([fe5b0f6](https://github.com/sravioli/wezterm/commit/fe5b0f6e7c1b4d570af7b4869cc0de9ee61edccb)) - sravioli
- **(utils:logger)** implement a logger - ([a5eac0c](https://github.com/sravioli/wezterm/commit/a5eac0c2d4daf2ae1de670e86ac7f49ba8c4be7b)) - sravioli
#### Hotfixes
- **(readme)** use correct require for map fn - ([4afadca](https://github.com/sravioli/wezterm/commit/4afadca0f03e38710f953873bb116aea982b8643)) - sravioli
#### Revert
- restore <M-\> as leader - ([f9cb72c](https://github.com/sravioli/wezterm/commit/f9cb72cf2346866338949f5851a70785307cdc9c)) - sravioli
#### Style
- **(.github)** rename to lowercase - ([2679fdb](https://github.com/sravioli/wezterm/commit/2679fdb08fb48382a2aa95b781ffe8d7906f42c6)) - sravioli

- - -

## [6.0.0](https://github.com/sravioli/wezterm/compare/1ec7b8140eaa487467454decc9090349f3fde4aa..6.0.0) - 2024-08-02
#### Bug Fixes
- **(.github)** linebreaks and formatting - ([9c80d09](https://github.com/sravioli/wezterm/commit/9c80d09ea7f445bbcee76f71af6dfea3da798267)) - sravioli
- **(event:update-status)** get more accurate tab title, update padding - ([898c0bc](https://github.com/sravioli/wezterm/commit/898c0bcfbc35b1a4b427c199e4adc93595f67796)) - sravioli
- **(events:augment-command-palette)** remove palette action to dump themes - ([bd746fa](https://github.com/sravioli/wezterm/commit/bd746facbcab533d0ea335f955551c0eeebbcc29)) - sravioli
- **(events:augment-command-palette)** add wezterm config_dir when concatenating path - ([8ace305](https://github.com/sravioli/wezterm/commit/8ace305928ec0fa1be5e18d23cd8f00e854757ea)) - sravioli
- **(events:format-tab-title)** use format tab title function - ([72e68a2](https://github.com/sravioli/wezterm/commit/72e68a213421bdee1900d2dcc0a98860b5871459)) - sravioli
- **(events:format-tab-title)** change how theme is retrieved - ([019459c](https://github.com/sravioli/wezterm/commit/019459ca81f15304dbc16ab3c6a6951f44a73174)) - sravioli
- **(events:update-status)** change font mode bg color - ([5145db3](https://github.com/sravioli/wezterm/commit/5145db399c97cbc5022455a0d569b930645d4930)) - sravioli
- **(mappings:modes)** set colorscheme picker key to `c`, remove picker from description - ([26be189](https://github.com/sravioli/wezterm/commit/26be1898327c8cd79aa42d917ca522d8151ef184)) - sravioli
- **(mappings:modes)** typo (rm ) - ([cf92888](https://github.com/sravioli/wezterm/commit/cf92888ed6828f7b150319ddbc9de0a9a8ba2f6b)) - sravioli
- **(mappings:modes)** typo (rm ) - ([d03ee30](https://github.com/sravioli/wezterm/commit/d03ee30cb6bdaf46f995ba1f5ade26294a799289)) - sravioli
- **(picker)** rm useless call to pathconcat - ([ff5c326](https://github.com/sravioli/wezterm/commit/ff5c326c4de70caf8d05e6213524f25be64d89a2)) - sravioli
- **(picker)** reimplement pickers with the new class - ([3aa8422](https://github.com/sravioli/wezterm/commit/3aa8422ccb3b958d3bbff7b8996bcb8a08a3a5ff)) - sravioli
- **(picker:colorschemes)** correct wrong id for tokyonight storm - ([f0594d4](https://github.com/sravioli/wezterm/commit/f0594d41b0f81178734a5bac4ae25d516d16ec73)) - sravioli
- **(picker:colorschemes)** capitalize harhacker label - ([c635fe6](https://github.com/sravioli/wezterm/commit/c635fe6d836654295f1af99beeed98c2e6b756b2)) - sravioli
- **(picker:font)** remove useless requires - ([ca54e5e](https://github.com/sravioli/wezterm/commit/ca54e5e2a4ac26d263a1a4e827442253c8561a5b)) - sravioli
- **(picker:font-size)** mv `font_size` `font-size` - ([37c6d5d](https://github.com/sravioli/wezterm/commit/37c6d5d502c0e105aa70f73ed06792556415f12b)) - sravioli
- **(picker:fonts)** use more expressive label for font reset - ([e872032](https://github.com/sravioli/wezterm/commit/e8720327ff9525d1e9a9397fa4611decdec33c03)) - sravioli
- **(picker:leading)** module path, give credit - ([7b9f6fa](https://github.com/sravioli/wezterm/commit/7b9f6fa9168ff628a26336cd55323bffdfd5bc10)) - sravioli
- **(readme)** update note block - ([c8e0d4b](https://github.com/sravioli/wezterm/commit/c8e0d4b705e86c421515bf27f6015921d07842dd)) - sravioli
- **(utils:fn)** use builtin format method to format layout - ([4285301](https://github.com/sravioli/wezterm/commit/428530160c9c5ff0cebfaba1a2005a68faaf0596)) - sravioli
- **(utils:fn)** nil check dirs_read cache - ([a2cbaff](https://github.com/sravioli/wezterm/commit/a2cbaff8f2f165f98031f108da61c5236693cf61)) - sravioli
- **(utils:fn)** correctly return early when reading dirs - ([19096b7](https://github.com/sravioli/wezterm/commit/19096b7ffc8cf3214ae5f0472d0e0a55350ae65c)) - sravioli
- **(utils:fn)** correctly handle file creation, implement caching - ([287ed24](https://github.com/sravioli/wezterm/commit/287ed240b0838e624fc83d8c003cac48c5701f78)) - sravioli
- **(utils:fn)** rm leading dot from filename, check file - ([9aaec0e](https://github.com/sravioli/wezterm/commit/9aaec0e6e245366a7ac950b4021aa099b6da9011)) - sravioli
- **(utils:fn)** change read_dir function to pipe to file - ([55eefbe](https://github.com/sravioli/wezterm/commit/55eefbef81b0481220f1fb77f4a6a9ecb9260776)) - sravioli
- **(utils:fn)** rm useless fn, implement fs and colors utils - ([a4eef08](https://github.com/sravioli/wezterm/commit/a4eef086ab942501d0a2cfbe7c9cda594e645805)) - sravioli
- **(utils:layout)** correctly format the layout - ([0aa37d4](https://github.com/sravioli/wezterm/commit/0aa37d48c45a3cbc5863670c6ec10928efc14486)) - sravioli
- **(wezterm.lua)** remove comment - ([65e2d5a](https://github.com/sravioli/wezterm/commit/65e2d5a7d0b317b84702dd9d6ee962cc072c3201)) - sravioli
- resolve merge conflicts - ([600b2b3](https://github.com/sravioli/wezterm/commit/600b2b3c20e88f3c4f01b4dae4a8a8afe50e5b16)) - sravioli
- resolve merge conflicts - ([8c98c2f](https://github.com/sravioli/wezterm/commit/8c98c2fae27714d61c034a1cec2c3c9f7b3d0fcd)) - sravioli
- upload statusbar showcase as gh cdn - ([4d4e27b](https://github.com/sravioli/wezterm/commit/4d4e27b8708880d91888e33fb8ba74f225a5d0ff)) - [@sravioli](https://github.com/sravioli)
- rename `leading` `font-leading` - ([12d1ff4](https://github.com/sravioli/wezterm/commit/12d1ff48d97fb3e34ba063f66d30a8f9a1ef66a3)) - sravioli
- rm outdated file - ([d7ea341](https://github.com/sravioli/wezterm/commit/d7ea341c899fb663138ef96bb651a5791ceb4f97)) - sravioli
- delete useless comments - ([c0e5645](https://github.com/sravioli/wezterm/commit/c0e564546b839fb23f4a74383fdeac1ea7afcd97)) - Adam K
- delete useless comments - ([f5ee737](https://github.com/sravioli/wezterm/commit/f5ee73776a5b8f88c96af513fb3c87a969f62591)) - Adam K
- not supposed to be in this branch... - ([c91689b](https://github.com/sravioli/wezterm/commit/c91689b6105b4db1333fa9f7d8459fcbf43cf29f)) - Adam K
#### Documentation
- **(utils:fn)** add `pathconcat` documentation - ([4138474](https://github.com/sravioli/wezterm/commit/413847438bb16a86a4d0f184d88c3a0c15154491)) - sravioli
- cleanup, ignore diagnostics false-positives, add docs - ([21bab7a](https://github.com/sravioli/wezterm/commit/21bab7a8d975aaa38e3d1e11c26be8b4c1cc64c5)) - sravioli
#### Features
- **(README)** add refactor notice - ([88e10d5](https://github.com/sravioli/wezterm/commit/88e10d5eef0a180fb3465738b60b845694fa2844)) - sravioli
- **(colorschemes)** add tokyonight colors - ([5622865](https://github.com/sravioli/wezterm/commit/5622865dd00a07df07c793c565e9d21b9530a562)) - sravioli
- **(events:augment-command-palette)** add pickers to command palette - ([65e8824](https://github.com/sravioli/wezterm/commit/65e88243a7bb7800eb4ac15412bdcbb1ff12c59b)) - sravioli
- **(events:augment-command-palette)** add theme builder command - ([aaa7d8c](https://github.com/sravioli/wezterm/commit/aaa7d8cfab0ef702bf0661d302566bef1d587c8c)) - sravioli
- **(events:update-status)** update modes table - ([7154c09](https://github.com/sravioli/wezterm/commit/7154c09b67a6be5a6d899c6e059d79cac7a9f6bf)) - sravioli
- **(mappings:modes)** update to new colorscheme picker - ([4936c92](https://github.com/sravioli/wezterm/commit/4936c92e2743bbb1b350bb7775f8ffe155af575d)) - sravioli
- **(pick-lists:colorschemes)** add dracula & catppuccin variants - ([546e796](https://github.com/sravioli/wezterm/commit/546e7965e99309261d4989549a5f7ce03025504d)) - sravioli
- **(pick-lists:colorschemes)** add rosé pine variants - ([3536c00](https://github.com/sravioli/wezterm/commit/3536c0032d5f562f07c86504070a82f60816dfb7)) - sravioli
- **(pick-lists:font-sizes)** move to pick-lists folder, adapt to new picker - ([2e85e44](https://github.com/sravioli/wezterm/commit/2e85e44b9ffda8fe063e54272af0c747dbd0a6e6)) - sravioli
- **(picker:colorscheme)** update colorscheme picker - ([0ceaa57](https://github.com/sravioli/wezterm/commit/0ceaa57d50a4c82ca119db5ea1b46f8ab46ab183)) - sravioli
- **(picker:colorscheme)** change color of label - ([22a734f](https://github.com/sravioli/wezterm/commit/22a734f0032b18bb239ce20fdbeef8812d169ccd)) - sravioli
- **(picker:colorscheme)** streamline colorscheme picker, change var names - ([d3d0546](https://github.com/sravioli/wezterm/commit/d3d05467122660d2f4133497f5869a00bf1071aa)) - sravioli
- **(picker:colorscheme)** change palette display - ([7c0e242](https://github.com/sravioli/wezterm/commit/7c0e24241edf87273ee3e66e55a26b8b2fa821ef)) - sravioli
- **(picker:colorschemes)** add colors for missing fields - ([a171b00](https://github.com/sravioli/wezterm/commit/a171b0047cbe590f1c03a340f84aa89b652d0cce)) - sravioli
- **(picker:colorschemes)** port poimandres theme - ([9f21132](https://github.com/sravioli/wezterm/commit/9f21132280412c334eb026ae0ffa8520f1e5c8f1)) - sravioli
- **(picker:colorschemes)** port hardhacker theme - ([329451e](https://github.com/sravioli/wezterm/commit/329451e782d3249d15850f7cf397de4657b44aef)) - sravioli
- **(picker:colorschemes)** port eldritch theme - ([66a00c6](https://github.com/sravioli/wezterm/commit/66a00c6af49709ed11a8f8bbde3e181c4c35a4e0)) - sravioli
- **(picker:colorschemes)** port bamboo themes - ([0585f5d](https://github.com/sravioli/wezterm/commit/0585f5dba128413da08e753b22873b78058e73f5)) - sravioli
- **(picker:colorschemes)** port nightfox themes - ([ec9d8f0](https://github.com/sravioli/wezterm/commit/ec9d8f0c4db5632061cfe97a56170df16aa9ba36)) - sravioli
- **(picker:font)** re-implement font picker - ([f811d5c](https://github.com/sravioli/wezterm/commit/f811d5ccc0a80d526ec3fa27e123b2b1c540735e)) - sravioli
- **(picker:font-size)** rm useless require - ([bd84f3b](https://github.com/sravioli/wezterm/commit/bd84f3b94d88cc4572e47f1bac94fcad5c91cd43)) - sravioli
- **(picker:font_size)** Add a picker for selecting font size - ([bcfb3fd](https://github.com/sravioli/wezterm/commit/bcfb3fdacc52c4a967fb70e8beb9a515e77ffc93)) - Adam K
- **(picker:leading)** Dynamically pick line heightI find this one very useful when moving between workspaces withdifferent size monitors/screens - ([3d2df04](https://github.com/sravioli/wezterm/commit/3d2df042f9bc5b4edce4e349da9a981bf68a9eed)) - Adam K
- **(pr)** merge branch 'akthe-at-main' - ([562d74a](https://github.com/sravioli/wezterm/commit/562d74aa2f0b4e75704d89eac3beb517039db776)) - sravioli
- **(readme)** add status bar showcase - ([a149e2a](https://github.com/sravioli/wezterm/commit/a149e2ae0bb13d4ca1dd144c959626a1a0af8198)) - sravioli
- **(themes)** Adds rose pine to theme picker - ([abb8c42](https://github.com/sravioli/wezterm/commit/abb8c42f0fd8ca9b4e04f52017ac03c8d7474c3d)) - [@sravioli](https://github.com/sravioli)
- **(themes)** Adds rose pine to theme picker - ([1ec7b81](https://github.com/sravioli/wezterm/commit/1ec7b8140eaa487467454decc9090349f3fde4aa)) - Adam K
- **(utils:class)** add picker docs - ([70ebd03](https://github.com/sravioli/wezterm/commit/70ebd03d95b44fdcbee96c5213827009e3014838)) - sravioli
- **(utils:fn)** move tab title formatting - ([2d5a551](https://github.com/sravioli/wezterm/commit/2d5a55161dfb9868074483c51c367ebb1f65c5df)) - sravioli
- **(utils:fn)** upgrade gmemoize to handle non-fn values, gmemoize more stuff - ([ecaee0a](https://github.com/sravioli/wezterm/commit/ecaee0a53cbef621b6456fab435d4d9764713a87)) - sravioli
- **(utils:fn)** implement basic "memoization" using `wezterm.GLOBAL` - ([2d64360](https://github.com/sravioli/wezterm/commit/2d6436032780b55c36fef35dfbe0d0fdb393418f)) - sravioli
- **(utils:fn)** adapt to new picker path - ([d21ae41](https://github.com/sravioli/wezterm/commit/d21ae4171d99b4d585574e7f106d68878995872b)) - sravioli
- **(utils:fn)** impl pathconcat and fn to make themes compatible w/ cfg - ([f011a92](https://github.com/sravioli/wezterm/commit/f011a9298c585e6b93e23f587bf1b40086026553)) - sravioli
- **(utils:fn)** implement a table dump function - ([6e57004](https://github.com/sravioli/wezterm/commit/6e570047aa9611762e20e482b4b4748af3b3c6bd)) - sravioli
- **(utils:picker)** improve readability of `pick()` method - ([6d88728](https://github.com/sravioli/wezterm/commit/6d887288dc63583839a6dc54091d967586406385)) - sravioli
- **(utils:picker)** pass to build fn window and pane objects - ([693e386](https://github.com/sravioli/wezterm/commit/693e386da5dcf2044b30f3b0053cb42bf4d55144)) - sravioli
- **(utils:picker)** add documentation, adjust some functions - ([d8d2c29](https://github.com/sravioli/wezterm/commit/d8d2c291a880ce6519e4617bd54164f46f7b9eec)) - sravioli
- **(utils:picker)** re-implement a picker - ([7033c6e](https://github.com/sravioli/wezterm/commit/7033c6e229d317f69d52c79b81e7b185453fb9ff)) - sravioli
- re-enable format-tab-title event - ([3348d3a](https://github.com/sravioli/wezterm/commit/3348d3a3848356fc629cb77b426bbd2b651ea338)) - sravioli
- merge branch 'main' of https://github.com/sravioli/wezterm - ([09bb3f9](https://github.com/sravioli/wezterm/commit/09bb3f9cc3f972e20e9296ca4b212c1c82f35c9d)) - sravioli
#### Hotfixes
- **(events:update-status)** enable flexible status bar (disabled for showcase) - ([62a8150](https://github.com/sravioli/wezterm/commit/62a815069bac02ebd25f5c9d7838eb95b9f94075)) - sravioli
- **(readme)** update link - ([1f839f1](https://github.com/sravioli/wezterm/commit/1f839f156db282310f1b1dd087dd41649070c9c0)) - sravioli
- **(readme)** update imgs link - ([2cc5c7a](https://github.com/sravioli/wezterm/commit/2cc5c7a161c5554a7caa5c72ffb4ecaa395a5256)) - sravioli
- **(utils:fn)** change command to read directory on windows - ([7ce516d](https://github.com/sravioli/wezterm/commit/7ce516d9c42167624d370b09a9b75342ff602c56)) - sravioli
#### Refactoring
- **(pick-lists:colorschemes)** move colorschemes to pick list folder, adapt to picker syntax - ([d963e7a](https://github.com/sravioli/wezterm/commit/d963e7a8162c0c7c8c576a8605278b9eba1b046d)) - sravioli
#### Style
- **(picker:colorschemes)** formatting - ([f53789d](https://github.com/sravioli/wezterm/commit/f53789d7cfe30e04ee39031a03449249cd781400)) - sravioli
#### Tests
- **(utils:fn)** try to solve popup problem on windows - ([b84ea68](https://github.com/sravioli/wezterm/commit/b84ea68c911acd74b02786864fdb5f55da04efc0)) - unknown

- - -

## [5.2.2](https://github.com/sravioli/wezterm/compare/caf9a2be4b599cbf0bff2d9419ed2cc44d364786..5.2.2) - 2024-07-21
#### Bug Fixes
- **(colors:kanagawa-wave)** change active tab bg color - ([ab7881e](https://github.com/sravioli/wezterm/commit/ab7881ee1774d7bf948d6959f8d48a9b3116d1fb)) - sravioli
- **(config:appearance)** enable resize decorations only on windows - ([249f2e5](https://github.com/sravioli/wezterm/commit/249f2e50b5ad8b68f79e1f956a732c80ff4052cc)) - sravioli
- **(events:format-tab-title)** update to new utils - ([fb86efa](https://github.com/sravioli/wezterm/commit/fb86efa02dbce3f843227e9dd6253deb539a04bc)) - sravioli
- **(utils:fn)** usa local variable to cache colorschemes - ([55d9aa7](https://github.com/sravioli/wezterm/commit/55d9aa782e77f3cdb93e398b59b59f35f606d535)) - sravioli
- **(utils:fn)** cache colorscheme values - ([caf9a2b](https://github.com/sravioli/wezterm/commit/caf9a2be4b599cbf0bff2d9419ed2cc44d364786)) - sravioli
- **(wezterm.lua)** disable format-tab-title event due to performance - ([0bce154](https://github.com/sravioli/wezterm/commit/0bce154266db69b5f3159323f0372763c9bf0b18)) - sravioli
#### Features
- **(picker:theme)** add color palettes to themes - ([42a01fe](https://github.com/sravioli/wezterm/commit/42a01fe7557f9ea38b6f98bc628bd1af122445bb)) - sravioli

- - -

## [5.2.1](https://github.com/sravioli/wezterm/compare/778e44ff4c56b6a85833451d005a085a8da216d5..5.2.1) - 2024-07-19
#### Hotfixes
- **(mappings)** enable the theme picker - ([778e44f](https://github.com/sravioli/wezterm/commit/778e44ff4c56b6a85833451d005a085a8da216d5)) - sravioli

- - -

## [5.2.0](https://github.com/sravioli/wezterm/compare/710aa39c85cd4574b40cf6e7b6ebaa81aea74276..5.2.0) - 2024-07-19
#### Bug Fixes
- **(colors:kanagawa-dragon)** tab bar now has the same color - ([8d964b2](https://github.com/sravioli/wezterm/commit/8d964b2603059077c9574feed501a3e716fd5d7a)) - sravioli
- **(config:gpu)** extract battery info to variable - ([9b25d7a](https://github.com/sravioli/wezterm/commit/9b25d7a22a3ff0ae6503a2d7cb1de268c360b8e0)) - sravioli
- **(events:augment-command-palette)** rm useless config variable - ([1b7e943](https://github.com/sravioli/wezterm/commit/1b7e943acde72d1a132a0a8efbfab4cf3662291a)) - sravioli
- **(events:format-tab-title)** update to new fn file, get theme dynamically - ([7e27b83](https://github.com/sravioli/wezterm/commit/7e27b83b51dc1dfc83f9310e9910f4f76d45d1a2)) - sravioli
- **(events:format-window-title)** update to new fn file - ([7dbdb40](https://github.com/sravioli/wezterm/commit/7dbdb4058c6dfe9b35902435d2b0971e91cf2335)) - sravioli
- **(events:lock-interface)** remove useless lock event - ([6b20383](https://github.com/sravioli/wezterm/commit/6b203838ce2aad4e48715df0634dcfb8a51735b5)) - sravioli
- **(events:update-status)** update to new fn file, don't use ipairs - ([424ca5d](https://github.com/sravioli/wezterm/commit/424ca5d5345edda43a69340b2300286716cb006b)) - sravioli
- **(mappings:default)** update to new fn file - ([bfa37c2](https://github.com/sravioli/wezterm/commit/bfa37c285708b58f4d4c7ddc0d9bba95b690ebc8)) - sravioli
- **(mappings:init.lua)** update to new fn file - ([67e8cd4](https://github.com/sravioli/wezterm/commit/67e8cd44eb259d5c94c24dba5a68d6e8643e4d26)) - sravioli
- **(mappings:modes)** rm lock interface keymap - ([136c524](https://github.com/sravioli/wezterm/commit/136c524e476c08f477a3691c85af6b3cb42d732d)) - sravioli
- **(mappings:modes)** update to new fn file - ([b670ac3](https://github.com/sravioli/wezterm/commit/b670ac384a8a8d582c4b09d64d337463242f4025)) - sravioli
- **(utils:class)** update icons class name - ([d97ed99](https://github.com/sravioli/wezterm/commit/d97ed99612ad2583ddad27523d2cdf241f526c1c)) - sravioli
- **(utils:class)** rm useless logs, change class name - ([77e9249](https://github.com/sravioli/wezterm/commit/77e92492d7f752990ed3d979eeafbf1382a151aa)) - sravioli
- **(utils:class)** change config class name - ([51ad0bd](https://github.com/sravioli/wezterm/commit/51ad0bd8a199588b3555b08b74d642498201472d)) - sravioli
- **(utils:fn)** change `fun.lua` to `fn.lua`, divide by classes - ([507007b](https://github.com/sravioli/wezterm/commit/507007b44b033aa928c392bcf5fae1b0ee36ab8a)) - sravioli
- **(utils:gpu_adapter)** update to new fn file - ([fdd6d47](https://github.com/sravioli/wezterm/commit/fdd6d47e5be73be9afcbc6b2858dfd55c1f9add7)) - sravioli
- **(utils:icons)** move to class folder - ([197ae1e](https://github.com/sravioli/wezterm/commit/197ae1e84a0bf87e1ea3dadb488013252befc91b)) - sravioli
- **(utils:modes-list)** remove separate file for mode list - ([393a9c7](https://github.com/sravioli/wezterm/commit/393a9c7763e8e47566d5f257c18476688d70f8bb)) - sravioli
- **(wezterm.lua)** rm spacing - ([b875d14](https://github.com/sravioli/wezterm/commit/b875d142e4502122c3567496df0468067c94af28)) - sravioli
- rm .luarc.json - ([a6e4950](https://github.com/sravioli/wezterm/commit/a6e4950f7546c5975c2acbb19d85c65bce365d8d)) - sravioli
#### Features
- **(config:appearance)** adapt to new fn file - ([cd4dc5a](https://github.com/sravioli/wezterm/commit/cd4dc5a8c25bc9ec99fd0b1fb6ca34f9e1082e03)) - sravioli
- **(config:font)** adapt to new fn file - ([24725a2](https://github.com/sravioli/wezterm/commit/24725a29ebb6755e2c68a414d583642ab25abf28)) - sravioli
- **(config:general)** adapt to new fn file - ([0df811e](https://github.com/sravioli/wezterm/commit/0df811e03c4907024358265d7a5970afd2826a19)) - sravioli
- **(config:general)** add spacing between imports - ([3986aa5](https://github.com/sravioli/wezterm/commit/3986aa569a08d4945eb63a9dc7756fc5b8e1d26c)) - sravioli
- **(config:gpu)** switch to low power mode when battery is low - ([cb21880](https://github.com/sravioli/wezterm/commit/cb21880b74524762b2195ec4397a77382e9528b8)) - sravioli
- **(config:init.lua)** adapt to new fn file - ([a34f96b](https://github.com/sravioli/wezterm/commit/a34f96bb7c299e2257b07b473122c02b6737a775)) - sravioli
- **(picker:theme)** implement a theme picker - ([694a1c8](https://github.com/sravioli/wezterm/commit/694a1c8267198b4914a81f617c99664aff9f348f)) - sravioli
- **(utils:class)** move utility classes to separate folder - ([641e83c](https://github.com/sravioli/wezterm/commit/641e83c9e4ad3710cc910de7d93fae1e46e31e23)) - sravioli
- **(utils:layout)** add clear method for Layout - ([710aa39](https://github.com/sravioli/wezterm/commit/710aa39c85cd4574b40cf6e7b6ebaa81aea74276)) - sravioli

- - -

## [5.1.1](https://github.com/sravioli/wezterm/compare/2c59e48069895b1cf8ab053382bfd7dad5dd12d0..5.1.1) - 2024-07-07
#### Bug Fixes
- **(config:font)** disable font stretch for italics - ([41d54cd](https://github.com/sravioli/wezterm/commit/41d54cd3e9ccdf2fc43760cb50d45c7c8148757a)) - sravioli
- **(utils:fun)** rename wez to wt - ([1a61d2e](https://github.com/sravioli/wezterm/commit/1a61d2e516b5bbaaaa32353d5be27eaeab39887a)) - sravioli
- rename wez to wt - ([64974e8](https://github.com/sravioli/wezterm/commit/64974e8b0d78f115c9b349197efcf0e78f32ff62)) - sravioli
- improve contributing body - ([4425de2](https://github.com/sravioli/wezterm/commit/4425de2b308a64e8eb7e5c8fba5260f9092bb9e6)) - sravioli
#### Features
- **(utils:config)** add documentation and logging - ([c81fc41](https://github.com/sravioli/wezterm/commit/c81fc418ed59139c6fd61bbfe98401b77bd30280)) - sravioli
- add documentation and logging - ([7140548](https://github.com/sravioli/wezterm/commit/7140548088b89d1d0048857c2054ca9efd51d2cf)) - sravioli
#### Hotfixes
- incorrect path to contributing file from pr template - ([2bf6875](https://github.com/sravioli/wezterm/commit/2bf68750f5c8b18fdaa24c4bed53257ad19b2ecf)) - sravioli
#### Style
- **(mapping:modes)** add vim folds - ([2c59e48](https://github.com/sravioli/wezterm/commit/2c59e48069895b1cf8ab053382bfd7dad5dd12d0)) - sravioli

- - -

## [5.1.0](https://github.com/sravioli/wezterm/compare/4c1e5280db288cdbc5b9ad41830ebd93b09ea871..5.1.0) - 2024-07-03
#### Bug Fixes
- **(utils:modes-list)** rename file, remove mappings table, add padding - ([e7fa846](https://github.com/sravioli/wezterm/commit/e7fa846adbfff32e8c8c483f5e94ca0b93647147)) - sravioli
- get current scheme from config - ([2e11c6b](https://github.com/sravioli/wezterm/commit/2e11c6b496bfbde0fc13e644c15f4f27a40fc18f)) - sravioli
#### Features
- **(events:update-status)** change the source of mappings table - ([eb19548](https://github.com/sravioli/wezterm/commit/eb195481f88e17e4885c10019c22df08c82d53f1)) - sravioli
- **(utils:fun)** add padding function - ([adff13f](https://github.com/sravioli/wezterm/commit/adff13fbe1785eb51eb4b18f4ad07a0d08b2f377)) - sravioli
- change mapping definition, add descriptions - ([fd46ab9](https://github.com/sravioli/wezterm/commit/fd46ab9b335a51076fae86fadf75d54bafcb9b26)) - sravioli
#### Hotfixes
- **(readme)** change leader key value, fix file name - ([06b09ac](https://github.com/sravioli/wezterm/commit/06b09ac710bb19690e22d49a9ca2becc53376ea0)) - sravioli
- add missing asset - ([4c1e528](https://github.com/sravioli/wezterm/commit/4c1e5280db288cdbc5b9ad41830ebd93b09ea871)) - sravioli
#### Refactoring
- **(utils:layout)** move insert declaration - ([7520197](https://github.com/sravioli/wezterm/commit/75201977f714f656091b1c90f43f2160f3d4d2e7)) - sravioli

- - -

## [5.0.0](https://github.com/sravioli/wezterm/compare/fc631022c60027a0461db747782d4c936fb47350..5.0.0) - 2024-07-02
#### Bug Fixes
- **(README)** streamline key tables by removing dupes - ([112a55a](https://github.com/sravioli/wezterm/commit/112a55a3a507c8f3c04f8752972e0d6ac160635b)) - sravioli
- **(mappings:default)** CHANGE LEADER TO `C-Space` - ([894a104](https://github.com/sravioli/wezterm/commit/894a104e23ad0cce08f8dd9285526325e1072b49)) - sravioli
- **(mappings:modes)** remove redundant keymaps - ([0d805e3](https://github.com/sravioli/wezterm/commit/0d805e3f96099c8784e5f01431fd13aa15353fdb)) - sravioli
#### Features
- **(events:update-status)** add flexible modal prompts when invoking key tables - ([6976650](https://github.com/sravioli/wezterm/commit/69766500cab51b80507d96e39a02b380be4993dc)) - sravioli
- **(mappings)** add help mode key table - ([116c743](https://github.com/sravioli/wezterm/commit/116c743349acc75dcd3f9a6d7e83e2afb65da008)) - sravioli
- **(utils:icon)** add separator for modal prompt - ([9142bd3](https://github.com/sravioli/wezterm/commit/9142bd3243eb1d6a0c2eed6974103c5ac925af30)) - sravioli
- **(utils:modes_list)** move modes list, add keymap list and descr - ([8b32196](https://github.com/sravioli/wezterm/commit/8b3219688bc36d877cac548e7acc78631a52c6f5)) - sravioli
- document the new modal prompts in the README - ([83f9f82](https://github.com/sravioli/wezterm/commit/83f9f82f8f27dfcd4406085249ce5accc16fef40)) - sravioli
#### Hotfixes
- **(cocogitto)** add the remote name - ([fc63102](https://github.com/sravioli/wezterm/commit/fc631022c60027a0461db747782d4c936fb47350)) - sravioli

- - -

## [4.1.0](https://github.com/sravioli//compare/9222ba36fa40e458dd5ff5cf6b719045c3c90504..4.1.0) - 2024-07-01
#### Bug Fixes
- do not automatically fallback to dark mode - ([5db3d26](https://github.com/sravioli//commit/5db3d260ba1d1d5d7b477246c5f27d5d9a627682)) - sravioli
- remove `fun.in_windows()` function - ([e181391](https://github.com/sravioli//commit/e181391744a5a3dac1837b12d174f6a4401bc852)) - sravioli
#### Features
- **(README)** thanks KevinSilvester! - ([f492b9d](https://github.com/sravioli//commit/f492b9d1a48f36a88e09df3d491e56948ba2a7a3)) - sravioli
- **(utils:fun)** add function to determine platform - ([55847ed](https://github.com/sravioli//commit/55847edd50715003e6fdd0a6695cff3ff29351b0)) - sravioli
- add KevinSilvester gpu picker - ([70a5a8d](https://github.com/sravioli//commit/70a5a8df8ce5cc424f374b73c8356b8ec7f10230)) - sravioli
#### Style
- change all occurences of 'WezTerm' to 'Wezterm' - ([9222ba3](https://github.com/sravioli//commit/9222ba36fa40e458dd5ff5cf6b719045c3c90504)) - sravioli

- - -

## [4.0.5](https://github.com/sravioli//compare/55f272029d7d9369a738d1ea01a1bceb7734dd52..4.0.5) - 2024-07-01

- - -

## [4.0.4](https://github.com/sravioli//compare/28f3f4caa47a4a2f9c440b8e83527e2e4ca00ecf..4.0.4) - 2024-07-01

- - -

## [4.0.3](https://github.com/sravioli//compare/96aaed2d091a8dc74dab9912fc409d84d837b094..4.0.3) - 2024-07-01

- - -

## [4.0.2](https://github.com/sravioli//compare/017d5d39052c2510a491df990a50604a2ffbd2b1..4.0.2) - 2024-07-01
#### Bug Fixes
- **(cocogitto)** remove tag prefix - ([6a42bfa](https://github.com/sravioli//commit/6a42bfa10fa3541548221a96edbe2bed1c15e051)) - sravioli
- **(cog)** update username - ([570babc](https://github.com/sravioli//commit/570babc3b229737ed612d5e38d71ca7cd79afca6)) - sravioli
- **(colors)** change kanagawa-lotus tab bar backround colors - ([81b1819](https://github.com/sravioli//commit/81b18197633b38982c3afdbb9236af2e7fdea269)) - sravioli
- **(config:general)** remove default program for Alpine - ([a28e46d](https://github.com/sravioli//commit/a28e46d48df48a86a297acac4311be59c1cad22e)) - [@sravioli](https://github.com/sravioli)
- **(events:format-tab-title)** don't render in fancy bar and with no bar, nil check icons - ([5438969](https://github.com/sravioli//commit/5438969db37e87caeebdfd5e2fa420ee60cb2b12)) - [@sravioli](https://github.com/sravioli)
- **(events:update-status)** increase padding for status-bar - ([396a15e](https://github.com/sravioli//commit/396a15e8817ebf531b0e9e1a9b7400aaea7779dc)) - sravioli
- **(events:update-status)** increase padding for status-bar - ([3e6bf9c](https://github.com/sravioli//commit/3e6bf9c915e578df85bb154e9dcd93653d356c0e)) - sravioli
- **(events:update-status)** add fancy tab bar support - ([4047afc](https://github.com/sravioli//commit/4047afcdbb0e12285f9a101566805bfb90456075)) - [@sravioli](https://github.com/sravioli)
- **(events:update-status)** check usable width with `<=` instead of `<` - ([fb8651c](https://github.com/sravioli//commit/fb8651cc632d3c5d758358a2a17aefd76dabe407)) - [@sravioli](https://github.com/sravioli)
- **(events:update-stauts)** display correct battery percentage, add padding - ([bf42e1b](https://github.com/sravioli//commit/bf42e1b1978cd729b1a5ded630e004563b8b3236)) - sravioli
- **(mappings)** change leader key - ([88adc01](https://github.com/sravioli//commit/88adc0100afcfa1c124c15f15815326ae42e59e8)) - sravioli
- **(mappings:default)** change leader key - ([c6940cf](https://github.com/sravioli//commit/c6940cf7084c2cb1df620556dd13fb579366cc12)) - [@sravioli](https://github.com/sravioli)
- **(mappings:default)** change leader key - ([d96ff2f](https://github.com/sravioli//commit/d96ff2f46fc8854348a79a1fa28a015af71ae1cf)) - [@sravioli](https://github.com/sravioli)
- **(mappings:modes)** change config initialization - ([911af0a](https://github.com/sravioli//commit/911af0a2829a458f73920257982f039766ec4a2d)) - [@sravioli](https://github.com/sravioli)
- **(utils:fun)** correctly retrieve the user home directory - ([77f53de](https://github.com/sravioli//commit/77f53de1da29800b1dd17bdf21fff1465038ff13)) - sravioli
- **(utils:fun)** make `tbl_merge()` take a list of strings - ([196e915](https://github.com/sravioli//commit/196e915b65032234470bf660051b2ab81757b74b)) - [@sravioli](https://github.com/sravioli)
- remove README repetitions - ([e1a665a](https://github.com/sravioli//commit/e1a665af160083eab31d5dcead01bd3f9da93d25)) - [@sravioli](https://github.com/sravioli)
- update icons.luafixes issue with battery.ico if computer reports "Full" instead of charging or discharging. Issue #2 in main repo. - ([45fbf19](https://github.com/sravioli//commit/45fbf19f72828ce8e74037e233f5f9b91c074395)) - Adam K
- embed showcase video - ([017d5d3](https://github.com/sravioli//commit/017d5d39052c2510a491df990a50604a2ffbd2b1)) - [@sravioli](https://github.com/sravioli)
#### Features
- **(config:font)** add linux support - ([6eb2499](https://github.com/sravioli//commit/6eb2499a83d8a05669621da21665f443a3f3a71f)) - sravioli
- **(config:general)** add linux support - ([0ddfe3d](https://github.com/sravioli//commit/0ddfe3d63586dd8c6e1af8d891163c50e0901378)) - sravioli
- **(events)** add command palette entry to rename tab - ([7e0331e](https://github.com/sravioli//commit/7e0331ef486598fcd94688192fef16f57d90b4bc)) - sravioli
- **(events:format-window-title)** check for nvim and cmd - ([d3a5e9e](https://github.com/sravioli//commit/d3a5e9e5f5f2b78ea2512a60137b7e89ec3294c7)) - [@sravioli](https://github.com/sravioli)
- **(events:lock-interface)** add event to lock the interface - ([494f5f9](https://github.com/sravioli//commit/494f5f936a29b5a1880959f8ed5c1f82af3b30b4)) - sravioli
- **(events:update-status)** make status-bar truly flexible, add padding - ([16695c5](https://github.com/sravioli//commit/16695c5bf07d1efdc2ef2fb463f289899200f8a7)) - sravioli
- **(events:update-status)** display real battery level - ([ad89081](https://github.com/sravioli//commit/ad890817f031718a5a6cddae1c72747ff15bd7a4)) - sravioli
- **(mappings)** add lock mode - ([7d4fa6b](https://github.com/sravioli//commit/7d4fa6bb5d8050f8632f7022f133f737c3058cca)) - sravioli
- **(mappings:default)** add mapping for quick window navigation - ([16763f9](https://github.com/sravioli//commit/16763f929dcb30458b6c12f1745fa93c243e7c0e)) - [@sravioli](https://github.com/sravioli)
- **(utils)** improve is_windows function - ([8bc3bb9](https://github.com/sravioli//commit/8bc3bb9cba91168668621c5ffa41c6491c944cac)) - sravioli
- **(utils)** improve is_windows function - ([ba8ddb1](https://github.com/sravioli//commit/ba8ddb1812a6d248f4984019b6ed8dc3c0f4d36d)) - sravioli
- **(utils)** add path shortener function - ([88bca6b](https://github.com/sravioli//commit/88bca6b1db9494f4d8b9f07b3abe681af639d345)) - sravioli
- **(utils:fun)** add linux support, uppercase first letter of hostname - ([c4d1856](https://github.com/sravioli//commit/c4d18560482b4debe0267b442729d2067fad23ed)) - sravioli
- **(wezterm.lua)** load new event - ([44e2043](https://github.com/sravioli//commit/44e204367db52214eb09e1e87cd4158d3cb91196)) - sravioli
- **(wezterm.lua)** source new event - ([70181bb](https://github.com/sravioli//commit/70181bb0f567f80c6617d9cfd3cc8a26552d161e)) - sravioli
- **(wezterm.lua)** load new config - ([9cc1a97](https://github.com/sravioli//commit/9cc1a971772f70323b1f4c4849aaaa000a0f44c0)) - [@sravioli](https://github.com/sravioli)
- rewrite and update README - ([cdcfaa8](https://github.com/sravioli//commit/cdcfaa8018d6ee632ac0d1c831b5f6d9e7c392ea)) - sravioli
- merge config in config and mappings folder - ([4dace64](https://github.com/sravioli//commit/4dace64f1d2fc7d7353153ef959d3aa9a52f3456)) - [@sravioli](https://github.com/sravioli)
#### Hotfixes
- **(config)** remove RESIZE decoration, not working under wayland - ([14845f1](https://github.com/sravioli//commit/14845f133bea85e99fd374ea2937898e92630da0)) - sravioli
- **(config:general)** typo in wsl domains - ([8588bbc](https://github.com/sravioli//commit/8588bbc7e2c01c9dcc65eba45ba58d93af0d7532)) - [@sravioli](https://github.com/sravioli)
- **(utils)** add is_windows function, fixes #1 - ([5313598](https://github.com/sravioli//commit/53135983af7f7f4bd3db86f6579dd7bf9f28a053)) - [@sravioli](https://github.com/sravioli)
- display correctly the status-bar showcase - ([8f292c7](https://github.com/sravioli//commit/8f292c7a227e59d44a67db79265cc38a93a308db)) - [@sravioli](https://github.com/sravioli)
- correctly call is_windows() as a function - ([f06414a](https://github.com/sravioli//commit/f06414a2777508f849d7e292b04cea7240dfed8c)) - sravioli
#### Refactoring
- **(utils:wcwidth)** rewrite portions of the wcwidth file - ([bbf92cb](https://github.com/sravioli//commit/bbf92cb116590053d4993784fd6b70003382e649)) - [@sravioli](https://github.com/sravioli)

- - -

## [4.0.1](https://github.com/sravioli/wezterm/compare/12048c2a19d1b7878838039bf480866cffb5fcb1..4.0.1) - 2024-07-01
#### Bug Fixes
- **(events:update-status)** increase padding for status-bar - ([259a6b2](https://github.com/sravioli/wezterm/commit/259a6b20b707ac481dcfe3fa7faf43d676c95e6b)) - sravioli
- update battery icons (fixes #2) - ([405e918](https://github.com/sravioli/wezterm/commit/405e91842ca5173ab28cc35c57ce005325551c55)) - [@sravioli](https://github.com/sravioli)
- remove README repetitions - ([05b8162](https://github.com/sravioli/wezterm/commit/05b816256d047fd704338015ead1f47672cd560d)) - [@sravioli](https://github.com/sravioli)
#### Features
- **(utils)** improve is_windows function - ([8cd6247](https://github.com/sravioli/wezterm/commit/8cd624721f2608c27f1da67147807c073b9563b1)) - sravioli
#### Hotfixes
- display correctly the status-bar showcase - ([12048c2](https://github.com/sravioli/wezterm/commit/12048c2a19d1b7878838039bf480866cffb5fcb1)) - [@sravioli](https://github.com/sravioli)
#### Miscellaneous Chores
- remove line ending whitespace - ([c1a9f33](https://github.com/sravioli/wezterm/commit/c1a9f33ac251d70a62e473260bf028e681cb9f28)) - sravioli
- format with stylua - ([b69abb3](https://github.com/sravioli/wezterm/commit/b69abb302ac3eadd5b2535927d542a6bdbfe09a1)) - sravioli
- remove unused asset - ([ae00027](https://github.com/sravioli/wezterm/commit/ae00027dcfa8a9b6a3978edf27cd6f26e8c4669d)) - sravioli

- - -

## [4.0.0](https://github.com/sravioli/wezterm/compare/2a1412cd060a7047feeea4d2e4efd702384e87f7..4.0.0) - 2024-05-16
#### Features
- **(events)** add command palette entry to rename tab - ([560bd59](https://github.com/sravioli/wezterm/commit/560bd59c1e46f9ef52324d627cb2db69b5eca8b0)) - sravioli
- **(events:update-status)** make status-bar truly flexible, add padding - ([946fafa](https://github.com/sravioli/wezterm/commit/946fafa4d6a9bf4abc55c20e438cef5403f72520)) - sravioli
- **(utils)** add path shortener function - ([2a1412c](https://github.com/sravioli/wezterm/commit/2a1412cd060a7047feeea4d2e4efd702384e87f7)) - sravioli
- **(wezterm.lua)** load new event - ([1a22b9a](https://github.com/sravioli/wezterm/commit/1a22b9ae0b79bb61ccc91caf9b81216da371375a)) - sravioli
- rewrite and update README - ([7bc203d](https://github.com/sravioli/wezterm/commit/7bc203dd41e353ede22f5049e9162112f29534ef)) - sravioli
#### Miscellaneous Chores
- update all README assets - ([23357f0](https://github.com/sravioli/wezterm/commit/23357f051322293b4a583cb620a5e0270f10097d)) - sravioli

- - -

## [3.1.1](https://github.com/sravioli/wezterm/compare/c4dfb7a506e89c021026507f1194853f8694096b..3.1.1) - 2024-05-14
#### Hotfixes
- correctly call is_windows() as a function - ([c4dfb7a](https://github.com/sravioli/wezterm/commit/c4dfb7a506e89c021026507f1194853f8694096b)) - sravioli

- - -

## [3.1.0](https://github.com/sravioli/wezterm/compare/3709298bb9ac25a75dba06caee5383a8412602cb..3.1.0) - 2024-05-14
#### Bug Fixes
- **(cog)** update username - ([3709298](https://github.com/sravioli/wezterm/commit/3709298bb9ac25a75dba06caee5383a8412602cb)) - sravioli
#### Hotfixes
- **(config)** remove RESIZE decoration, not working under wayland - ([32e1d1e](https://github.com/sravioli/wezterm/commit/32e1d1e1709e0dfaff5f2735cc910309fff30a6b)) - sravioli
- **(utils)** add is_windows function, fixes #1 - ([40f3306](https://github.com/sravioli/wezterm/commit/40f330649a92b1bdca6e76bd66da59feebaa9aa1)) - [@sravioli](https://github.com/sravioli)

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

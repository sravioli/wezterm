---@meta utils.Icons
error "cannot require a meta file!"

-- luacheck: push ignore 631 (line is too long)

---Central repository for Nerd Fonts icons used in WezTerm interface.
---Provide access to separators, battery states, clock faces, and program icons.
---
---### Example Usage
---~~~lua
---local icons = require("utils.icons")
---print(icons.Folder) -- Output: 󰉋
---print(icons.Clock.day["08"]) -- Output: 󱑒
---~~~
---
---@class Icons
---@field Notification string                Notification icon.
---@field Workspace    string                Workspace icon.
---@field Folder       string                Folder icon.
---@field Hostname     string                Hostname icon.
---@field Leader       string                Leader icon.
---@field Modes        Icons.Modes           Editor mode icons.
---@field Picker       Icons.Picker          Picker icons.
---@field Sep          Icons.Sep             Separator configuration.
---@field Bat          Icons.Bat             Battery icon configuration.
---@field Nums         string[]              Numeric icons.
---@field Clock        Icons.Clock           Clock face icons categorized by period.
---@field Progs        table<string, string> Program specific icons.

---@class Icons.Modes
---@field copy   string Copy mode icon.
---@field search string Search mode icon.
---@field font   string Font mode icon.
---@field window string Window mode icon.
---@field help   string Help mode icon.
---@field pick   string Pick mode icon.

---Picker utility icons.
---@class Icons.Picker
---@field public ico?   string                        General picker icon.
---@field public fuzzy? Icons.Picker.DescriptionIcons Icon pairs to use when formatting fuzzy description
---@field public exact? Icons.Picker.DescriptionIcons Icon pairs to use when formatting description.
---
---
---@alias Icons.Picker.DescriptionIcons {ico: string, punct: string}

---@class Icons.Sep
---@field block  string              Full block character.
---@field sb     Icons.Sep.StatusBar Status bar separators.
---@field ws     Icons.Sep.Workspace Workspace separators.
---@field tb     Icons.Sep.TabBar    Tab bar separators.
---@field leader Icons.Sep.Leader    Leader key separators.

---@class Icons.Sep.StatusBar
---@field left  string Left hard divider.
---@field right string Right hard divider.
---@field modal string Modal forward slash separator.

---@class Icons.Sep.Workspace
---@field left  string Right half circle.
---@field right string Left half circle.

---@class Icons.Sep.TabBar
---@field leftmost string Left vertical bar.
---@field left     string Upper right triangle.
---@field right    string Lower left triangle.

---@class Icons.Sep.Leader
---@field left  string Right half circle.
---@field right string Left half circle.

---@class Icons.Bat
---@field Full        table<string, string> Full battery state icons.
---@field Charging    table<string, string> Battery charging state icons.
---@field Discharging table<string, string> Battery discharging state icons.

---@class Icons.Clock
---@field night table<string, string> Filled clock icons for night-time.
---@field day   table<string, string> Outline clock icons for day-time.

-- luacheck: pop

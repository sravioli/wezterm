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
---@field public Notification string                Notification icon.
---@field public Workspace    string                Workspace icon.
---@field public Folder       string                Folder icon.
---@field public Hostname     string                Hostname icon.
---@field public Leader       string                Leader icon.
---@field public Ellipsis     string                Ellipsis icon.
---@field public Modes        Icons.Modes           Editor mode icons.
---@field public Picker       Icons.Picker          Picker icons.
---@field public Sep          Icons.Sep             Separator configuration.
---@field public Bat          Icons.Bat             Battery icon configuration.
---@field public Nums         string[]              Numeric icons.
---@field public Clock        Icons.Clock           Clock face icons categorized by period.
---@field public Progs        table<string, string> Program specific icons.

---@class Icons.Modes
---@field public copy   string Copy mode icon.
---@field public search string Search mode icon.
---@field public font   string Font mode icon.
---@field public window string Window mode icon.
---@field public help   string Help mode icon.
---@field public pick   string Pick mode icon.

---Picker utility icons.
---@class Icons.Picker
---@field public ico?   string                        General picker icon.
---@field public fuzzy? Icons.Picker.DescriptionIcons Icon pairs to use when formatting fuzzy description
---@field public exact? Icons.Picker.DescriptionIcons Icon pairs to use when formatting description.
---
---
---@alias Icons.Picker.DescriptionIcons {ico: string, punct: string}

---@class Icons.Sep
---@field public block  string              Full block character.
---@field public sb     Icons.Sep.StatusBar Status bar separators.
---@field public ws     Icons.Sep.Workspace Workspace separators.
---@field public tb     Icons.Sep.TabBar    Tab bar separators.
---@field public leader Icons.Sep.Leader    Leader key separators.

---@class Icons.Sep.StatusBar
---@field public left  string Left hard divider.
---@field public right string Right hard divider.
---@field public modal string Modal forward slash separator.

---@class Icons.Sep.Workspace
---@field public left  string Right half circle.
---@field public right string Left half circle.

---@class Icons.Sep.TabBar
---@field public leftmost string Left vertical bar.
---@field public left     string Upper right triangle.
---@field public right    string Lower left triangle.

---@class Icons.Sep.Leader
---@field public left  string Right half circle.
---@field public right string Left half circle.

---@class Icons.Bat
---@field public Full        table<string, string> Full battery state icons.
---@field public Charging    table<string, string> Battery charging state icons.
---@field public Discharging table<string, string> Battery discharging state icons.

---@class Icons.Clock
---@field public night table<string, string> Filled clock icons for night-time.
---@field public day   table<string, string> Outline clock icons for day-time.

-- luacheck: pop

---@meta utils.Keymapper
error "cannot require a meta file!"

---Provide display metadata used by the status bar.
---@class Keymapper.Meta
---@field i string Icon glyph.
---@field txt string Label text.
---@field bg string Background color hex or theme reference.
---@field pad? number Optional padding override.
---@field name string The name of the key table

---Define a key table including metadata and mapping array.
---@class Keymapper.TableDef
---@field meta Keymapper.Meta Display metadata.
---@field keys table[] Array of {lhs, rhs, desc?} mappings.

---Evaluate theme to return a key table definition.
---@alias Keymapper.TableDefFn fun(theme: table): Keymapper.TableDef

---Manage and construct WezTerm keybindings.
---@class Keymapper
---@field aliases table<string, string> Vim-style aliases mapped to WezTerm key names.
---@field modifiers table<string, string> Modifier key mappings.

---@meta utils.Keymapper
error "cannot require a meta file!"

-- luacheck: push ignore 631 (line is too long)

---Provide display metadata used by the status bar.
---@class KeyMeta
---@field public i     string  Icon glyph (e.g. "󰆏").
---@field public txt   string  Label text (e.g. "COPY").
---@field public bg    string  Background colour hex or theme reference.
---@field public pad?  number  Optional padding override.
---@field public name? string  Key-table name (injected by `tables()`).

---Define a key table including metadata and mapping array.
---@class KeyTableDef
---@field public meta KeyMeta Display metadata.
---@field public keys table[] Array of {lhs, rhs, desc?} mappings.

---Evaluate theme to return a key table definition.
---@alias KeyTableDefiner fun(theme: table): KeyTableDef

---Manage and construct WezTerm keybindings.
---
---Translate (n)vim-style key binding syntax into WezTerm format, register named
---key tables, and provide paginated hint rendering for the status bar.
---
---@class Keymapper
---@field public  aliases       table<string, string>                    Vim-style aliases mapped to WezTerm key names.
---@field public  modifiers     table<string, string>                    Modifier key mappings.
---@field private _defs         table<string, KeyTableDef|KeyTableDefiner> Raw definitions stored by `tables()`, resolved by `get_modes()`.
---@field private _log          Logger                                   Class logger.
---@field private _rev_aliases? table<string, string>                    Lazy reverse-alias cache (WezTerm key → vim key).

-- luacheck: pop

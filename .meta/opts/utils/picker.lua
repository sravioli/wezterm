---@meta Opts.Utils.Picker
error "cannot require a meta file!"

-- luacheck: push ignore 631 (line is too long)

---@class Opts.Utils.Picker: Opts.Utils.Base
---@field public assets_path_segments? string[]                       List of path segments composing the base directory for loading picker modules.
---@field public persistence?          Opts.Utils.Picker.Persistence  Persistence configuration for picker selections.
---@field public defaults?             Opts.Utils.Picker.Defaults     Default picker configuration, used when initializing a new Picker.
---
---
---Persistence configuration for picker state across reloads.
---@class Opts.Utils.Picker.Persistence
---@field public enabled?        boolean             Enable persistence globally (default: true).
---@field public path?           string|nil          Absolute path to the JSON state file (default: `wt.config_dir/picker-state.json`).
---@field public reset_behavior? "clear"|"persist"  What to do when "Reset" is picked (default: "clear").
---
---
---@alias Opts.Utils.Picker.ComparatorFactory fun(sort_by: "id"|"label"): Picker.Comparator
---
---
---@class Opts.Utils.Picker.Defaults
---@field public title?              string                              Picker window default title.
---@field public sort_by?            "id"|"label"                        Key to use when sorting choices.
---@field public fuzzy?              boolean                             Whether the picker is fuzzy or not.
---@field public description?        string                              Description to display when picker is opened.
---@field public fuzzy_description?  string                              Description to display when fuzzy picker is opened.
---@field public alphabet?           string                              Alphabet to use to quick select an item when in normal mode.
---@field public icons?              Icons.Picker                        Icons used by the picker class
---@field public comp?               Opts.Utils.Picker.ComparatorFactory Comparator factory function.
---@field public format_choices?     Picker.ChoicesFormatter             Choices formatter function.
---@field public format_description? Picker.DescriptionFormatter         Description formatter function.
---

-- luacheck: pop

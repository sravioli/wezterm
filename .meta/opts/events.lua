---@meta Opts.Events
error "cannot require a meta file!"

-- luacheck: push ignore 631 (line is too long)

---@class Opts.Events
---@field public augment_command_palette? Opts.Events.Base
---@field public format_window_title?     Opts.Events.Base
---@field public new_tab_button_click?    Opts.Events.Base
---@field public update_status?           Opts.Events.Base
---
---@class Opts.Events.Base
---@field public enabled? boolean Whether the event it's enabled or not

-- luacheck: pop

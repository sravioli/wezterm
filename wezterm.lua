-- jetpack is the only plugin WezTerm fetches itself; it installs the rest and
-- redirects every later `wezterm.plugin.require` to its pinned clones. `setup`
-- runs git, which needs the config's own coroutine: not inside a `require`.
local jetpack = require("wezterm").plugin.require "https://github.com/sravioli/jetpack.wz"
jetpack.setup {
  spec = {
    "sravioli/warp.wz",
    "sravioli/warden.wz",
    "sravioli/beacon.wz",
    "sravioli/chord.wz",
    "sravioli/harbor.wz",
    "sravioli/lantern.wz",
    "sravioli/memo.wz",
    "sravioli/mosaic.wz",
    "sravioli/sigil.wz",
    "sravioli/stargaze.wz",
    "kanagawa-community/wezterm",
  },
}

require "events"

require "plugs.beacon"
require "plugs.stargaze"

local chord = require "plugs.chord" ---@class Chord
local lantern = require "plugs.lantern" ---@class Lantern

---@class Configuration
local config = require("config")
  :add(require "mappings.default")
  :add(require("mappings.modes").config)
  :init()

lantern.rekindle(config)
chord.use_harbor_status_hints()
require("plugs.harbor").apply_to_config(config)

local ok, overrides = pcall(require, "overrides.mappings")
if ok then
  chord.apply_overrides(config, overrides)
end

chord.apply(config)
jetpack.apply_to_config(config)

if require("opts").events.update_status.enabled then
  local mosaic = require "plugs.mosaic" ---@class Mosaic.Api
  mosaic.apply_to_config(config)
end

return config

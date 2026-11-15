---@module "opts.utils.config"

---@class Opts.Utils.Config
return {
  log = {
    enabled = true,
    threshold = "INFO",
    sinks = { default_enabled = true },
  },

  -- Each `config_builder` assignment rebuilds a full Config (~2.5 ms per key,
  -- ~160 ms per load), so strict validation runs only on demand:
  -- `WEZTERM_STRICT=1 wezterm ls-fonts --text a`.
  builder = {
    enabled = os.getenv "WEZTERM_STRICT" == "1",
    strict_mode = true,
  },
}

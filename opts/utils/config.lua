---@module "opts.utils.config"

---@class Opts.Utils.Config
return {
  log = {
    enabled = true,
    threshold = "INFO",
    sinks = { default_enabled = true },
  },

  builder = {
    enabled = true,
    strict_mode = true,
  },
}

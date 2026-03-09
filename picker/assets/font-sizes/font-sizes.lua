---@module "picker.assets.font-sizes.font-sizes"

---@class Picker.Module
local M = {}

M.get = function()
  local sizes = {}
  for i = 8, 30 do
    sizes[#sizes + 1] = { label = ("%2dpt"):format(i), id = tostring(i) }
  end
  sizes[#sizes + 1] = { id = tostring(require("config.font").font_size), label = "Reset" }

  return sizes
end

M.pick = function(Config, opts)
  Config.font_size = tonumber(opts.choice.id) or 10
end

return M

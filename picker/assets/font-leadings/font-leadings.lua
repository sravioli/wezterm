---@module "picker.assets.font-leadings.font-leadings"
---@author akthe-at, sravioli
---@license GNU-GPLv3

---@class PickList
local M = {}

M.get = function()
  local leadings_list = { { label = "Reset Line Height to Default", id = "reset" } }
  for i = 0.9, 1.4, 0.1 do
    table.insert(leadings_list, { label = i .. "x", id = tostring(i) })
  end
  return leadings_list
end

M.activate = function(config, opts)
  if opts.id == "reset" then
    config.line_height = nil
  else
    config.line_height = tonumber(opts.id)
  end
end

return M

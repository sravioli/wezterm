local M = {}

M.init = function()
  local sizes = { "Reset" }
  for i = 8, 30 do
    table.insert(sizes, { label = string.format("%2dpt", i), value = i })
  end
  return sizes
end

M.activate = function(config, _, value)
  config.font_size = value
end

return M

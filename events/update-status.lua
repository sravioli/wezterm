---@diagnostic disable: undefined-field
local wez = require "wezterm" ---@class WezTerm
local nf = require "utils.nerdfont-icons" ---@class NerdFontIcons
local fn = require "utils.functions" ---@class UtilityFunctions

local kanagawa = require "colorschemes.kanagawa"

local M = {}

function M.setup()
  wez.on("update-status", function(window, pane)
    ---@class WezTermLayout
    local layout = require("utils.layout"):new()

    local battery = wez.battery_info()[1]

    ---Returns the battery charge level rounded to nearest multiple of ten.
    ---@return integer charge The battery charge level.
    function battery:charge() return fn.toint(fn.mround(self.state_of_charge * 100, 10)) end

    ---Returns the battery icon that should be used in the status.
    ---@return string battery_icon The icon corresponding to the battery charge level.
    function battery:icon() return nf.Battery[self.state][tostring(battery:charge())] end

    local datetime = wez.strftime "%a %b %-d %H:%M"
    -- BUG: for some reason if running on base pwsh the cwd is always ~
    local cwd, hostname = fn.get_cwd_hostname(pane)

    ---colors to use as background for the status bar
    local colors = { "#6e5497", "#876faf", "#a38fc1", "#b0a0ca", "#beb0d3" }

    ---cells that should compose the status bar
    local cells = { cwd, hostname, datetime, battery:icon() }

    ---push eache cell with the separator
    for i, cell in ipairs(cells) do
      if i == 1 then
        ---push the final separator
        layout:push(kanagawa.background, colors[1], nf.Powerline.right)
      end

      ---push each element
      layout:push(colors[i], kanagawa.background, " " .. cell .. " ")

      ---add a separator after each element
      if i < #cells then ---add only if it's not the rightmost element
        layout:push(colors[i], colors[i + 1], nf.Powerline.right)
      end
    end

    window:set_right_status(wez.format(layout))
  end)
end

return M

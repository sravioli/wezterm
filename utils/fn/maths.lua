---@module 'utils.fn.maths'

local mceil, mfloor = math.ceil, math.floor

---@class Fn.Maths
local M = {}

---Round number to nearest integer.
---
---Uses floor(number + 0.5).
---
---@param number number Number to round.
---@return integer result Closest integer number.
M.round = function(number)
  return mfloor(number + 0.5)
end

---Round number to nearest given multiple.
---
---@param number number Number to round.
---@param multiple number Target multiple.
---@return number result Number rounded to closest multiple.
M.mround = function(number, multiple)
  local remainder = number % multiple
  return number - remainder + (remainder > multiple * 0.5 and multiple or 0)
end

---Convert float to integer, supporting increment-based flooring.
---
---If `increment` is provided, floors the number to the nearest multiple of the increment.
---Otherwise, performs standard rounding (using floor/ceil for positive/negative numbers).
---
---@param number number Number to convert.
---@param increment? number Optional increment value.
---@return integer result Integer result.
M.toint = function(number, increment)
  if increment then
    return mfloor(number / increment) * increment
  end
  return number >= 0 and mfloor(number + 0.5) or mceil(number - 0.5)
end

return M

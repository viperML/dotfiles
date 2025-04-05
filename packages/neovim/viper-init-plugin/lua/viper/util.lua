local M = {}

---@param decimal number
---@return string
M.rgbToHex = function(decimal)
  local bit = require("bit")
  local r = bit.rshift(decimal, 16) % 256
  local g = bit.rshift(decimal, 8) % 256
  local b = decimal % 256
  return string.format("#%02X%02X%02X", r, g, b)
end

return M

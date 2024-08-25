local wezterm = require("wezterm")

local M = {}

M.apply_to_config = function(config)
  config.default_prog = { "nu" }
  config.font = wezterm.font_with_fallback {
    { family = "iosevka-normal", weight = "Medium" },
    { family = "Symbols Nerd Font" },
  }
  config.font_size = 12
end

return M

local wezterm = require("wezterm")

local M = {}

M.apply_to_config = function(config)
  config.font = wezterm.font_with_fallback {
    { family = "iosevka-normal", weight = "Medium" },
    { family = "Symbols Nerd Font" },
  }
  config.font_size = 12

  -- Fix for https://github.com/wez/wezterm/issues/5990
  -- config.enable_wayland = true

  config.enable_wayland = false
  config.front_end = "WebGpu"

  config.xcursor_theme = "Adwaita"
end

return M

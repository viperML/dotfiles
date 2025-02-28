local wezterm = require("wezterm")

local M = {}

local os = require("os")

M.apply_to_config = function(config)
  config.font = wezterm.font_with_fallback {
    { family = "iosevka-normal", weight = "Medium" },
    { family = "Symbols Nerd Font" },
  }
  config.font_size = 13

  local session = os.getenv("XDG_SESSION_TYPE")

  config.default_prog = { "fish" }

  if session == "wayland" then
    config.enable_wayland = true
    -- config.front_end = "WebGpu"
  else
    config.enable_wayland = false
    config.xcursor_theme = "DMZ-White"
    config.xcursor_size = 24
  end
end

return M

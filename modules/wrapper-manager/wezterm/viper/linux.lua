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

  local shell = os.getenv("SHELL")
  config.default_prog = { shell }

  if session == "wayland" then
    config.enable_wayland = true
    -- config.front_end = "WebGpu"
    config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
    -- config.integrated_title_button_style = "Gnome"
  else
    config.enable_wayland = false
    config.xcursor_theme = "DMZ-White"
    config.xcursor_size = 24
  end
end

return M

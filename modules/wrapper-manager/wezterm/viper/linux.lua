local wezterm = require("wezterm")

local M = {}

local os = require("os")

M.apply_to_config = function(config)
  config.font = wezterm.font_with_fallback {
    { family = "iosevka-normal", weight = "Medium" },
    { family = "Symbols Nerd Font" },
  }
  config.font_size = 12

  -- Fix for https://github.com/wez/wezterm/issues/5990
  if os.getenv("NIXOS_OZONE_WL") ~= nil then
    config.enable_wayland = true
    config.front_end = "WebGpu"
  else
    config.enable_wayland = false
  end

  config.xcursor_theme = "Adwaita"
end

return M

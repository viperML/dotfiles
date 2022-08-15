local wezterm = require "wezterm"

local padding = 12

local atom_one_dark = {
  ansi = {
    -- Base Colors
    "#282c34",
    "#e06c75",
    "#98c379",
    "#e5c07b",
    "#61afef",
    "#c678dd",
    "#56b6c2",
    "#d0d0d0",
  },
  brights = {
    "#504945",
    "#e06c75",
    "#98c379",
    "#e5c07b",
    "#61afef",
    "#c678dd",
    "#56b6c2",
    "#ffffff",
  },
  background = "#121212",
}
atom_one_light = {
  foreground = "#222222",
  ansi = {
    "#000000",
    "#c35045",
    "#4d8f4c",
    "#a8770d",
    "#3e6ccf",
    "#8d258c",
    "#0a74a4",
    "#222222",
  },
  brights = {
    "#aaaaaa",
    "#c35045",
    "#4d8f4c",
    "#a8770d",
    "#3e6ccf",
    "#8d258c",
    "#0a74a4",
    "#999999",
  },
  background = "#ffffff",
}
local rose_pine = {
  background = "#191724",
  foreground = "#e0def4",
  ansi = {
    "#6e6a86",
    "#eb6f92",
    "#9ccfd8",
    "#f6c177",
    "#31748f",
    "#c4a7e7",
    "#ebbcba",
    "#e0def4",
  },
  brights = {
    "#6e6a86",
    "#eb6f92",
    "#9ccfd8",
    "#f6c177",
    "#31748f",
    "#c4a7e7",
    "#ebbcba",
    "#e0def4",
  },
}

local rose_pine_dawn = {
  foreground = "#575279",
  background = "#fffaf3",
  ansi = {
    "#6e6a86",
    "#b4637a",
    "#56949f",
    "#ea9d34",
    "#286983",
    "#907aa9",
    "#d7827e",
    "#575279",
  },
  brights = {
    "#6e6a86",
    "#eb6f92",
    "#9ccfd8",
    "#f6c177",
    "#31748f",
    "#c4a7e7",
    "#ebbcba",
    "#e0def4",
  },
}

local tomorrow_night = {
  foreground = "#C5C8C6",
  background = "#141414",
  ansi = {
    "#17191a",
    "#CC6666",
    "#B5BD68",
    "#F0C674",
    "#81A2BE",
    "#B294BB",
    "#8ABEB7",
    "#C5C8C6",
  },
  brights = {
    "#696969",
    "#CC6666",
    "#B5BD68",
    "#F0C674",
    "#81A2BE",
    "#B294BB",
    "#8ABEB7",
    "#FFFFFF",
  },
}

local colors

local current_time = tonumber(os.date "%H%M")
if current_time < 1800 and current_time > 500 then
  colors = atom_one_light
else
  colors = tomorrow_night
end

local default_prog
local set_environment_variables = {}
local enable_tab_bar

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  -- clink
  -- set_environment_variables["prompt"] = "$E]7;file://localhost/$P$E\\$E[32m$T$E[0m $E[35m$P$E[36m$_$G$E[0m "
  -- use a more ls-like output format for dir
  -- set_environment_variables["DIRCMD"] = "/d"
  -- default_prog = { "cmd.exe", "/s", "/k", "c:/clink/clink_x64.exe", "inject", "-q" }

  default_prog = { "wsl.exe",  "-d", "Voidnix", "bash",  "--login", "-c",  "/home/ayats/.nix-profile/bin/fish" }
  enable_tab_bar = true
else
  default_prog = { os.getenv "SHELL" }
  enable_tab_bar = false
end

return {
  font = wezterm.font_with_fallback({
    "iosevka-normal",
    "Symbols Nerd Font",
  }, {
    weight = "Medium",
    -- stretch = "Normal",
    -- italic = false,
  }),
  font_size = 12,
  default_prog = default_prog,
  set_environment_variables = set_environment_variables,
  window_background_opacity = 1.0,
  enable_scroll_bar = true,
  enable_tab_bar = enable_tab_bar,
  window_padding = {
    left = padding,
    right = padding,
    top = padding - 5,
    bottom = padding - 5,
  },
  colors = colors,
  enable_wayland = false,
  window_close_confirmation = "NeverPrompt",
  check_for_updates = false,
  default_cursor_style = "SteadyBar",
}

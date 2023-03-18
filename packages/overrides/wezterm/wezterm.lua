local wezterm = require "wezterm"

local padding = 12

function tableMerge(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" then
      if type(t1[k] or false) == "table" then
        tableMerge(t1[k] or {}, t2[k] or {})
      else
        t1[k] = v
      end
    else
      t1[k] = v
    end
  end
  return t1
end

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

local generic_config = {
  window_background_opacity = 1.0,
  enable_scroll_bar = true,
  window_padding = {
    left = padding,
    right = padding,
    top = padding - 5,
    bottom = padding - 5,
  },
  colors = tomorrow_night,
  enable_wayland = true,
  window_close_confirmation = "NeverPrompt",
  check_for_updates = false,
  default_cursor_style = "SteadyBar",
  keys = {
    { key = "x", mods = "ALT", action = wezterm.action.ShowLauncher },
  },
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  -- clink
  -- set_environment_variables["prompt"] = "$E]7;file://localhost/$P$E\\$E[32m$T$E[0m $E[35m$P$E[36m$_$G$E[0m "
  -- use a more ls-like output format for dir
  -- set_environment_variables["DIRCMD"] = "/d"
  -- default_prog = { "cmd.exe", "/s", "/k", "c:/clink/clink_x64.exe", "inject", "-q" }

  platform_config = {
    default_prog = { "nu" },
    enable_tab_bar = true,
    font = wezterm.font("iosevka NFM", { weight = "Medium" }),
    font_size = 12,
    cell_width = 0.9,
  }
else
  platform_config = {
    default_prog = { "fish" },
    enable_tab_bar = false,
    font = wezterm.font("iosevka NFM", { weight = "Medium", stretch = "Normal", style = "Normal" }),
    font_size = 12,
  }
end

tableMerge(generic_config, platform_config)

return generic_config

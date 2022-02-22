local wezterm = require 'wezterm';

local padding = 20


atom_one_dark = {
    ansi = {
        -- Base Colors
        '#282c34',
        '#e06c75',
        '#98c379',
        '#e5c07b',
        '#61afef',
        '#c678dd',
        '#56b6c2',
        '#d0d0d0'
    },
    brights = {
        '#504945',
        '#e06c75',
        '#98c379',
        '#e5c07b',
        '#61afef',
        '#c678dd',
        '#56b6c2',
        '#ffffff'
    },
    background = "#121212"
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
        "#222222"
    },
    brights = {
        "#aaaaaa",
        "#c35045",
        "#4d8f4c",
        "#a8770d",
        "#3e6ccf",
        "#8d258c",
        "#0a74a4",
        "#999999"
    },
    background = "#ffffff"
}

local current_time = tonumber(os.date("%H%M"))
if current_time < 1800 and current_time > 500 then
    colors = atom_one_light
else
    colors = atom_one_dark
end

return {
    font = wezterm.font("JetBrainsMono Nerd Font", {
        weight = "Medium",
        stretch = "Normal",
        italic = false
    }),
    font_size = 11,
    default_prog = {"fish", "-l"},
    window_background_opacity = 1.0,
    enable_scroll_bar = true,
    enable_tab_bar = false,
    window_padding = {
        left = padding,
        right = padding,
        top = padding,
        bottom = padding
    },

    colors = colors,

    -- enable_wayland = true,
}

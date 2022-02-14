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
    ansi = {
        "#000000",
        "#de3e35",
        "#3f953a",
        "#d2b67c",
        "#2f5af3",
        "#950095",
        "#3f953a",
        "#444444"
    },
    brights = {
        "#353535",
        "#de3e35",
        "#3f953a",
        "#d2b67c",
        "#2f5af3",
        "#a00095",
        "#3f953a",
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
    font = wezterm.font("VictorMono Nerd Font", {
        weight = "DemiBold",
        stretch = "Normal",
        italic = false
    }),
    default_prog = {"fish", "-l"},
    window_background_opacity = 0.9,
    enable_scroll_bar = true,
    enable_tab_bar = false,
    window_padding = {
        left = padding,
        right = padding,
        top = padding,
        bottom = padding
    },

    colors = colors,

    enable_wayland = true,
}

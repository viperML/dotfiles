local dpi = require("beautiful.xresources").apply_dpi
local gears = require "gears"

res = gears.filesystem.get_configuration_dir() .. "/res/"
buttons = "/btn3/"

local theme = {}

-- Awesome stock
theme.systray_icon_spacing = 10
theme.font = "Roboto Regular 10"
theme.font_name = "Roboto" --custom

theme.useless_gap = dpi(5)
theme.border_width = dpi(0)

theme.menu_height = dpi(20)
theme.menu_width = dpi(200)

theme.titlebar_close_button_focus = res .. buttons ..  "close.svg"
theme.titlebar_close_button_normal = res .. buttons .. "close.svg"

-- Custom
theme.titlebar_height = dpi(35)
theme.corners = dpi(12)

-- Bling
theme.tag_preview_widget_border_radius = dpi(5) -- Border radius of the widget (With AA)
theme.tag_preview_client_border_radius = dpi(2) -- Border radius of each client in the widget (With AA)
theme.tag_preview_client_opacity = 1.0 -- Opacity of each client
theme.tag_preview_client_bg = "#000000" -- The bg color of each client
theme.tag_preview_client_border_color = "#ffffff" -- The border color of each client
theme.tag_preview_client_border_width = 0 -- The border width of each client
theme.tag_preview_widget_bg = "#121212" -- The bg color of the widget
theme.tag_preview_widget_border_color = "#ffffff" -- The border color of the widget
theme.tag_preview_widget_border_width = 0 -- The border width of the widget
theme.tag_preview_widget_margin = dpi(5) -- The margin of the widget

return theme

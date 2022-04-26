local dpi = require("beautiful.xresources").apply_dpi
local gears = require "gears"
local helpers = require "rc.helpers"

res = gears.filesystem.get_configuration_dir() .. "/res/"
btn_dir = res .. "/btn3/"

local theme = {}

-- Awesome stock
theme.systray_icon_spacing = 10
theme.font = "Source Sans 3 Regular 10"
theme.font_name = "Source Sans 3" --custom

theme.useless_gap = dpi(5)
theme.border_width = dpi(0)

theme.menu_height = dpi(20)
theme.menu_width = dpi(200)

theme.taglist_squares_sel = nil
theme.taglist_squares_unsel = nil
theme.taglist_spacing = dpi(5)
theme.taglist_shape = helpers.rrect(7)
theme.taglist_shape_focus = helpers.rrect(7)
theme.taglist_shape_empty = helpers.rrect(7)
theme.taglist_font = theme.font_name .. " Bold 10"

theme.titlebar_close_button_normal = btn_dir .. "close1.svg"
theme.titlebar_close_button_normal_hover = btn_dir .. "close2.svg"
theme.titlebar_close_button_normal_press = btn_dir .. "close3.svg"
theme.titlebar_close_button_focus = btn_dir .. "close1.svg"
theme.titlebar_close_button_focus_hover = btn_dir .. "close2.svg"
theme.titlebar_close_button_focus_press = btn_dir .. "close3.svg"

theme.titlebar_sticky_button_normal = btn_dir .. "pin1.svg"
theme.titlebar_sticky_button_normal_active = btn_dir .. "pin3.svg"
theme.titlebar_sticky_button_normal_active_hover = btn_dir .. "pin2.svg"
theme.titlebar_sticky_button_normal_active_press = btn_dir .. "pin3.svg"
theme.titlebar_sticky_button_normal_inactive = btn_dir .. "pin1.svg"
theme.titlebar_sticky_button_normal_inactive_hover = btn_dir .. "pin2.svg"
theme.titlebar_sticky_button_normal_inactive_press = btn_dir .. "pin3.svg"
theme.titlebar_sticky_button_focus = btn_dir .. "pin1.svg"
theme.titlebar_sticky_button_focus_active = btn_dir .. "pin3.svg"
theme.titlebar_sticky_button_focus_active_hover = btn_dir .. "pin2.svg"
theme.titlebar_sticky_button_focus_active_press = btn_dir .. "pin3.svg"
theme.titlebar_sticky_button_focus_inactive = btn_dir .. "pin1.svg"
theme.titlebar_sticky_button_focus_inactive_hover = btn_dir .. "pin2.svg"
theme.titlebar_sticky_button_focus_inactive_press = btn_dir .. "pin3.svg"

theme.awesome_icon = res .. "awesome.png"

-- Custom
theme.titlebar_height = dpi(35)
theme.corners = dpi(12)
theme.bar_thickness = dpi(46)

theme.taglist_sidemargins = dpi(6)

theme.titlebar_icons_margin_vertical = dpi(7)
theme.titlebar_icons_margin_horizontal = dpi(8)
theme.titlebar_icons_margin_internal = dpi(6)

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

theme.task_preview_widget_border_radius = dpi(5) -- Border radius of the widget (With AA)
theme.task_preview_widget_bg = "#000000" -- The bg color of the widget
theme.task_preview_widget_border_color = "#ffffff" -- The border color of the widget
theme.task_preview_widget_border_width = 0 -- The border width of the widget
theme.task_preview_widget_margin = dpi(5) -- The margin of the widget

return theme

local gears = require("gears")
local wibox = require("wibox")

local config_dir = "~/.config/awesome/"
local res_dir = config_dir.."res/"

---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local gears = require("gears")
local themes_path = gfs.get_themes_dir()

local helpers = require("helpers")

local theme = {}

theme.font          = "Roboto"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"



theme.wallpaper = themes_path.."default/background.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil


-- ███╗   ███╗██╗███████╗ ██████╗
-- ████╗ ████║██║██╔════╝██╔════╝
-- ██╔████╔██║██║███████╗██║
-- ██║╚██╔╝██║██║╚════██║██║
-- ██║ ╚═╝ ██║██║███████║╚██████╗
-- ╚═╝     ╚═╝╚═╝╚══════╝ ╚═════╝
local main_bg = "#131313"
theme.border_width = 0
theme.border_focus = "#A8D5E0"
theme.border_normal = main_bg
theme.font = "Roboto,Font Awesome 5 Free Solid 11"
local text_color = '#bbbbbb'

-- Menu
theme.menu_width = 200
theme.menu_height = 20
theme.menu_submenu_icon = nil

-- Wibox
theme.taglist_squares_sel = nil
theme.taglist_squares_unsel = nil
theme.wibar_fg = text_color
theme.wibar_bg = main_bg
theme.bg_systray = main_bg
theme.taglist_fg_focus = "#121212"
theme.taglist_bg_focus = "#caa9fa"
theme.taglist_bg_focus2 = "#ad94d0"
theme.taglist_fg_empty = "#6a7066"
-- theme.taglist_bg_empty = "#12121200"
theme.taglist_bg_empty = main_bg
theme.taglist_bg_occupied = theme.taglist_bg_empty
theme.taglist_fg_urgent = "#121212"
theme.taglist_bg_urgent = "#d35d6e"
theme.taglist_spacing = 0
theme.taglist_shape_focus = helpers.rrect(5)
theme.taglist_shape_empty = helpers.rrect(5)
theme.taglist_shape = helpers.rrect(5)
-- theme.taglist_shape_border_width = 10
theme.tasklist_bg_normal = main_bg
theme.tasklist_bg_focus = "#303030"
theme.tasklist_bg_minimize = "#A8D5E0"
theme.tasklist_shape = helpers.rrect(5)
theme.tasklist_disable_task_name = true
theme.tasklist_shape_border_width = 0
theme.tasklist_bg_urgent = theme.taglist_bg_urgent



-- ████████╗██╗████████╗██╗     ███████╗██████╗  █████╗ ██████╗ ███████╗
-- ╚══██╔══╝██║╚══██╔══╝██║     ██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔════╝
--    ██║   ██║   ██║   ██║     █████╗  ██████╔╝███████║██████╔╝███████╗
--    ██║   ██║   ██║   ██║     ██╔══╝  ██╔══██╗██╔══██║██╔══██╗╚════██║
--    ██║   ██║   ██║   ███████╗███████╗██████╔╝██║  ██║██║  ██║███████║
--    ╚═╝   ╚═╝   ╚═╝   ╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝

-- Titlebars
theme.titlebar_fg_focus = text_color
theme.titlebar_fg_normal =text_color
theme.titlebar_bg_focus = "#1F2021"
theme.titlebar_bg_normal = main_bg


local btn_dir = res_dir.."btn2/"
theme.titlebar_close_button_normal          = btn_dir.."close.png"
theme.titlebar_close_button_normal_hover    = btn_dir.."close2.png"
theme.titlebar_close_button_normal_press    = btn_dir.."close3.png"
theme.titlebar_close_button_focus           = btn_dir.."close.png"
theme.titlebar_close_button_focus_hover     = btn_dir.."close2.png"
theme.titlebar_close_button_focus_press     = btn_dir.."close3.png"

theme.titlebar_floating_button_normal                   = btn_dir.."retr.png"
theme.titlebar_floating_button_normal_active            = btn_dir.."retr3.png"
theme.titlebar_floating_button_normal_active_hover      = btn_dir.."retr2.png"
theme.titlebar_floating_button_normal_active_press      = btn_dir.."retr3.png"
theme.titlebar_floating_button_normal_inactive          = btn_dir.."retr.png"
theme.titlebar_floating_button_normal_inactive_hover    = btn_dir.."retr2.png"
theme.titlebar_floating_button_normal_inactive_press    = btn_dir.."retr3.png"
theme.titlebar_floating_button_focus                    = btn_dir.."retr.png"
theme.titlebar_floating_button_focus_active             = btn_dir.."retr3.png"
theme.titlebar_floating_button_focus_active_hover       = btn_dir.."retr2.png"
theme.titlebar_floating_button_focus_active_press       = btn_dir.."retr3.png"
theme.titlebar_floating_button_focus_inactive           = btn_dir.."retr.png"
theme.titlebar_floating_button_focus_inactive_hover     = btn_dir.."retr2.png"
theme.titlebar_floating_button_focus_inactive_press     = btn_dir.."retr3.png"

theme.titlebar_maximized_button_normal                  = btn_dir.."exp.png"
theme.titlebar_maximized_button_normal_active           = btn_dir.."exp3.png"
theme.titlebar_maximized_button_normal_active_hover     = btn_dir.."exp2.png"
theme.titlebar_maximized_button_normal_active_press     = btn_dir.."exp3.png"
theme.titlebar_maximized_button_normal_inactive         = btn_dir.."exp.png"
theme.titlebar_maximized_button_normal_inactive_hover   = btn_dir.."exp2.png"
theme.titlebar_maximized_button_normal_inactive_press   = btn_dir.."exp3.png"
theme.titlebar_maximized_button_focus                   = btn_dir.."exp.png"
theme.titlebar_maximized_button_focus_active            = btn_dir.."exp3.png"
theme.titlebar_maximized_button_focus_active_hover      = btn_dir.."exp2.png"
theme.titlebar_maximized_button_focus_active_press      = btn_dir.."exp3.png"
theme.titlebar_maximized_button_focus_inactive          = btn_dir.."exp.png"
theme.titlebar_maximized_button_focus_inactive_hover    = btn_dir.."exp2.png"
theme.titlebar_maximized_button_focus_inactive_press    = btn_dir.."exp3.png"

theme.titlebar_sticky_button_normal                  = btn_dir.."pin.png"
theme.titlebar_sticky_button_normal_active           = btn_dir.."pin3.png"
theme.titlebar_sticky_button_normal_active_hover     = btn_dir.."pin2.png"
theme.titlebar_sticky_button_normal_active_press     = btn_dir.."pin3.png"
theme.titlebar_sticky_button_normal_inactive         = btn_dir.."pin.png"
theme.titlebar_sticky_button_normal_inactive_hover   = btn_dir.."pin2.png"
theme.titlebar_sticky_button_normal_inactive_press   = btn_dir.."pin3.png"
theme.titlebar_sticky_button_focus                   = btn_dir.."pin.png"
theme.titlebar_sticky_button_focus_active            = btn_dir.."pin3.png"
theme.titlebar_sticky_button_focus_active_hover      = btn_dir.."pin2.png"
theme.titlebar_sticky_button_focus_active_press      = btn_dir.."pin3.png"
theme.titlebar_sticky_button_focus_inactive          = btn_dir.."pin.png"
theme.titlebar_sticky_button_focus_inactive_hover    = btn_dir.."pin2.png"
theme.titlebar_sticky_button_focus_inactive_press    = btn_dir.."pin3.png"


theme.useless_gap = 0


-- ██████╗ ██╗     ██╗███╗   ██╗ ██████╗
-- ██╔══██╗██║     ██║████╗  ██║██╔════╝
-- ██████╔╝██║     ██║██╔██╗ ██║██║  ███╗
-- ██╔══██╗██║     ██║██║╚██╗██║██║   ██║
-- ██████╔╝███████╗██║██║ ╚████║╚██████╔╝
-- ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝
-- For tabbed only
theme.tabbed_spawn_in_tab = false           -- whether a new client should spawn into the focused tabbing container

-- For tabbar in general
theme.tabbar_ontop  = true
theme.tabbar_radius = 12                     -- border radius of the tabbar
theme.tabbar_style = "default"              -- style of the tabbar ("default", "boxes" or "modern")
theme.tabbar_font = "Verdana 10"               -- font of the tabbar
theme.tabbar_size = 25                      -- size of the tabbar
theme.tabbar_position = "top"               -- position of the tabbar
theme.tabbar_bg_normal = "#000000"          -- background color of the focused client on the tabbar
theme.tabbar_fg_normal = "#bbbbbb"          -- foreground color of the focused client on the tabbar
theme.tabbar_bg_focus  = "#121212"          -- background color of unfocused clients on the tabbar
theme.tabbar_fg_focus  = "#bbbbbb"          -- foreground color of unfocused clients on the tabbar

-- the following variables are currently only for the "modern" tabbar style
theme.tabbar_color_close = "#f9929b"        -- chnges the color of the close button
theme.tabbar_color_min   = "#fbdf90"        -- chnges the color of the minimize button
theme.tabbar_color_float = "#ccaced"        -- chnges the color of the float button

-- mstab
theme.mstab_bar_ontop = true               -- whether you want to allow the bar to be ontop of clients
theme.mstab_dont_resize_slaves = true      -- whether the tabbed stack windows should be smaller than the
                                            -- currently focused stack window (set it to true if you use
                                            -- transparent terminals. False if you use shadows on solid ones
theme.mstab_bar_padding = 10         -- how much padding there should be between clients and your tabbar
                                            -- by default it will adjust based on your useless gaps.
                                            -- If you want a custom value. Set it to the number of pixels (int)
theme.mstab_border_radius = 12               -- border radius of the tabbar
theme.mstab_bar_height = 25                 -- height of the tabbar
theme.mstab_tabbar_position = "top"         -- position of the tabbar (mstab currently does not support left,right)
theme.mstab_tabbar_style = "default"        -- style of the tabbar ("default", "boxes" or "modern")
                                            -- defaults to the tabbar_style so only change if you want a
                                            -- different style for mstab and tabbed

theme.tag_preview_widget_border_radius = 10          -- Border radius of the widget (With AA)
theme.tag_preview_client_border_radius = 0          -- Border radius of each client in the widget (With AA)
theme.tag_preview_client_opacity = 1.0              -- Opacity of each client
theme.tag_preview_client_bg = "#000000"             -- The bg color of each client
theme.tag_preview_client_border_color = "#00ff00"   -- The border color of each client
theme.tag_preview_client_border_width = 0           -- The border width of each client
theme.tag_preview_widget_bg = "#232323"             -- The bg color of the widget
theme.tag_preview_widget_border_color = "#ff0000"   -- The border color of the widget
theme.tag_preview_widget_border_width = 0           -- The border width of the widget
theme.tag_preview_widget_margin = 10                 -- The margin of the widget





return theme


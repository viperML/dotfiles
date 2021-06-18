local gears = require("gears")

local config_dir = "~/.config/awesome/"
local res_dir = config_dir.."res/"

---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

theme.font          = "sans 8"

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

-- ███╗   ██╗ ██████╗ ███╗   ██╗      ██████╗ ███████╗███████╗ █████╗ ██╗   ██╗██╗  ████████╗
-- ████╗  ██║██╔═══██╗████╗  ██║      ██╔══██╗██╔════╝██╔════╝██╔══██╗██║   ██║██║  ╚══██╔══╝
-- ██╔██╗ ██║██║   ██║██╔██╗ ██║█████╗██║  ██║█████╗  █████╗  ███████║██║   ██║██║     ██║
-- ██║╚██╗██║██║   ██║██║╚██╗██║╚════╝██║  ██║██╔══╝  ██╔══╝  ██╔══██║██║   ██║██║     ██║
-- ██║ ╚████║╚██████╔╝██║ ╚████║      ██████╔╝███████╗██║     ██║  ██║╚██████╔╝███████╗██║
-- ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═══╝      ╚═════╝ ╚══════╝╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝
theme.titlebar_close_button_normal = res_dir.."btn/close.png"
theme.titlebar_close_button_focus  = res_dir.."btn/close.png"

theme.titlebar_floating_button_normal_inactive = res_dir.."btn/retr.png"
theme.titlebar_floating_button_focus_inactive  = res_dir.."btn/retr.png"
theme.titlebar_floating_button_normal_active = res_dir.."btn/retr2.png"
theme.titlebar_floating_button_focus_active  = res_dir.."btn/retr2.png"

theme.titlebar_maximized_button_normal_inactive = res_dir.."btn/exp.png"
theme.titlebar_maximized_button_focus_inactive  = res_dir.."btn/exp.png"
theme.titlebar_maximized_button_normal_active = res_dir.."btn/exp2.png"
theme.titlebar_maximized_button_focus_active  = res_dir.."btn/exp2.png"

theme.titlebar_sticky_button_normal_inactive = res_dir.."btn/pin.png"
theme.titlebar_sticky_button_focus_inactive  = res_dir.."btn/pin.png"
theme.titlebar_sticky_button_normal_active   = res_dir.."btn/pin2.png"
theme.titlebar_sticky_button_focus_active    = res_dir.."btn/pin2.png"


theme.useless_gap = 10

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
theme.mstab_dont_resize_slaves = false      -- whether the tabbed stack windows should be smaller than the
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


return theme


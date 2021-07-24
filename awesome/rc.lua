-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Default modkey.
modkey = "Mod4"

-- ██╗     ██╗██████╗ ██████╗  █████╗ ██████╗ ██╗   ██╗
-- ██║     ██║██╔══██╗██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝
-- ██║     ██║██████╔╝██████╔╝███████║██████╔╝ ╚████╔╝
-- ██║     ██║██╔══██╗██╔══██╗██╔══██║██╔══██╗  ╚██╔╝
-- ███████╗██║██████╔╝██║  ██║██║  ██║██║  ██║   ██║
-- ╚══════╝╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝

-- Built-in
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
local naughty = require('naughty')
local nconf = naughty.config
local helpers = require("helpers")

-- External
local sharedtags = require("sharedtags")
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local freedesktop = require("freedesktop")
local revelation = require("revelation")

local config_dir = "~/.config/awesome/"


-- ██████╗ ███████╗ █████╗ ██╗   ██╗████████╗██╗███████╗██╗   ██╗██╗        ██╗    ██████╗ ██████╗
-- ██╔══██╗██╔════╝██╔══██╗██║   ██║╚══██╔══╝██║██╔════╝██║   ██║██║        ██║   ██╔════╝██╔═══██╗
-- ██████╔╝█████╗  ███████║██║   ██║   ██║   ██║█████╗  ██║   ██║██║     ████████╗██║     ██║   ██║
-- ██╔══██╗██╔══╝  ██╔══██║██║   ██║   ██║   ██║██╔══╝  ██║   ██║██║     ██╔═██╔═╝██║     ██║   ██║
-- ██████╔╝███████╗██║  ██║╚██████╔╝   ██║   ██║██║     ╚██████╔╝███████╗██████║  ╚██████╗╚██████╔╝██╗
-- ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚═╝╚═╝      ╚═════╝ ╚══════╝╚═════╝   ╚═════╝ ╚═════╝ ╚═╝
beautiful.init(config_dir.."theme.lua")

revelation.init{
    charorder = "1234567890jkluiopyhnmfdsatgvcewqzx",
}


local lain = require("lain")
local bling = require("bling")


local corner_radius = 14
-- local bar_height = 29
local bar_height = 29

-- beautiful.taglist_shape_focus = helpers.rrect(3)

-- Other
terminal = "st"
menubar.utils.terminal = terminal
editor = os.getenv("EDITOR")
editor_cmd = terminal .. " -e " .. editor

awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
    bling.layout.mstab,
    bling.layout.centered,
    -- bling.layout.vertical,
    -- bling.layout.horizontal,
    bling.layout.equalarea,
}

local tags = sharedtags({
    { name = "  ", layout = awful.layout.layouts[2]},
    { name = " ﬏ ", layout = awful.layout.layouts[2]},
    { name = " 3 ", layout = awful.layout.layouts[2]},
    { name = " 4 ", layout = awful.layout.layouts[2]},
    { name = " 5 ", layout = awful.layout.layouts[2]},
    { name = " 6 ", layout = awful.layout.layouts[2], screen = 2},
    { name = "  ", layout = awful.layout.layouts[2]},
    { name = "  ", layout = awful.layout.layouts[1]},
    { name = "  ", layout = awful.layout.layouts[2], screen = 2},
    { name = "  ", layout = awful.layout.layouts[2], screen = 2},
})

-- Naughty
nconf.defaults.border_width = 0
nconf.defaults.margin = 16
nconf.defaults.shape = helpers.rrect(corner_radius)
nconf.defaults.text = "Boo!"
nconf.defaults.timeout = 5
nconf.padding = 8
nconf.presets.critical.bg = "#FE634E"
nconf.presets.critical.timeout = 0
nconf.presets.critical.fg = "#000000"
nconf.presets.low.bg = "#191919"
nconf.presets.normal.bg = "#191919"
nconf.defaults.icon_size = 64
nconf.spacing = 8
beautiful.notification_font = "Verdana 13"



-- ███╗   ███╗███████╗███╗   ██╗██╗   ██╗
-- ████╗ ████║██╔════╝████╗  ██║██║   ██║
-- ██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║
-- ██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║
-- ██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝
-- ╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝
local menu_awesome = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "restart", awesome.restart },
}

local menu_system = {
    { "restart naga", "systemctl --user restart nagastart.service" },
    { "restart logid", "sudo systemctl restart logid.service" },
    { "restart", "sudo reboot" },
    { "shutdown", "sudo shutdown now" },
    { "logout", function() awesome.quit() end },
}

local menu_screens = {
    { "autorandr -c", "systemctl --user restart autorandr.service" },
    { "autorandr -l horizontal", "systemctl --user restart autorandr-l.service" },
}

local menu_keyboard = {
    { "us", "setxkbmap -layout us" },
    { "es", "setxkbmap -layout es" }
}


menu = freedesktop.menu.build({
    before = {
        { "Awesome", menu_awesome, beautiful.awesome_icon },
        { "Keyboard", menu_keyboard },
        { "System", menu_system },
        { "Screens", menu_screens },
        { "Terminal", terminal }
    },
    after = {

    }
})


-- ██╗    ██╗██╗██████╗  █████╗ ██████╗
-- ██║    ██║██║██╔══██╗██╔══██╗██╔══██╗
-- ██║ █╗ ██║██║██████╔╝███████║██████╔╝
-- ██║███╗██║██║██╔══██╗██╔══██║██╔══██╗
-- ╚███╔███╔╝██║██████╔╝██║  ██║██║  ██║
--  ╚══╝╚══╝ ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝

muted_icon_color = '#707070'

widget_clock = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    widget = wibox.container.background,
    {
        -- markup = helpers.colorize_text('  ', '#ff92d0'),
        markup = helpers.colorize_text(' ', muted_icon_color),
        widget = wibox.widget.textbox,
    },
    {
        format = '%A %e %B - %H:%M:%S',
        refresh = 1,
        align = 'center',
        widget = wibox.widget.textclock
    }

}

--widget_updates = wibox.widget {
--    layout = wibox.layout.fixed.horizontal,
--    widget = wibox.container.background,
--    {
--        -- markup = helpers.colorize_text(' ', '#5af78e'),
--        markup = helpers.colorize_text(' ', muted_icon_color),
--        widget = wibox.widget.textbox,
--    },
--    {
--        awful.widget.watch([[ sh -c "echo -e \"$(checkupdates)\n$(paru -Qua)\" | sed '/ignored/ d;/^\s*$/ d' | wc -l" ]], 1800, function(widget, stdout)
--            widget:set_text(stdout)
--        end),
--        layout = wibox.layout.fixed.horizontal
--    },
--}


widget_fs_color = '#caa9fa'
widget_fs = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    widget = wibox.container.background,
    {
        -- markup = helpers.colorize_text(' ', widget_fs_color),
        markup = helpers.colorize_text(' ', muted_icon_color),
        widget = wibox.widget.textbox,
    },
    {
        awful.widget.watch([[ sh -c "lsblk -f | sed -n '/sdb1/p' | grep -o '[0-9]*%'" ]], 1800, function(widget, stdout)
            widget:set_text('sdb1: '..stdout)
        end),
        layout = wibox.layout.fixed.horizontal
    },
    {
        -- markup = helpers.colorize_text('   ', widget_fs_color),
        markup = helpers.colorize_text('   ', muted_icon_color),
        widget = wibox.widget.textbox,
    },
    {
        awful.widget.watch([[ sh -c "lsblk -f | sed -n '/sda1/p' | grep -o '[0-9]*%'" ]], 1800, function(widget, stdout)
            widget:set_text('efi:'..stdout)
        end),
        layout = wibox.layout.fixed.horizontal
    },
}


widget_battery = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    widget = wibox.container.background,
    {
        -- markup = helpers.colorize_text(' ', '#ff6e67'),
        markup = helpers.colorize_text(' ', muted_icon_color),
        widget = wibox.widget.textbox,
    },
    {
        awful.widget.watch([[ sh -c "$DOTDIR/bin/battery.sh" ]], 30, function(widget, stdout)
            widget:set_text(stdout)
        end),
        layout = wibox.layout.fixed.horizontal
    },
}

widget_spacer = wibox.widget {
    widget = wibox.widget.separator,
    forced_width = 10,
    thickness = 0,
}
widget_spacer_small = wibox.widget {
    widget = wibox.widget.separator,
    forced_width = 0,
    thickness = 0,
}

widget_test = wibox.widget {
    {
        markup = helpers.colorize_text('Hola', '#FF0000'),
        align  = 'center',
        valign = 'center',
        widget = wibox.widget.textbox,
    },
    bg = '#ffffff',
    shape_border_width = 3,
    shape_border_color = '#121212',
    shape = helpers.rrect(5),
    widget = wibox.container.background
}


-- Systreay
local systray = wibox.widget.systray()
systray : set_base_size(20)
widget_systray = wibox.container.margin(systray, 0, 0, (bar_height-20)/2, 0)



-- Idk where this is from
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

awful.screen.connect_for_each_screen(function(s)

 --   -- Bling Wallpaper
 --   bling.module.tiled_wallpaper("", s, {        -- call the actual function ("x" is the string that will be tiled)
 --       fg = "#27382A",  -- define the foreground color
 --       bg = "#212326",  -- define the background color
 --       offset_y = 15,   -- set a y offset
 --       offset_x = 15,   -- set a x offset
 --       font = "Font Awesome 5 Free Solid",   -- set the font (without the size)
 --       font_size = 10,  -- set the font size
 --       padding = 50,   -- set padding (default is 100)
 --       zickzack = true  -- rectangular pattern or criss cross
 --   })


    s.mypromptbox = awful.widget.prompt()

    -- Layout Icon
    s.mylayoutbox = awful.widget.layoutbox(s)
    local h_margin = 2
    local v_vargin = 7
    s.mylayoutbox = wibox.container.margin(s.mylayoutbox, h_margin, h_margin, v_vargin, v_vargin)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- Tag list
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons

    }

    -- Task list
    -- s.mytasklist = awful.widget.tasklist {
    --     screen  = s,
    --     filter  = awful.widget.tasklist.filter.currenttags,
    --     buttons = tasklist_buttons
    -- }

    local wibox_gap_x = beautiful.useless_gap*2
    local wibox_gap_y1 = 20
    local wibox_gap_y2 = -4
    local height = bar_height

    -- Manually create wibox (no awfulw.wibar)
    s.mywibox = wibox({
        screen = s,
        type = 'dock',
        width = s.geometry.width - wibox_gap_x*2,
        height = height,
        visible = true,
        bg = beautiful.wibar_bg,
        fg = beautiful.wibar_fg
    })
    s.mywibox.y = s.geometry.y + beautiful.useless_gap*2
    s.mywibox.x = s.geometry.x + wibox_gap_x

    s.mywibox:struts({
        --bottom =  50,
        top = beautiful.useless_gap*2 + height
    })
    s.mywibox.shape = function(cr,w,h)
        gears.shape.rounded_rect(cr,w,h,corner_radius)
    end

    s.wibox_splash = wibox({
        screen = s,
        type = 'splash',
        width = 200,
        height = 200,
        visible = true,
        bg = '#12121200',
        opacity = 1,
    })
    s.wibox_splash.y = s.geometry.y + s.geometry.height/2 - s.wibox_splash.height/2
    s.wibox_splash.x = s.geometry.width/2 + s.geometry.x - s.wibox_splash.width/2

    s.wibox_splash:setup {
        layout = wibox.layout.align.horizontal,
        {
            widget = wibox.widget.textbox,
        },
        -- {
        --     markup = helpers.colorize_text('I use arch btw', '#121212'),
        --     align  = 'center',
        --     valign = 'center',
        --     font = 'Noto Sans Bold 30',
        --     widget = wibox.widget.textbox,
        -- },
        {
            widget = wibox.widget.imagebox,
            resize = true,
            image = '/home/ayats/.dotfiles/neofetch/gentoo-round.png',
            -- image = '/home/ayats/Downloads/gif.gif'
        }
    }




    s.mywibox:setup {
            layout = wibox.layout.align.horizontal,

            { -- Left widgets
            -- {
            --     widget = wibox.widget.separator,
            --     forced_width = 5,
            --     thickness = 0,
            -- },
                layout = wibox.layout.fixed.horizontal,
                s.mytaglist,
            },

            -- Middle Widget
            widget_clock,

            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                spacing = 12,

                widget_fs,
                --widget_updates,
                widget_battery,
                s.mylayoutbox,
                volume_widget{
                    widget_type = 'icon_and_text',
                    width = 100,
                    mute_color = '#ffffff11',
                    margins = 7,
                    shape = 'rounded_bar'
                },
                widget_systray,
                widget_spacer_small,
            },
            expand = 'none',
    }
end)

-- ███╗   ███╗ ██████╗ ██╗   ██╗███████╗███████╗
-- ████╗ ████║██╔═══██╗██║   ██║██╔════╝██╔════╝
-- ██╔████╔██║██║   ██║██║   ██║███████╗█████╗
-- ██║╚██╔╝██║██║   ██║██║   ██║╚════██║██╔══╝
-- ██║ ╚═╝ ██║╚██████╔╝╚██████╔╝███████║███████╗
-- ╚═╝     ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝
root.buttons(gears.table.join(
    awful.button({ }, 3, function () menu:toggle() end)
    --awful.button({ }, 4, awful.tag.viewnext),
    --awful.button({ }, 5, awful.tag.viewprev)
))


-- ██╗  ██╗███████╗██╗   ██╗██████╗ ██╗███╗   ██╗██████╗ ███████╗
-- ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔══██╗██║████╗  ██║██╔══██╗██╔════╝
-- █████╔╝ █████╗   ╚████╔╝ ██████╔╝██║██╔██╗ ██║██║  ██║███████╗
-- ██╔═██╗ ██╔══╝    ╚██╔╝  ██╔══██╗██║██║╚██╗██║██║  ██║╚════██║
-- ██║  ██╗███████╗   ██║   ██████╔╝██║██║ ╚████║██████╔╝███████║
-- ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝

globalkeys = gears.table.join(
    awful.key({ modkey }, "h", hotkeys_popup.show_help,
              {description="show help", group="awesome"}),

    awful.key({ modkey }, "Right", function () awful.client.focus.byidx( 1) end,
        {description = "focus next by index", group = "client"} ),
    awful.key({ modkey }, "Left", function () awful.client.focus.byidx(-1) end,
        {description = "focus previous by index", group = "client"} ),
    awful.key({ modkey }, "Tab", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "Right", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift" }, "Left", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto,
               {description = "jump to urgent client", group = "client"}),
    -- awful.key({ modkey,           }, "Tab",
    --     function ()
    --         awful.client.focus.history.previous()
    --         if client.focus then
    --             client.focus:raise()
    --         end
    --     end,
    --     {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey, "Shift" }, "r", function ()  awesome.restart() end,
              {description = "reload awesome", group = "awesome"}),

    awful.key({ modkey }, "Return", function () awful.spawn(terminal) end,
              {description = "terminal", group = "launcher"}),

    awful.key({ modkey }, "space", function () awful.spawn("rofi -show combi") end,
              {description = "rofi", group = "launcher"}),

    awful.key({ modkey }, "e", function () awful.spawn("dolphin") end,
              {description = "file explorer", group = "launcher"}),

    awful.key({ "Any" }, "Print", function () awful.spawn("flameshot gui") end,
              {description = "take screenshot", group = "launcher"}),


    awful.key({ modkey }, "Up", function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey }, "Down", function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    -- awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
    --           {description = "increase the number of columns", group = "layout"}),
    -- awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
    --           {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey }, "l", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift" }, "l", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    -- Volume
    -- awful.key({ modkey }, "F8", function() volume_widget:inc() end),
    -- awful.key({ modkey }, "F7", function() volume_widget:dec() end),
    -- awful.key({ modkey }, "F6", function() volume_widget:toggle() end)

    -- awful.key({      }, "XF86AudioRaiseVolume", function() volume_widget:inc() end),
    -- awful.key({      }, "XF86AudioLowerVolume", function() volume_widget:dec() end),
    awful.key({      }, "XF86AudioRaiseVolume", function() awful.spawn([[ /home/ayats/.dotfiles/bin/change_volume +4 ]]) end),
    awful.key({      }, "XF86AudioLowerVolume", function() awful.spawn([[ /home/ayats/.dotfiles/bin/change_volume -4 ]]) end),
    awful.key({      }, "XF86AudioMute", function() volume_widget:toggle() end),
    awful.key({      }, "XF86AudioPlay", function() awful.spawn("playerctl play-pause") end),
    awful.key({      }, "XF86AudioPrev", function() awful.spawn("playerctl previous") end),
    awful.key({      }, "XF86AudioNext", function() awful.spawn("playerctl next") end),


    awful.key({      }, "XF86MonBrightnessUp", function() awful.spawn([[ xbacklight -inc +5 ]]) end),
    awful.key({      }, "XF86MonBrightnessDown", function() awful.spawn([[ xbacklight -inc -5 ]]) end),

    -- On the fly useless gaps change
    awful.key({ modkey }, "g", function () lain.util.useless_gaps_resize(1) end),
    awful.key({ modkey, "Shift"}, "g", function () lain.util.useless_gaps_resize(-1) end),

    -- Revelation
    awful.key({ modkey }, "r", revelation),
    awful.key({ modkey }, "p", revelation),
    awful.key({ modkey }, "Escape", awful.tag.history.restore)
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            --
            c.maximized = not c.maximized
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey            }, "z",  function(c) c.floating = not c.floating end,
              {description = "toggle floating", group = "client"}),
    -- awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
    --           {description = "move to master", group = "client"}),
    -- awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
    --           {description = "move to screen", group = "client"}),
    -- awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
    --           {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "s",      function (c) c.sticky = not c.sticky            end,
              {description = "toggle sticky", group = "client"})

)


-- ████████╗ █████╗  ██████╗ ███████╗
-- ╚══██╔══╝██╔══██╗██╔════╝ ██╔════╝
--    ██║   ███████║██║  ███╗███████╗
--    ██║   ██╔══██║██║   ██║╚════██║
--    ██║   ██║  ██║╚██████╔╝███████║
--    ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝
function bind_tag(tag_i, keysim)
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, keysim,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = tags[tag_i]
                        if tag then
                           sharedtags.viewonly(tag, screen)
                        end
                  end,
                  {description = "view tag #"..tag_i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, keysim,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = tags[tag_i]
                      if tag then
                         sharedtags.viewtoggle(tag, screen)
                      end
                  end,
                  {description = "toggle tag #" .. tag_i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, keysim,
                  function ()
                      if client.focus then
                          local tag = tags[tag_i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..tag_i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, keysim,
                  function ()
                      if client.focus then
                          local tag = tags[tag_i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. tag_i, group = "tag"})
    )
end

bind_tag(1, "1")
bind_tag(2, "2")
bind_tag(3, "3")
bind_tag(4, "4")
bind_tag(5, "5")
bind_tag(6, "6")
bind_tag(7, "7")
bind_tag(8, "8")
bind_tag(9, "9")
bind_tag(10, "0")


clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}


-- ██████╗ ██╗   ██╗██╗     ███████╗███████╗
-- ██╔══██╗██║   ██║██║     ██╔════╝██╔════╝
-- ██████╔╝██║   ██║██║     █████╗  ███████╗
-- ██╔══██╗██║   ██║██║     ██╔══╝  ╚════██║
-- ██║  ██║╚██████╔╝███████╗███████╗███████║
-- ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        class = {
          "Arandr",
          "MEGAsync",
          ".exe",
          "qemu-system-x86_64",
          "Blueman-manager"
        },
        role = {
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        },
      }, properties = {
          floating = true,
          ontop = true
      }
    },

    {
        rule =  { floating = true },
        properties = { ontop = true }
    },

    -- Add titlebars to normal clients and dialogs
    { rule_any = { type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    { rule = { class = "Firefox Beta" },
        properties = { tag = tags[1], switch_to_tags = true } },
    { rule = { class = "Code" },
        properties = { tag = tags[2], switch_to_tags = true } },
    { rule = { class = "discord" },
        properties = { tag = tags[9] } },
    { rule = { class = "Spotify" },
        properties = { tag = tags[10] } },
    { rule_any = { class = {"Lutris", "Steam"} },
        properties = { tag = tags[8] } },
    { rule = { class = "Thunderbird" },
        properties = { tag = tags[7], sticky = true } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    c.shape = function(cr,w,h)
        gears.shape.rounded_rect(cr,w,h,corner_radius)
    end
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Always floating ontop
client.connect_signal("property::floating", function(c)
    c.ontop= c.floating
end)

-- No corners on fullscreen apps
client.connect_signal("property::fullscreen", function(c)
    if c.fullscreen == true then
        c.shape = function(cr,w,h)
            gears.shape.rounded_rect(cr,w,h,0)
        end
    else
        c.shape = function(cr,w,h)
            gears.shape.rounded_rect(cr,w,h,corner_radius)
        end
    end
end)



-- ████████╗██╗████████╗██╗     ███████╗██████╗  █████╗ ██████╗
-- ╚══██╔══╝██║╚══██╔══╝██║     ██╔════╝██╔══██╗██╔══██╗██╔══██╗
--    ██║   ██║   ██║   ██║     █████╗  ██████╔╝███████║██████╔╝
--    ██║   ██║   ██║   ██║     ██╔══╝  ██╔══██╗██╔══██║██╔══██╗
--    ██║   ██║   ██║   ███████╗███████╗██████╔╝██║  ██║██║  ██║
--    ╚═╝   ╚═╝   ╚═╝   ╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    local vpad = 8
    local hpad = 4

    awful.titlebar(c, {
        size = bar_height
    }) : setup {
        { -- Left
            wibox.widget {
                widget = wibox.widget.separator,
                forced_width = vpad,
                thickness = 0,
            },
            wibox.container.margin(awful.titlebar.widget.closebutton(c),    hpad, hpad, vpad, vpad),
            wibox.container.margin(awful.titlebar.widget.floatingbutton(c), hpad, hpad, vpad, vpad),
            wibox.container.margin(awful.titlebar.widget.maximizedbutton(c),hpad, hpad, vpad, vpad),
            wibox.container.margin(awful.titlebar.widget.stickybutton(c),   hpad, hpad, vpad, vpad),
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            buttons = buttons,
            align = 'center',
            widget = awful.titlebar.widget.titlewidget(c),
        },
        {
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.align.horizontal,
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}




awful.spawn("nitrogen --restore")
-- awful.spawn("picom --experimental-backends")
awful.spawn.with_shell("systemctl --user import-environment PATH DBUS_SESSION_BUS_ADDRESS")
awful.spawn.with_shell("systemctl --no-block --user start xsession.target")

awful.spawn("xset r rate 200 40")
awful.spawn("xset s off -dpms")
awful.spawn("xset b off")





-- ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗         ███████╗██╗    ██╗ █████╗ ██╗     ██╗      ██████╗ ██╗    ██╗
-- ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║         ██╔════╝██║    ██║██╔══██╗██║     ██║     ██╔═══██╗██║    ██║
--    ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║         ███████╗██║ █╗ ██║███████║██║     ██║     ██║   ██║██║ █╗ ██║
--    ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║         ╚════██║██║███╗██║██╔══██║██║     ██║     ██║   ██║██║███╗██║
--    ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗    ███████║╚███╔███╔╝██║  ██║███████╗███████╗╚██████╔╝╚███╔███╔╝
--    ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝    ╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝  ╚══╝╚══╝
-- https://www.reddit.com/r/awesomewm/comments/h07f5y/does_awesome_support_window_swallowing/
--
-- function is_terminal(c)
--     return (c.class and c.class:match("st-256color")) and true or false
-- end
--
-- function copy_size(c, parent_client)
--     if not c or not parent_client then
--         return
--     end
--     if not c.valid or not parent_client.valid then
--         return
--     end
--     c.x=parent_client.x;
--     c.y=parent_client.y;
--     c.width=parent_client.width;
--     c.height=parent_client.height;
-- end
-- function check_resize_client(c)
--     if(c.child_resize) then
--         copy_size(c.child_resize, c)
--     end
-- end
--
-- client.connect_signal("property::size", check_resize_client)
-- client.connect_signal("property::position", check_resize_client)
-- client.connect_signal("manage", function(c)
--     if is_terminal(c) then
--         return
--     end
--     local parent_client=awful.client.focus.history.get(c.screen, 1)
--     if parent_client and is_terminal(parent_client) then
--         parent_client.child_resize=c
--         parent_client.minimized = true
--
--         c:connect_signal("unmanage", function() parent_client.minimized = false end)
--
--         -- c.floating=true
--         copy_size(c, parent_client)
--     end
-- end)

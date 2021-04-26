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
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
-- local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
local sharedtags = require("sharedtags")

local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local fs_widget = require("awesome-wm-widgets.fs-widget.fs-widget")

local lain = require("lain")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}



-- ██╗   ██╗ █████╗ ██████╗ ██╗ █████╗ ██████╗ ██╗     ███████╗███████╗
-- ██║   ██║██╔══██╗██╔══██╗██║██╔══██╗██╔══██╗██║     ██╔════╝██╔════╝
-- ██║   ██║███████║██████╔╝██║███████║██████╔╝██║     █████╗  ███████╗
-- ╚██╗ ██╔╝██╔══██║██╔══██╗██║██╔══██║██╔══██╗██║     ██╔══╝  ╚════██║
--  ╚████╔╝ ██║  ██║██║  ██║██║██║  ██║██████╔╝███████╗███████╗███████║
--   ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝╚══════╝

-- Beautiful
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- Layout
beautiful.useless_gap = 5
beautiful.wibar_height = 25
beautiful.wibar_shape = gears.shape.rounded_rect
beautiful.border_width = 0
-- beautiful.systray_icon_spacing = 5
beautiful.taglist_squares_sel = nil
beautiful.taglist_squares_unsel = nil


-- Text
beautiful.font = "Roboto 11"
beautiful.wibar_fg = '#d8d1c3'
beautiful.titlebar_fg_focus = '#d8d1c3'
beautiful.titlebar_fg_normal = '#d8d1c3'
beautiful.taglist_fg_focus = "#d35d6e"
beautiful.taglist_fg_empty = "#6a7066"
beautiful.taglist_fg_urgent = "#000"



-- Background
beautiful.titlebar_bg_focus = "#562639"
beautiful.titlebar_bg_normal = '#151515'
beautiful.wibar_bg = "#111111aa"
beautiful.taglist_bg_focus = "#00000000"
beautiful.taglist_bg_urgent   = "#d35d6e"

beautiful.bg_systray = '#111111aa'


-- Other
terminal = "kitty"
menubar.utils.terminal = terminal
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

local tags = sharedtags({
    { name = "", layout = awful.layout.layouts[2]},
    { name = "﬏", layout = awful.layout.layouts[2]},
    { name = "3", layout = awful.layout.layouts[2]},
    { name = "4", layout = awful.layout.layouts[2]},
    { name = "5", layout = awful.layout.layouts[2]},
    { name = "6", layout = awful.layout.layouts[2]},
    { name = "7", layout = awful.layout.layouts[2], screen = 2},
    { name = "", layout = awful.layout.layouts[1]},
    { name = "", layout = awful.layout.layouts[2]},
    { name = "", layout = awful.layout.layouts[2]},
})


-- ███╗   ███╗███████╗███╗   ██╗██╗   ██╗
-- ████╗ ████║██╔════╝████╗  ██║██║   ██║
-- ██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║
-- ██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║
-- ██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝
-- ╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   --{ "manual", terminal .. " -e man awesome" },
   -- { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   -- { "quit", function() awesome.quit() end },
}
mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal },
                                    { "restart", "sudo reboot" },
                                    { "shutdown", "sudo shutdown now" },
                                  }
                        })
-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()



-- ██╗    ██╗██╗██████╗  █████╗ ██████╗
-- ██║    ██║██║██╔══██╗██╔══██╗██╔══██╗
-- ██║ █╗ ██║██║██████╔╝███████║██████╔╝
-- ██║███╗██║██║██╔══██╗██╔══██║██╔══██╗
-- ╚███╔███╔╝██║██████╔╝██║  ██║██║  ██║
--  ╚══╝╚══╝ ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝

mytextclock = wibox.widget {
    format = '%A %e %B - %H:%M:%S',
    refresh = 1,
    align = 'center',
    widget = wibox.widget.textclock
}

widget_spacer = wibox.widget.textbox('      ')

widget_updates = awful.widget.watch('bash -c "~/.dotfiles/polybar/updates.sh"', 1800, function(widget, stdout)
    widget:set_text(" "..stdout)
end)

-- widget_volume = awful.widget.watch('bash -c \"amixer sget Master | grep -o "[[:digit:]]*\\%"\"', 1)


-- Create a wibox for each screen and add it
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
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons

    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        width = s.geometry.width - 100,
    })

    -- Add widgets to the wibox
    local systray = wibox.widget.systray()
    -- systray.forced_height = 100
    -- systray.forced_width = 180
    systray : set_base_size(20)
    local widget_systray = wibox.container.margin(systray, 0, 0, 2, 0)


    local layout =
    s.mywibox:setup {

            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                widget_spacer,
                layout = wibox.layout.fixed.horizontal,
                s.mytaglist,
            },

            mytextclock,
            -- s.mytasklist, -- Middle widget
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                spacing = 10,

                -- fs_widget({ mounts = { '/', '/mnt/x' } }), -- multiple mounts
                widget_updates,
                volume_widget{
                    widget_type = 'icon_and_text'
                },
                s.mylayoutbox,
                widget_systray,
                widget_spacer
            },
            expand = 'none',
    }
    s.mywibox.y = 4
end)

-- ███╗   ███╗ ██████╗ ██╗   ██╗███████╗███████╗
-- ████╗ ████║██╔═══██╗██║   ██║██╔════╝██╔════╝
-- ██╔████╔██║██║   ██║██║   ██║███████╗█████╗
-- ██║╚██╔╝██║██║   ██║██║   ██║╚════██║██╔══╝
-- ██║ ╚═╝ ██║╚██████╔╝╚██████╔╝███████║███████╗
-- ╚═╝     ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
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
    awful.key({ modkey,           }, "h",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- Layout manipulation
    awful.key({ modkey,           }, "Left", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey,           }, "Right", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Shift" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Shift" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
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
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),


    awful.key({ modkey, "Shift"   }, "Up",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "Down",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    -- awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
    --           {description = "increase the number of columns", group = "layout"}),
    -- awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
    --           {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "Up", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey,           }, "Down", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    -- Volume
    awful.key({ modkey }, "F8", function() volume_widget:inc() end),
    awful.key({ modkey }, "F7", function() volume_widget:dec() end),
    awful.key({ modkey }, "F6", function() volume_widget:toggle() end)
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey            }, "z",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    -- awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
    --           {description = "move to master", group = "client"}),
    -- awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
    --           {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
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
          "Gpick",
          "MEGAsync",
          "explorer.exe",
          "photoshop.exe"},
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = {
          floating = true,
          ontop = true,
      }
    },

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    { rule = { class = "Vivaldi-stable" },
       properties = { tag = tags[1], switch_to_tags = true }
    },
    { rule = { class = "VSCodium" },
        properties = { tag = tags[2], switch_to_tags = true } },
    { rule = { class = "discord" },
        properties = { tag = tags[9] } },
    { rule = { class = "Genymotion Player" },
        properties = { tag = tags[8] } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
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

    awful.titlebar(c, {
        size = 25
    }) : setup {
        { -- Left
            wibox.widget.textbox('  '),
            { -- Title
                align  = "left",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            -- awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            -- { -- Title
            --     align  = "center",
            --     widget = awful.titlebar.widget.titlewidget(c)
            -- },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right

            awful.titlebar.widget.floatingbutton (c),
            -- awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            wibox.widget.textbox('  '),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}




awful.spawn.with_shell("nitrogen --restore")
awful.spawn.with_shell("picom")
awful.spawn.with_shell("systemctl --user import-environment PATH DBUS_SESSION_BUS_ADDRESS")
awful.spawn.with_shell("systemctl --no-block --user start xsession.target")
awful.spawn.with_shell("autorandr -c")
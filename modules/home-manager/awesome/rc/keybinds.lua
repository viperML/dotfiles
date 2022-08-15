local modkey = C.modkey
local awful = require "awful"

awful.mouse.append_global_mousebindings {
  awful.button({}, 3, function()
    C.menu:toggle()
  end),
}

awful.keyboard.append_global_keybindings {

  awful.key({ modkey }, "Right", function()
    awful.client.focus.byidx(1)
  end, { description = "focus next by index", group = "client" }),
  awful.key({ modkey }, "Left", function()
    awful.client.focus.byidx(-1)
  end, { description = "focus previous by index", group = "client" }),

  -- Layout manipulation
  awful.key({ modkey, "Shift" }, "Right", function()
    awful.client.swap.byidx(1)
  end, { description = "swap with next client by index", group = "client" }),
  awful.key({ modkey, "Shift" }, "Left", function()
    awful.client.swap.byidx(-1)
  end, { description = "swap with previous client by index", group = "client" }),
  awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
  awful.key({ modkey }, "Tab", function()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end, { description = "focus previous window", group = "client" }),

  -- Standard program
  awful.key({ modkey, "Shift" }, "r", function()
    awesome.restart()
  end, { description = "reload awesome", group = "awesome" }),

  -- FIXME
  awful.key({ modkey }, "Return", function()
    awful.spawn "wezterm"
  end, { description = "terminal", group = "launcher" }),

  awful.key({ modkey }, "space", function()
    awful.spawn "rofi -show drun"
  end, { description = "rofi", group = "launcher" }),

  -- fixme
  awful.key({ modkey }, "e", function()
    awful.spawn "dolphin"
  end, { description = "file explorer", group = "launcher" }),

  awful.key({ modkey, "Shift" }, "s", function()
    awful.spawn "flameshot gui"
  end, { description = "take screenshot", group = "launcher" }),

  awful.key({ modkey }, "Up", function()
    awful.tag.incnmaster(1, nil, true)
  end, { description = "increase the number of master clients", group = "layout" }),
  awful.key({ modkey }, "Down", function()
    awful.tag.incnmaster(-1, nil, true)
  end, { description = "decrease the number of master clients", group = "layout" }),
  awful.key({ modkey }, "l", function()
    awful.layout.inc(1)
  end, { description = "select next layout", group = "layout" }),
  awful.key({ modkey, "Shift" }, "l", function()
    awful.layout.inc(-1)
  end, { description = "select previous layout", group = "layout" }),

  awful.key({}, "XF86AudioRaiseVolume", function()
    awful.spawn [[ wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ ]]
  end),
  awful.key({}, "XF86AudioLowerVolume", function()
    awful.spawn [[ wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ]]
  end),
  awful.key({}, "XF86AudioMute", function()
    awful.spawn [[ wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ]]
  end),
  -- awful.key({      }, "XF86AudioPlay", function() awful.spawn("playerctl play-pause") end),
  -- awful.key({      }, "XF86AudioPrev", function() awful.spawn("playerctl previous") end),
  -- awful.key({      }, "XF86AudioNext", function() awful.spawn("playerctl next") end),

  -- awful.key({      }, "XF86MonBrightnessUp", function() awful.spawn([[ xbacklight -inc +5 ]]) end),
  awful.key({}, "XF86MonBrightnessDown", function()
    awful.spawn [[ xbacklight -inc -5 ]]
  end),

  -- On the fly useless gaps change
  awful.key({ modkey }, "g", function()
    lain.util.useless_gaps_resize(1)
  end),
  awful.key({ modkey, "Shift" }, "g", function()
    lain.util.useless_gaps_resize(-1)
  end),
}

awful.keyboard.append_global_keybindings {
  awful.key {
    modifiers = { modkey },
    keygroup = "numrow",
    description = "toggle single tag",
    group = "tag",
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        tag:view_only()
      end
    end,
  },
  awful.key {
    modifiers = { modkey, "Control" },
    keygroup = "numrow",
    description = "toggle tag",
    group = "tag",
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end,
  },
  awful.key {
    modifiers = { modkey, "Shift" },
    keygroup = "numrow",
    description = "move focused client to tag",
    group = "tag",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end,
  },
  awful.key {
    modifiers = { modkey, "Control", "Shift" },
    keygroup = "numrow",
    description = "toggle focused client on tag",
    group = "tag",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end,
  },
  awful.key {
    modifiers = { modkey },
    keygroup = "numpad",
    description = "select layout directly",
    group = "layout",
    on_press = function(index)
      local t = awful.screen.focused().selected_tag
      if t then
        t.layout = t.layouts[index] or t.layout
      end
    end,
  },
}

client.connect_signal("request::default_mousebindings", function()
  awful.mouse.append_client_mousebindings {
    awful.button({}, 1, function(c)
      c:activate { context = "mouse_click" }
    end),
    awful.button({ modkey }, 1, function(c)
      c:activate { context = "mouse_click", action = "mouse_move" }
    end),
    awful.button({ modkey }, 3, function(c)
      c:activate { context = "mouse_click", action = "mouse_resize" }
    end),
  }
end)

client.connect_signal("request::default_keybindings", function()
  awful.keyboard.append_client_keybindings {
    awful.key({ modkey }, "f", function(c)
      --
      c.maximized = not c.maximized
      c.fullscreen = not c.fullscreen
      c:raise()
    end, { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey }, "q", function(c)
      c:kill()
    end, { description = "close", group = "client" }),
    awful.key({ modkey }, "z", function(c)
      c.floating = not c.floating
    end, { description = "toggle floating", group = "client" }),
    -- awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
    --           {description = "move to master", group = "client"}),
    -- awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
    --           {description = "move to screen", group = "client"}),
    -- awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
    --           {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey }, "s", function(c)
      c.sticky = not c.sticky
    end, { description = "toggle sticky", group = "client" }),
  }
end)

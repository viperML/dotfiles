local awful = require "awful"
local wibox = require "wibox"
local beautiful = require "beautiful"
local gears = require "gears"
local helpers = require "helpers"
local bling = require "bling"

local themes_path = gears.filesystem.get_themes_dir()

local start_icon = wibox.widget {
  widget = wibox.container.margin,
  margins = 5,
  -- buttons = {
  --     awful.button({}, 1, function()
  --         menu.toggle()
  --     end),
  -- },
  {
    widget = wibox.widget.imagebox,
    stylesheet = " * { stroke: " .. beautiful.fg_normal .. " }",
    image = themes_path .. "zenburn/awesome-icon.png",
  },
}
helpers.add_hover_cursor(start_icon, "hand2")

local taglist = function(s)
  bling.widget.tag_preview.enable {
    show_client_content = true,
    placement_fn = function(c) -- Place the widget using awful.placement (this overrides x & y)
      awful.placement.top_left(c, {
        margins = {
          top = 20,
          left = 65,
        },
      })
    end,
  }
  return awful.widget.taglist {
    screen = s,
    filter = awful.widget.taglist.filter.noempty,
    layout = { spacing = 5, layout = wibox.layout.fixed.vertical },
    buttons = {
      awful.button({}, 1, function(t)
        t:view_only()
      end),
      awful.button({}, 3, awful.tag.viewtoggle),
      awful.button({}, 4, function(t)
        awful.tag.viewprev(t.screen)
      end),
      awful.button({}, 5, function(t)
        awful.tag.viewnext(t.screen)
      end),
    },
    widget_template = {
      {
        {
          id = "text_role",
          widget = wibox.widget.textbox,
          align = "center",
          valign = "center",
        },
        margins = 2,
        widget = wibox.container.margin,
      },
      id = "background_role",
      widget = wibox.container.background,
      create_callback = function(self, c3, index, objects) --luacheck: no unused args
        self:connect_signal("mouse::enter", function()
          if #c3:clients() > 0 then
            awesome.emit_signal("bling::tag_preview::update", c3)
            awesome.emit_signal("bling::tag_preview::visibility", s, true)
          end
        end)
        self:connect_signal("mouse::leave", function()
          awesome.emit_signal("bling::tag_preview::visibility", s, false)

          if self.has_backup then
            self.bg = self.backup
          end
        end)
      end,
    },
  }
end

local time = wibox.widget {
  widget = wibox.container.background,
  bg = beautiful.bg_subtle,
  -- buttons = {
  --   awful.button({}, 1, function()
  --     require "ui.widget.calendar"()
  --   end),
  -- },
  {
    widget = wibox.container.margin,
    margins = 7,
    {
      layout = wibox.layout.fixed.vertical,
      {
        widget = wibox.widget.textclock "%H",
        font = beautiful.font_name .. " Black 12",
        align = "center",
      },
      {
        widget = wibox.widget.textclock "%M",
        font = beautiful.font_name .. " Black 12",
        align = "center",
      },
    },
  },
}

helpers.add_hover_cursor(time, "hand2")

local time_t = awful.tooltip {
  objects = { time },
  delay_show = 0.5,
  timer_function = function()
    return os.date "%A %B %d %Y"
  end,
}

local layoutbox = wibox.widget {
  bg = beautiful.bg_subtle,
  fg = beautiful.fg_time,
  widget = wibox.container.background,
  buttons = {
    -- awful.button({}, 1, function()
    --   require "ui.widget.layoutlist"()
    -- end),
    awful.button({}, 4, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 5, function()
      awful.layout.inc(-1)
    end),
  },
  {
    widget = wibox.container.margin,

    margins = 10,
    {
      widget = awful.widget.layoutbox,
    },
  },
}

helpers.add_hover_cursor(layoutbox, "hand2")

-- local systray = wibox.widget.systray()
-- systray:set_horizontal(false)
-- systray.base_size = 20

-- local sytray_p = wibox.container.place {
--   widget = systray,
--   halign = "center",
--   valign = "center",
-- }
local systray = wibox.widget {
  widget = wibox.container.background,
  bg = beautiful.bg_subtle,
  fg = beautiful.fg_time,
  {
    widget = wibox.container.margin,
    margins = 10,
    {
      widget = wibox.widget.systray,
      horizontal = false,
      base_size = 20,
    },
  },
}

screen.connect_signal("request::desktop_decoration", function(s)
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

  s.wb = awful.wibar {
    position = "left",
    width = 40,
    screen = s,
    widget = {
      layout = wibox.layout.align.vertical,
      {
        layout = wibox.layout.fixed.vertical,
        start_icon,
        taglist(s),
      },
      nil,
      {
        layout = wibox.layout.fixed.vertical,
        systray,
        layoutbox,
        time,
      },
    },
  }
end)

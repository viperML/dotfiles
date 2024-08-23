local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")
local bling = require("bling")

local themes_path = gears.filesystem.get_themes_dir()

local start_icon = wibox.widget {
  widget = wibox.container.margin,
  margins = 10,
  -- buttons = {
  --   awful.button({}, 1, function()
  --     C.menu.toggle()
  --   end),
  -- },
  {
    widget = wibox.widget.imagebox,
    -- stylesheet = " * { stroke: " .. beautiful.fg_normal .. " }",
    image = beautiful.awesome_icon,
  },
}
-- helpers.add_hover_cursor(start_icon, "hand2")

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
        widget = wibox.widget.textclock("%H"),
        font = beautiful.font_name .. " Black 14",
        align = "center",
      },
      {
        widget = wibox.widget.textclock("%M"),
        font = beautiful.font_name .. " Black 14",
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
    return os.date("%A %B %d %Y")
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
  -- bg = beautiful.bg_subtle,
  -- fg = beautiful.fg_time,
  -- bg = "#F00",
  -- fg = "#0F0",
  {
    widget = wibox.container.margin,
    forced_width = beautiful.bar_thickness,
    left = beautiful.bar_thickness / 2 - 10 - 4,
    bottom = 5,
    top = 10,
    {
      widget = wibox.widget.systray,
      horizontal = false,
      base_size = 20,
    },
  },
}

screen.connect_signal("request::desktop_decoration", function(s)
  awful.tag({
    "Ⅰ",
    "Ⅱ",
    "Ⅲ",
    "Ⅳ",
    "Ⅴ",
    "Ⅵ",
    "Ⅶ",
    "Ⅷ",
    "Ⅸ",
  }, s, awful.layout.layouts[1])

  s.wb = awful.wibar {
    position = "left",
    width = beautiful.bar_thickness,
    screen = s,
    widget = {
      layout = wibox.layout.align.vertical,
      { -- Top
        start_icon,
        {
          {
            layout = wibox.layout.fixed.vertical,
            require("ui.taglist")(s),
          },
          widget = wibox.container.margin,
          margins = beautiful.taglist_sidemargins,
        },
        layout = wibox.layout.fixed.vertical,
      },
      { -- Middle
        widget = wibox.container.place,
        halign = "center",
        {
          widget = require("ui.tasklist")(s),
        },
      },
      {
        widget = wibox.container.margin,
        margins = 4,
        {
          widget = wibox.container.background,
          bg = beautiful.bg_systray,
          shape = helpers.rrect(7),
          {
            layout = wibox.layout.fixed.vertical,
            systray,
            layoutbox,
            time,
          },
        },
      },
    },
  }
end)

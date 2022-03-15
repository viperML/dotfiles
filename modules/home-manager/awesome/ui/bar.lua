local awful = require "awful"
local wibox = require "wibox"
local beautiful = require "beautiful"
local gears = require "gears"
local helpers = require "helpers"
local bling = require "bling"

local themes_path = gears.filesystem.get_themes_dir()

local start_icon = wibox.widget {
  widget = wibox.container.margin,
  margins = 7,
  -- buttons = {
  --   awful.button({}, 1, function()
  --     C.menu.toggle()
  --   end),
  -- },
  {
    widget = wibox.widget.imagebox,
    stylesheet = " * { stroke: " .. beautiful.fg_normal .. " }",
    image = themes_path .. "zenburn/awesome-icon.png",
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
    forced_width = beautiful.bar_thickness,
    left = beautiful.bar_thickness / 4 + 1,
    bottom = 5,
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
    width = beautiful.bar_thickness,
    screen = s,
    widget = {
      layout = wibox.layout.align.vertical,
      {
        {
          layout = wibox.layout.fixed.vertical,
          start_icon,
          require "ui.taglist"(s),
          spacing = 10,
        },
        widget = wibox.container.margin,
        margins = 5,
      },
      {
        widget = wibox.container.place,
        halign = "center",
        {
          widget = require "ui.tasklist"(s),
        },
      },
      {
        layout = wibox.layout.fixed.vertical,
        systray,
        layoutbox,
        time,
      },
    },
  }
end)

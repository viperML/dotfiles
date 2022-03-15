local helpers = require "rc.helpers"
local awful = require "awful"
local bling = require "bling"
local wibox = require "wibox"
local beautiful = require "beautiful"

return function(s)
  bling.widget.task_preview.enable {
    placement_fn = function(c)
      awful.placement.left(c, {
        margins = {
          left = 60,
        },
      })
    end,
  }

  return awful.widget.tasklist {
    screen = s,
    filter = awful.widget.tasklist.filter.allscreen,
    buttons = {
      awful.button({}, 1, function(c)
        -- c:activate { context = "tasklist", action = "toggle_minimization" }
        c.first_tag:view_only()
        c:activate {}
      end),
      awful.button({}, 3, function()
        awful.menu.client_list { theme = { width = 250 } }
      end),
      awful.button({}, 4, function()
        awful.client.focus.byidx(-1)
      end),
      awful.button({}, 5, function()
        awful.client.focus.byidx(1)
      end),
    },
    style = {
      shape = helpers.rrect(10),
    },
    layout = {
      spacing = 4,
      forced_num_cols = 1,
      layout = wibox.layout.grid.vertical,
    },
    widget_template = {
      {
        {
          id = "clienticon",
          widget = awful.widget.clienticon,
        },
        margins = 5,
        widget = wibox.container.margin,
      },
      id = "background_role",
      forced_width = 38,
      forced_height = 38,
      widget = wibox.container.background,
      create_callback = function(self, c, index, objects) --luacheck: no unused
        self:get_children_by_id("clienticon")[1].client = c
        self:connect_signal("mouse::enter", function()
          awesome.emit_signal("bling::task_preview::visibility", s, true, c)
        end)
        self:connect_signal("mouse::leave", function()
          awesome.emit_signal("bling::task_preview::visibility", s, false, c)
        end)
      end,
    },
  }
end

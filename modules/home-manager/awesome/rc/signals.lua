local gears = require "gears"
local awful = require "awful"
local beautiful = require "beautiful"

client.connect_signal("manage", function(c)
  -- Rounded corners
  c.shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, beautiful.corners)
  end

  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  if not awesome.startup then
    awful.client.setslave(c)
  end

  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

client.connect_signal("property::floating", function(c)
  c.ontop = c.floating
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:activate { context = "mouse_enter", raise = false }
end)

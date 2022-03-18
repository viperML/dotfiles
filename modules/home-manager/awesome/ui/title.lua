local awful = require "awful"
local wibox = require "wibox"
local beautiful = require "beautiful"
local dpi = require("beautiful.xresources").apply_dpi

client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = {
    awful.button({}, 1, function()
      c:activate { context = "titlebar", action = "mouse_move" }
    end),
    awful.button({}, 3, function()
      c:activate { context = "titlebar", action = "mouse_resize" }
    end),
  }


  awful.titlebar(c, {
    size = beautiful.titlebar_height,
    position = "top",
    font = beautiful.font_name .. " Bold 10",
  }):setup {
    {
      {
        awful.titlebar.widget.closebutton(c),
        -- awful.titlebar.widget.maximizedbutton(c),
        -- awful.titlebar.widget.minimizebutton(c),
        awful.titlebar.widget.stickybutton(c),
        layout = wibox.layout.fixed.horizontal,
        spacing =  beautiful.titlebar_icons_margin_internal,
      },
      widget = wibox.container.margin,
      -- TODO move to beautiful
      top = beautiful.titlebar_icons_margin_vertical,
      bottom = beautiful.titlebar_icons_margin_vertical,
      left = beautiful.titlebar_icons_margin_horizontal,
      right = beautiful.titlebar_icons_margin_horizontal,
    },
    {
      widget = awful.titlebar.widget.titlewidget(c),
      buttons = buttons,
    },
    {
      buttons = buttons,
      layout = wibox.layout.fixed.horizontal,
    },
    layout = wibox.layout.align.horizontal,
    expand = "none",
  }
end)

local gears = require "gears"
local awful = require "awful"
require "awful.autofocus"
local wibox = require "wibox"
local beautiful = require "beautiful"
local naughty = require "naughty"
local ruled = require "ruled"

naughty.connect_signal("request::display_error", function(message, startup)
  naughty.notification {
    urgency = "critical",
    title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
    message = message,
  }
end)

awful.spawn 'bash -c "systemctl --user import-environment && systemctl --user start awesome-session.target"'
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/dark.lua")

C = {}
C.modkey = "Mod4"

require "rc.menu"
require "rc.notifications"
require "rc.rules"
require "rc.keybinds"
require "rc.signals"


require "ui.bar"
require "ui.title"

local awful = require "awful"
local freedesktop = require "freedesktop"
local hotkeys_popup = require "awful.hotkeys_popup"

local menu_system = {
  {
    "Hotkeys manual",
    function()
      hotkeys_popup.show_help(nil, awful.screen.focused())
    end,
  },
  { "Restart Awesome", awesome.restart },
  {
    "Quit Awesome",
    function()
      awesome.quit()
    end,
  },
  { "Restart PC", "systemctl reboot" },
  { "Shutdown PC", "systemctl poweroff" },
}

C.menu = freedesktop.menu.build {
  before = {
    { "Change wallpaper", function()
      awful.spawn("nitrogen")
    end},
    { "System", menu_system },
  },
  after = {},
}

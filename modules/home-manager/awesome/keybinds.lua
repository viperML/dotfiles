local modkey = "Mod4"
local awful = require "awful"

-- Programs
awful.keyboard.append_global_keybindings {
    awful.key({ modkey }, "e", function()
        awful.spawn "nautilus"
    end),
}

-- awful.keyboard.append_global_keybindings({
-- 	awful.key({ modkey }, "h", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
-- 	-- awful.key({ modkey, "Shift" }, "r", function()
-- 	-- 	awesome.restart()
-- 	-- end, { description = "reload awesome", group = "awesome" }),
-- })

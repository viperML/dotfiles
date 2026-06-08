require("monitors")

local terminal = "alacritty"
local fileManager = "dolphin"
local launch = "uwsm-app -t service --"

---@param command string
local function noctalia(command)
  return function()
    hl.exec_cmd("noctalia-shell ipc call " .. command)
  end
end

---@param command string
local function run(command)
  return function()
    hl.exec_cmd("uwsm-app -t service -- " .. command)
  end
end

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

hl.config {
  general = {
    gaps_in = 5,
    gaps_out = 5,

    border_size = 2,

    col = {
      active_border = "rgba(98971aff)",
      inactive_border = "rgba(282828ff)",
    },

    resize_on_border = false,
    allow_tearing = false,
    layout = "master",
  },

  decoration = {
    rounding = 9,
    rounding_power = 2,

    active_opacity = 1.0,
    inactive_opacity = 1.0,

    shadow = {
      enabled = true,
      range = 10,
      render_power = 4,
      color = "rgba(1a1a1a33)",
    },

    blur = {
      enabled = false,
      size = 3,
      passes = 1,
      vibrancy = 0.1696,
    },
  },

  animations = {
    enabled = true,
  },
}

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.animation { leaf = "global", enabled = true, speed = 10, bezier = "default" }
hl.animation { leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" }
hl.animation { leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" }
hl.animation { leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" }
hl.animation { leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" }
hl.animation { leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" }
hl.animation { leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" }
hl.animation { leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" }
hl.animation { leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" }
hl.animation { leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" }
hl.animation { leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" }
hl.animation { leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" }
hl.animation { leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" }
hl.animation { leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" }
hl.animation { leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" }
hl.animation { leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" }
hl.animation { leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" }

hl.config {
  master = {
    new_status = "slave",
  },
}

hl.config {
  misc = {
    force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
    disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
  },
}

hl.config {
  input = {
    kb_layout = "us,es",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",

    follow_mouse = 1,

    sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

    touchpad = {
      natural_scroll = true,
    },
  },

  xwayland = {
    force_zero_scaling = true,
  },
}

hl.device {
  name = "at-translated-set-2-keyboard",
  kb_layout = "es",
}

hl.device {
  name = "pixart-imaging--inc.-incott-8k-wireless-mouse-1",
  accel_profile = "flat",
}

hl.device {
  name = "squalius-cephalus-silakka54",
  kb_layout = "us",
  kb_variant = "altgr-intl",
}

hl.device {
  name = "logitech-usb-keyboard",
  kb_layout = "es",
}

hl.device {
  name = "pixart-dell-ms116-usb-optical-mouse",
  accel_profile = "flat",
}

hl.gesture {
  fingers = 4,
  direction = "horizontal",
  action = "workspace",
}

hl.gesture {
  fingers = 4,
  direction = "pinchout",
  action = noctalia("launcher toggle"),
}

hl.gesture {
  fingers = 4,
  direction = "pinchin",
  action = "close",
}

---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(launch .. " " .. terminal))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(launch .. " " .. fileManager))
hl.bind(mainMod .. " + Z", hl.dsp.window.float { action = "toggle" })
hl.bind(mainMod .. " + Space", noctalia("launcher toggle"))
hl.bind(mainMod .. " + SHIFT + S", run("screenshot"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus { direction = "left" })
hl.bind(mainMod .. " + right", hl.dsp.focus { direction = "right" })
hl.bind(mainMod .. " + up", hl.dsp.focus { direction = "up" })
hl.bind(mainMod .. " + down", hl.dsp.focus { direction = "down" })

-- Resize windows with mainMod + SHIFT + arrow keys
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize { x = -40, y = 0 })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize { x = 40, y = 0 })
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize { x = 0, y = -40 })
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize { x = 0, y = 40 })

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus { workspace = i })
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move { workspace = i })
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus { workspace = "e+1" })
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus { workspace = "e-1" })

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", noctalia("volume increase"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", noctalia("volume decrease"), { locked = true, repeating = true })
hl.bind("Prior", noctalia("volume increase"), { locked = true, repeating = true })
hl.bind("Next", noctalia("volume decrease"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", noctalia("volume muteOutput"), { locked = true })
hl.bind("XF86MonBrightnessUp", noctalia("brightness increase"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", noctalia("brightness decrease"), { locked = true, repeating = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule {
  -- Ignore maximize requests from all apps. You'll probably like this.
  name = "suppress-maximize-events",
  match = { class = ".*" },

  suppress_event = "maximize",
}

hl.window_rule {
  -- Fix some dragging issues with XWayland
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },

  no_focus = true,
}

hl.window_rule {
  name = "satty-float",
  match = { class = "com\\.gabm\\.satty" },
  float = true,
}

hl.window_rule {
  name = "nwg-displays-float",
  match = { class = "nwg-displays" },
  float = true,
}

hl.window_rule {
  name = "x2go-float",
  match = { class = "X2GoAgent" },
  float = true,
}

hl.window_rule {
  name = "zoom-float",
  match = { class = "zoom" },
  float = true,
  no_initial_focus = true,
}

hl.window_rule {
  name = "xdg-desktop-portal-gtk-float",
  match = { class = "xdg-desktop-portal-gtk" },
  float = true,
}

-- Hyprland-run windowrule
hl.window_rule {
  name = "move-hyprland-run",
  match = { class = "hyprland-run" },

  move = "20 monitor_h-120",
  float = true,
}

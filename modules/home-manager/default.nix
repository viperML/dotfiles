{
  lib,
  config,
  ...
}: {
  flake.homeModules = config.flake.lib.importFilesToAttrs ./. [
    "awesome"
    "common"
    "eww"
    "flatpak"
    "gnome"
    "gui"
    "hyprland"
    "kde"
    "nh"
    "picom"
    "podman"
    "rofi"
    "sway"
    "way-displays"
    "waybar"
    "xdg-ninja"
    "xsettingsd"
  ];
}

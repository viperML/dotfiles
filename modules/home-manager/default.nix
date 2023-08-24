{
  lib,
  config,
  ...
}: {
  flake.homeModules = config.flake.lib.importFilesToAttrs ./. [
    "common"
    "emacs"
    "gnome"
    "hyprland"
    "sway"
    "waybar"
    "browser"
  ];
}

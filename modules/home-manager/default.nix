{config, ...}: {
  flake.homeModules = config.flake.lib.importFilesToAttrs ./. [
    "common"
    "emacs"
    "gnome"
    "hyprland"
    "plasma5"
    "sway"
    "waybar"
    "browser"
  ];
}

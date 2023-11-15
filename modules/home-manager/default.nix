{config, ...}: {
  flake.homeModules = config.flake.lib.importFilesToAttrs ./. [
    "browser"
    "common"
    "emacs"
    "git"
    "gnome"
    "hyprland"
    "plasma5"
    "sway"
    "waybar"
  ];
}

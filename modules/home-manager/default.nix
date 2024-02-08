{config, ...}: {
  flake.homeModules = config.flake.lib.importFilesToAttrs ./. [
    "browser"
    "common"
    "emacs"
    "emacs-doom"
    "git"
    "gnome"
    "guix"
    "hyprland"
    "plasma5"
    "sway"
    "waybar"
  ];
}

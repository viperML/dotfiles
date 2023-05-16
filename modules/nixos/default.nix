{config, ...}: {
  flake.nixosModules = config.flake.lib.importFilesToAttrs ./. [
    "common"
    "plasma5"
    "podman"
    "tailscale"
    "hyprland"
    "sway"
    "wayland-compositors"
    "user-ayats"
    "user-soch"
    "warp"
    "gnome"
  ];
}

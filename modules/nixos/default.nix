{config, ...}: {
  flake.nixosModules = config.flake.lib.importFilesToAttrs ./. [
    "common"
    "kde"
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

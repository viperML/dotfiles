{config, ...}: {
  flake.nixosModules = config.flake.lib.importFilesToAttrs ./. [
    "common"
    "kde"
    "podman"
    "tailscale"
    "hyprland"
    "sway"
    "wayland-compositors"
  ];
}

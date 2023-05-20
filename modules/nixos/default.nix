{config, ...}: {
  flake.nixosModules = config.flake.lib.importFilesToAttrs ./. [
    "common"
    "docker"
    "gnome"
    "hyprland"
    "plasma5"
    "podman"
    "sway"
    "tailscale"
    "user-ayats"
    "user-soch"
    "warp"
    "wine"
  ];
}

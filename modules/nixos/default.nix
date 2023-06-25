{config, ...}: {
  flake.nixosModules = config.flake.lib.importFilesToAttrs ./. [
    "common"
    "docker"
    "fhs"
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

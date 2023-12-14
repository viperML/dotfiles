{config, ...}: {
  flake.nixosModules = config.flake.lib.importFilesToAttrs ./. [
    "common"
    "consul"
    "containerd"
    "docker"
    "gnome"
    "greetd"
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

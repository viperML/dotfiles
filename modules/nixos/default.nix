{ config, ... }: {
  flake.nixosModules = config.flake.lib.importFilesToAttrs ./. [
    "common"
    "consul"
    "containerd"
    "docker"
    "gnome"
    "greetd"
    "guix"
    "hyprland"
    "plasma5"
    "podman"
    "printing"
    "sway"
    "tailscale"
    "user-ayats"
    "user-soch"
    "warp"
    "wine"
    "yubikey"
  ];
}

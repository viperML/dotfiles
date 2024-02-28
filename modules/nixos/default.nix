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
    "tpm2"
    "user-ayats"
    "user-soch"
    "warp"
    "wine"
    "yubikey"
  ];
}

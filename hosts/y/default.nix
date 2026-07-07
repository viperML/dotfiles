import ../. [
  #-- Topology
  ./configuration.nix
  ./dell.nix
  ../../modules/nixos/es.nix
  ../../modules/nixos/tmpfs.nix
  ../../modules/nixos/tpm2
  ../../modules/nixos/users.nix

  #-- Environment
  # { services.displayManager.autoLogin.user = "ayats"; }
  # ../../modules/nixos/hyprland.nix
  ../../modules/nixos/plasma6.nix

  #-- Other
  ../../modules/nixos/firefox
  ../../modules/nixos/podman.nix
  ../../modules/nixos/silent-boot.nix
  ../../modules/nixos/singularity.nix
  # ../../modules/nixos/ssh-server.nix
  ./grafana.nix
]

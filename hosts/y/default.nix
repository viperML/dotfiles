import ../. [
  #-- Topology
  ./configuration.nix
  ./dell.nix
  ../../modules/nixos/es.nix
  ../../modules/nixos/tmpfs.nix
  ../../modules/nixos/tpm2
  ../../modules/nixos/users.nix

  #-- Environment
  { services.displayManager.autoLogin.user = "ayats"; }
  ../../modules/nixos/plasma6.nix

  #-- Other
  ../../modules/nixos/tailscale.nix
  ../../modules/nixos/podman.nix
  ../../modules/nixos/silent-boot.nix
  ./sourcebot.nix
]

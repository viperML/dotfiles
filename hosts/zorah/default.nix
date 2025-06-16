import ../. {
  modules = [
    #-- Topology
    ./configuration.nix
    ./novidia.nix
    ../../modules/nixos/printing.nix
    ../../modules/nixos/tmpfs.nix
    ../../modules/nixos/tpm2
    ../../modules/nixos/users.nix
    ../../modules/nixos/yubikey
    ../../modules/nixos/silent-boot.nix

    #-- Environment
    ../../modules/nixos/gnome.nix

    #-- Other
    ../../modules/nixos/tailscale.nix
    ../../modules/nixos/guix
    ../../modules/nixos/podman.nix
    ../../modules/nixos/ddc.nix
  ];
}

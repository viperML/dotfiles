import ../. {
  modules = [
    #-- Topology
    ./configuration.nix
    ../../modules/nixos/es.nix
    ../../modules/nixos/tmpfs.nix
    ../../modules/nixos/tpm2
    ../../modules/nixos/users.nix
    ../../modules/nixos/yubikey

    #-- Environment
    { services.displayManager.autoLogin.user = "ayats"; }
    # nixosModules.plasma6
    ../../modules/nixos/gnome.nix

    #-- Other
    ../../modules/nixos/tailscale.nix
    # ../../modules/nixos/printing.nix
    ../../modules/nixos/podman.nix
    # ../../modules/nixos/silent-boot.nix
  ];
}

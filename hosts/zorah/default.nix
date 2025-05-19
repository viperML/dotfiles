import ../. {
  modules = [
    #-- Topology
    ./configuration.nix
    ./novidia.nix
    ../../modules/nixos/printing.nix
    ../../modules/nixos/tmpfs.nix
    ../../modules/nixos/tpm2
    ../../modules/nixos/user-ayats.nix
    ../../modules/nixos/user-soch.nix
    ../../modules/nixos/yubikey
    ../../modules/nixos/silent-boot.nix

    #-- Environment
    # {services.displayManager.autoLogin.user = "ayats";}
    ../../modules/nixos/hyprland.nix
    {
      specialisation.gnome = {
        inheritParentConfig = true;
        configuration = {
          environment.etc."specialisation".text = "gnome";
          disabledModules = [
            ../../modules/nixos/hyprland.nix
          ];
          imports = [
            ../../modules/nixos/gnome.nix
          ];
        };
      };
    }

    #-- Other
    ../../modules/nixos/tailscale.nix
    ../../modules/nixos/guix
    ../../modules/nixos/podman.nix
    ../../modules/nixos/ddc.nix
  ];
}

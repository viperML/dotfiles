import ../. {
  modules = [

    ./configuration.nix
    ../../modules/nixos/tmpfs.nix
    ../../modules/nixos/tpm2
    ../../modules/nixos/user-ayats.nix
    ../../modules/nixos/user-soch.nix
    ../../modules/nixos/yubikey

    { services.displayManager.autoLogin.user = "ayats"; }
    ../../modules/nixos/hyprland.nix

    ../../modules/nixos/tailscale.nix

    ../../modules/nixos/podman.nix
    ../../modules/nixos/silent-boot.nix
  ];
}

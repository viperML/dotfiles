{ config, pkgs, ... }:
{
  services.displayManager.gdm.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  environment.systemPackages = with pkgs; [
    # vanilla-dmz
    # wofi
    # wdisplays
    # seahorse
    # xdg-utils
    # libsecret
    # nwg-displays
    # brightnessctl
    kitty
    wofi

    kdePackages.kwallet
    kdePackages.kwallet-pam
    kdePackages.kwalletmanager
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.kdePackages.kwallet
    ];
  };

  security.pam.services = {
    login.kwallet = {
      enable = true;
      package = pkgs.kdePackages.kwallet-pam;
    };
  };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    # XCURSOR_THEME = "DMZ-White";
    # XCURSOR_SIZE = "24";
  };

  # services.gnome.gnome-keyring.enable = true;
  services.gnome.at-spi2-core.enable = true;

  maid.sharedModules = [
    ../maid/hyprland
  ];
}

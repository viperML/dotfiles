{ config, pkgs, ... }:
{
  services.xserver = {
    displayManager.gdm.enable = true;
  };

  programs.hyprland = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    vanilla-dmz
    wofi
    wdisplays
    seahorse
    xdg-utils
    libsecret
    nwg-displays
    brightnessctl
  ];

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    # XCURSOR_THEME = "DMZ-White";
    # XCURSOR_SIZE = "24";
  };

  services.gnome.gnome-keyring.enable = true;
  services.gnome.at-spi2-core.enable = true;
}

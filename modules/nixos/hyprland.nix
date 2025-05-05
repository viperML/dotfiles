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
  ];

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    # XCURSOR_THEME = "DMZ-White";
    # XCURSOR_SIZE = "24";
  };
}

{ config, pkgs, ... }:
{
  services.displayManager = {
    gdm.enable = true;
    defaultSession = "hyprland-uwsm";
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vanilla-dmz
    # wdisplays
    # xdg-utils
    libsecret
    nwg-displays
    # brightnessctl
    kitty
  ];

  xdg.portal = {
    enable = true;
  };

  environment.sessionVariables = rec {
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    XCURSOR_THEME = "DMZ-White";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_THEME = XCURSOR_THEME;
    HYPRCURSOR_SIZE = XCURSOR_SIZE;
  };

  services.gnome.at-spi2-core.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = false;
  programs.ssh.startAgent = true;
  services.tuned = {
    enable = true;
  };

  programs.seahorse.enable = true;

  maid.sharedModules = [
    ../maid/hyprland
  ];

}

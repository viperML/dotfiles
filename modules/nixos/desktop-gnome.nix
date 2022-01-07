{ config, pkgs, lib, ... }:

{
  services.xserver = {
    displayManager.gdm = {
      enable = true;
      wayland = true;
      nvidiaWayland = lib.mkIf (config.services.xserver.videoDrivers == [ "nvidia" ]) true;
    };
    desktopManager.gnome.enable = true;
  };

  programs.xwayland.enable = true;
  hardware.opengl.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome.cheese
    gnome-photos
    # gnome.gnome-music
    # pkgs.gnome.gnome-terminal
    gnome.gedit
    epiphany
    # evince
    # gnome.gnome-characters
    gnome.totem
    # gnome.tali
    # gnome.iagno
    # gnome.hitori
    # gnome.atomix
    gnome-tour
    gnome.geary
  ];

  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnome.gnome-shell-extensions
    gnomeExtensions.blur-my-shell
    gnomeExtensions.pop-shell
  ];

}

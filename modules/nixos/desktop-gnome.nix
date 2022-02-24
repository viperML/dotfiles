{
  config,
  pkgs,
  lib,
  ...
}: let
  my-extensions = with pkgs.gnomeExtensions; [
    appindicator
    blur-my-shell
    pop-shell
    # night-theme-switcher
    dash-to-panel
    sound-output-device-chooser
    system-monitor
    syncthing-indicator
    caffeine
    just-perfection
  ];
in {
  services.xserver = {
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    displayManager.defaultSession = "gnome-xorg";
    displayManager.autoLogin.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    gnome-photos
    gnome-tour

    gnome.gnome-characters
    gnome.cheese
    gnome.gnome-terminal
    gnome.gedit
    gnome.totem
    gnome.geary
    gnome.gnome-screenshot
    gnome.eog
  ];

  environment.systemPackages = with pkgs;
    [
      adw-gtk3
      gnome.gnome-tweaks
      gnome.gnome-shell-extensions
      gnome.dconf-editor
      libsForQt5.gwenview
    ]
    ++ my-extensions;

  home-manager.sharedModules = [
    {
      programs.firefox.enableGnomeExtensions = true;
    }
  ];
}

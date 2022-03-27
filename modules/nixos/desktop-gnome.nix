{
  config,
  pkgs,
  lib,
  packages,
  ...
}: let
  my-extensions = with pkgs.gnomeExtensions; [
    appindicator
    blur-my-shell
    pop-shell
    dash-to-panel
    sound-output-device-chooser
    system-monitor
    syncthing-indicator
    caffeine
    just-perfection

    forge
  ];
in {
  services.xserver = {
    enable = true;
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
      packages.self.adw-gtk3
      gnome.gnome-tweaks
      gnome.gnome-shell-extensions
      gnome.dconf-editor
      libsForQt5.gwenview

      rose-pine-gtk-theme
    ]
    ++ my-extensions;

  programs = {
    xwayland.enable = true;
  };
}

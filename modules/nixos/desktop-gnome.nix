{
  config,
  pkgs,
  lib,
  ...
}:
let
  my-extensions = with pkgs.gnomeExtensions; [
    pkgs.gnome.gnome-shell-extensions
    appindicator
    blur-my-shell
    pop-shell
    night-theme-switcher
    dash-to-panel
    sound-output-device-chooser
  ];
in {
  services.xserver = {
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = false;
    };
    displayManager.defaultSession = "gnome-xorg";
    displayManager.autoLogin.enable = true;
  };

  environment.gnome.excludePackages =
    with pkgs; [
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

  environment.systemPackages =
    with pkgs;
    [
      gnome.dconf-editor
      gnome.gnome-tweaks
      adw-gtk3
    ]
    ++ my-extensions;
}

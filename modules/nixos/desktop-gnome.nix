{
  config,
  pkgs,
  lib,
  ...
}:
let
  my-extensions = with pkgs.gnomeExtensions; [
    appindicator
    blur-my-shell
    pop-shell
    # night-theme-switcher
    dash-to-panel
    sound-output-device-chooser
    system-monitor
    logo-menu
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
      gnome.gnome-terminal
      gnome.gedit
      epiphany
      # evince
      gnome.gnome-characters
      gnome.totem
      gnome-tour
      gnome.geary
      gnome.gnome-screenshot
      gnome.eog
    ];

  environment.systemPackages =
    with pkgs;
    [
      gnome.gnome-tweaks
      gnome.gnome-shell-extensions
      gnome.dconf-editor
      adw-gtk3
      libsForQt5.gwenview
    ]
    ++ my-extensions;

  # Hide ZFS subvolumes on gvfs/nautilus
  services.udev.extraRules = ''
    KERNEL=="zd*", ENV{UDISKS_IGNORE}="1"
  '';
}

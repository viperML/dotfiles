{
  pkgs,
  lib,
  packages,
  ...
}: {
  system.nixos.label = lib.mkAfter "gnome";
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
    };
    # displayManager.autoLogin.enable = true;
    desktopManager.xterm.enable = false;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    # QT_QPA_PLATFORM = "wayland;xcb";
  };

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    gnome-photos
    gnome-tour

    gnome.gnome-characters
    gnome.cheese
    gnome.gedit
    gnome.totem
    gnome.geary
    gnome.gnome-screenshot
    gnome.eog
    orca
    baobab
    gnome.gnome-maps
    gnome.gnome-weather
    gnome-connections
    gnome.gnome-logs
    gnome.yelp
    gnome.gnome-calculator
    evince
    gnome.gnome-disk-utility
    gnome.gnome-contacts
    gnome-text-editor
    gnome.gnome-clocks
  ];

  environment.systemPackages = with pkgs; [
    packages.self.adw-gtk3
    packages.self.papirus-icon-theme
    pkgs.vanilla-dmz
    gnome.gnome-tweaks
    gnome.gnome-shell-extensions
    gnome.dconf-editor
    libsForQt5.qtwayland
    libsForQt5.gwenview
    pkgs.gnomeExtensions.appindicator
  ];
}

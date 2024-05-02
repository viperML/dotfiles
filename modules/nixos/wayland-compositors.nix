{pkgs, ...}: {
  imports = [./fcitx5.nix];

  services.xserver = {
    enable = true;
    displayManager = {sddm.enable = true;};
  };

  services.gnome.gnome-keyring.enable = true;

  services.blueman.enable = true;

  environment.sessionVariables = {
    # NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    # https://github.com/NixOS/nixpkgs/commit/ebde08adf37932ff59c27b5935840aa733965bdb
    GTK_USE_PORTAL = "1";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  environment.systemPackages = with pkgs; [
    gnome.seahorse
    haruna

    libsForQt5.dolphin
    libsForQt5.ark
    libsForQt5.gwenview
    libsForQt5.dolphin-plugins
    libsForQt5.ffmpegthumbs
    libsForQt5.kdegraphics-thumbnailers
    libsForQt5.kio
    libsForQt5.kio-extras
    libsForQt5.qtwayland
    libsForQt5.okular
  ];

  services.gnome.at-spi2-core.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}

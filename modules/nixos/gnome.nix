{pkgs, ...}: {
  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome = {
      enable = true;
    };
  };

  environment.systemPackages = [
    pkgs.adw-gtk3
    pkgs.gnome-tweaks
    pkgs.wl-clipboard-rs
    pkgs.vanilla-dmz
  ];

  environment.gnome.excludePackages = with pkgs; [
    totem
    gnome-maps
    gnome-logs
    simple-scan
    gnome-calculator
    epiphany
    gnome-music
    gnome-tour
    gnome-contacts
    gnome-disk-utility
  ];

  programs.geary.enable = false;

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    SSH_ASKPASS_REQUIRE = "prefer";
    NIXOS_OZONE_WL = "1";
    XCURSOR_THEME = "DMZ-White";
    XCURSOR_SIZE = "24";
  };

  # programs.git.config = {
  #   credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
  # };
}

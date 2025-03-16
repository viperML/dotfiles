{ pkgs, ... }:
{
  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverridePackages = with pkgs; [
        mutter
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    adw-gtk3
    gnome-tweaks
    wl-clipboard
    vanilla-dmz
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-panel
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

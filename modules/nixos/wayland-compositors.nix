{ pkgs, ... }:
{
  imports = [
    ./auto-pp.nix
  ];

  services.displayManager = {
    gdm.enable = true;
  };

  programs.uwsm.enable = true;

  environment.systemPackages = with pkgs; [
    vanilla-dmz
    libsecret
    nwg-displays
    kitty
    # networkmanagerapplet
    wl-clipboard
    kdePackages.dolphin
    kdePackages.baloo-widgets # baloo information in Dolphin
    kdePackages.dolphin-plugins
    kdePackages.ark
    kdePackages.okular
    kdePackages.gwenview
    kdePackages.kservice
    adw-gtk3
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
  services.accounts-daemon.enable = true;
  systemd.services.accounts-daemon.serviceConfig.PrivateTmp = false;
  services.udisks2.enable = true;
  programs.ssh.startAgent = true;
  services.tuned = {
    enable = true;
  };
  services.upower.enable = true;

  programs.seahorse.enable = true;

  qt = {
    enable = true;
    style = "breeze";
  };

  environment.etc."xdg/menus/applications.menu".source =
    pkgs.runCommandLocal "plasma-applications" { }
      ''
        cp -v ${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu $out
      '';
}

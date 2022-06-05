{
  config,
  pkgs,
  lib,
  self,
  inputs,
  packages,
  ...
}: {
  time.timeZone = "Europe/Madrid";

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    journald.extraConfig = ''
      Storage=volatile
    '';

    ananicy.enable = true;
    thermald.enable = true;
    udev.packages = [pkgs.android-udev-rules];
  };

  # replaced by pipewire
  hardware.pulseaudio.enable = false;

  environment.systemPackages = with pkgs; [
    # CLI to be found by default in other distros
    file
    xsel
    pciutils
    wget
    lsof
    usbutils
    # Icons
    # (packages.self.papirus-icon-theme.override {color = "adwaita";})
    (packages.self.colloid.override {
      theme = "yellow";
    })
  ];

  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
  };

  nix.gc = {
    automatic = true;
    dates = "04:00";
    # options = "--delete-older-than 7d";
    options = "-d";
  };

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  systemd.services."getty@tty7".enable = false;
  systemd.services."autovt@tty7".enable = false;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=15s
  '';
}

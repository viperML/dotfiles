{
  config,
  pkgs,
  lib,
  self,
  inputs,
  packages,
  ...
}: (lib.mkMerge [
  {
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
      flatpak.enable = true;
    };

    # replaced by pipewire
    hardware.pulseaudio.enable = false;

    environment.systemPackages = with pkgs; [
      # CLI to be found by default in other distros
      file
      xsel
      pciutils
      wget
      libarchive
      lsof
      usbutils
      # Icons
      (packages.self.g-papirus-icon-theme.override {color = "palebrown";})
    ];

    xdg.portal = {
      enable = true;
      gtkUsePortal = true;
    };
  }
  (lib.mkIf config.services.xserver.displayManager.gdm.enable {
    # Fixes GDM autologin in Wayland
    # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;
  })
])

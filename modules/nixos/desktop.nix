{
  config,
  pkgs,
  lib,
  ...
}: {
  services = {
    xserver = {
      enable = true;
      displayManager = {
        # Set the autologin user, if there's only 1 normal user
        autoLogin = let
          my-users = builtins.attrNames (
            pkgs.lib.filterAttrs (name: value: value.isNormalUser)
            config.users.users
          );
        in {
          user = lib.mkIf (builtins.length my-users == 1) config.users.users."${builtins.head my-users}".name;
        };
      };
    };

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

  # Fixes GDM autologin in Wayland
  # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # replaced by pipewire
  hardware.pulseaudio.enable = false;

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      # Base cli
      file
      xsel
      nmap
      pciutils
      wget
      lsof
      pwgen
      usbutils
      lshw
      appimage-run
      hwloc
      libarchive
      ;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "04:00";
      options = "--delete-older-than 14d";
    };
  };

  xdg.portal.enable = true;
}

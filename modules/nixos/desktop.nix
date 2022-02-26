{
  config,
  pkgs,
  lib,
  ...
}: (lib.mkMerge [
  {
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

    # replaced by pipewire
    hardware.pulseaudio.enable = false;

    environment.systemPackages = with pkgs; [
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
    ];

    nix = {
      gc = {
        automatic = true;
        dates = "04:00";
        # options = "--delete-older-than 7d";
        options = "-d";
      };
    };

    xdg.portal.enable = true;
  }
  (lib.mkIf config.services.xserver.displayManager.gdm.enable {
    # Fixes GDM autologin in Wayland
    # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;
  })
])

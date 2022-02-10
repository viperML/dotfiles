{ config
, pkgs
, lib
, ...
}:
{
  services = {
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = false;
        sddm.enable = true;
        gdm = {
          enable = false;
          wayland = true;
        };

        # Set the autologin user, if there's only 1 normal user
        autoLogin =
          let
            my-users = builtins.attrNames (
              pkgs.lib.filterAttrs (name: value: value.isNormalUser == true)
              config.users.users
            );
          in
            {
              user = lib.mkIf (builtins.length my-users == 1) (config.users.users."${builtins.head my-users}".name);
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
    udev.packages = with pkgs; [ android-udev-rules ];
    flatpak.enable = true;
  };

  environment.variables.GTK_USE_PORTAL = "1";
  environment.sessionVariables.GTK_USE_PORTAL = "1";

  # Fixes GDM autologin in Wayland
  # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  hardware.pulseaudio.enable = false;
  # replaced by pipewire

  environment.systemPackages =
    with pkgs;
    [
      # Base cli
      xsel
      nmap
      pciutils
      wget
      lsof
      pwgen
      usbutils
      lshw
      appimage-run

      # Base
      masterpdfeditor4
      onlyoffice-bin
      mpv
      (g-papirus-icon-theme.override { color = "palebrown"; })
      qbittorrent
      android-tools
      tor-browser-bundle-bin

      # Misc
      ahoviewer
      krita-beta
      obs-studio
      obsidian
      inkscape
    ];

  nix = {
    gc = {
      automatic = true;
      dates = "04:00";
      options = "--delete-older-than 14d";
    };
  };

  xdg.portal.enable = true;
}

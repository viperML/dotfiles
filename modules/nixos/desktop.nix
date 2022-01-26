{ config, pkgs, lib, ... }:

{
  services = {
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = false;
        sddm = {
          enable = false;
        };
        gdm = {
          enable = true;
          wayland = true;
          nvidiaWayland = lib.mkIf (builtins.any (v: v == "nvidia") config.services.xserver.videoDrivers) true;
        };

        # If system only has 1 normal user, enable autologin for them
        autoLogin =
          let
            my-users = builtins.attrNames (pkgs.lib.filterAttrs (name: value: value.isNormalUser == true) config.users.users);
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

    gnome.gnome-keyring.enable = true;
    ananicy.enable = true;
    thermald.enable = true;
    udev.packages = with pkgs; [ android-udev-rules ];
  };

  # Fixes GDM autologin in Wayland
  # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=15s
    DefaultTimeoutStopSec=15s
  '';

  hardware.pulseaudio.enable = false; # replaces pipewire

  environment.systemPackages = with pkgs; [
    # Base cli
    file
    xsel
    nmap
    pciutils
    wget
    lsof
    pwgen

    # Base
    brave
    google-chrome
    flameshot
    masterpdfeditor4
    onlyoffice-bin
    word-for-poor-people
    excel-for-poor-people
    mpv
    (papirus-icon-theme.override { color = "palebrown"; })
    spotify-for-poor-people
    qbittorrent
    gnome.seahorse
    android-tools

    # Misc
    ahoviewer
    krita-beta
    obs-studio
    obsidian
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "04:00";
      options = "--delete-older-than 14d";
    };
  };
}

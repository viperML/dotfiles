{ config, pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      desktopManager.plasma5.enable = true;
      desktopManager.plasma5.runUsingSystemd = true;
      displayManager = {
        sddm.enable = true;
        sddm.autoLogin.relogin = true;
        autoLogin.user = "${config.users.users.mainUser.name}";
        autoLogin.enable = true;
      };
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    gnome = {
      gnome-keyring.enable = true;
    };

    journald.extraConfig = ''
      Storage=volatile
    '';

    ananicy.enable = true;
    thermald.enable = true;

    udev.packages = with pkgs; [ android-udev-rules ];
  };

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=15s
    DefaultTimeoutStopSec=15s
  '';


  hardware.pulseaudio.enable = false; # replaces pipewire


  security = {
    sudo = {
      extraConfig = ''
        Defaults pwfeedback
        Defaults env_keep += "EDITOR PATH"
        Defaults timestamp_timeout=300
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    # Base cli
    file
    xsel
    nmap
    pciutils

    # Base
    brave
    ungoogled-chromium
    flameshot
    masterpdfeditor4
    onlyoffice-bin
    word-for-poor-people
    excel-for-poor-people
    thunderbird
    birdtray
    mpv
    (papirus-icon-theme.override { color = "yaru"; })
    spotify-for-poor-people
    qbittorrent

    # KDE specific
    gnome.seahorse
    libsForQt5.bismuth
    libsForQt5.plasma-pa
    libsForQt5.qtstyleplugin-kvantum
    lightly
    sierrabreezeenhanced
    libsForQt5.ark
    libsForQt5.ffmpegthumbs
    libsForQt5.kdegraphics-thumbnailers
    libsForQt5.filelight
    libsForQt5.gwenview
    libsForQt5.kwalletmanager
    caffeine-ng

    # Misc
    ahoviewer
    krita-beta
    obs-studio
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "04:00";
      options = "--delete-older-than 14d";
    };
  };
}

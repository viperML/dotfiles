{ config, pkgs, lib, inputs, ... }:

{
  system.stateVersion = "21.11";
  system.configurationRevision = (if inputs.self ? rev then inputs.self.rev else null);
  time.timeZone = "Europe/Madrid";

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

  hardware.pulseaudio.enable = false; # replaces pipewire

  users.mutableUsers = true; # change passwords of users

  users.users.mainUser = {
    name = "ayats";
    home = "/home/ayats";
    description = "Fernando Ayats";
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "uucp" "systemd-journal" "networkmanager" ];
    passwordFile = config.sops.secrets."initialPassword/ayats".path;
  };


  security = {
    sudo = {
      wheelNeedsPassword = false;
      extraConfig = ''
        Defaults pwfeedback
        Defaults env_keep += "EDITOR PATH"
        Defaults timestamp_timeout=300
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    # jetbrains-mono
    # vscode-fhs
    brave
    file
    flameshot
    gnome.seahorse
    # latte-dock
    libsForQt5.bismuth
    libsForQt5.plasma-pa
    libsForQt5.qtstyleplugin-kvantum
    lightly
    masterpdfeditor4
    mpv
    (papirus-icon-theme.override { color = "yaru"; })
    sierrabreezeenhanced
    spotify-for-poor-people
    thunderbird
    word-for-poor-people
    excel-for-poor-people
    xsel
    onlyoffice-bin
    libsForQt5.ark
    libsForQt5.ffmpegthumbs
    libsForQt5.filelight
    libsForQt5.gwenview
    libsForQt5.kwalletmanager
    libsForQt5.kdegraphics-thumbnailers
    ahoviewer
    krita-beta
    obs-studio
    nmap
    qbittorrent
    birdtray
    caffeine-ng

  ];


  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixUnstable;

    extraOptions = ''${builtins.readFile ../nix.conf}'';

    gc = {
      automatic = true;
      dates = "weekly";
    };

    # (from flake-utils-plus)
    # Set the NIX_PATH from the flake inputs
    # So nix-channel is not needed anymore
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
    linkInputs = true;
  };

}

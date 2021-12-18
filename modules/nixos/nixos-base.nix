{ config, pkgs, lib, ... }:

{
  time.timeZone = "Europe/Madrid";

  services = {
    xserver = {
      enable = true;
      desktopManager.plasma5.enable = true;
      displayManager = {
        sddm.enable = true;
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
  };

  hardware.pulseaudio.enable = false; # replaces pipewire

  users.users.mainUser = {
    name = "ayats";
    description = "Fernando Ayats";
    home = "/home/ayats";
    isNormalUser = true;
    initialPassword = "1234";
    extraGroups = [ "wheel" "audio" "video" "uucp" "systemd-journal" "networkmanager" ];
  };

  security.sudo = {
    wheelNeedsPassword = false;
  };

  environment.systemPackages = with pkgs; [
    brave
    latte-dock
    libsForQt5.bismuth
    libsForQt5.plasma-pa
    # vscode-fhs
    papirus-icon-theme
    # jetbrains-mono
    flameshot
    gnome.seahorse
    file
    xsel

    element-for-poor-people
    sierrabreezeenhanced
    lightly
    thunderbird
    masterpdfeditor4
    spotify-for-poor-people
    word-for-poor-people
    libsForQt5.qtstyleplugin-kvantum
    mpv
  ];

  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  # system.stateVersion = "21.11"; # Did you read the comment?
  nix = {
    package = pkgs.nixFlakes;

    extraOptions = ''${builtins.readFile ../nix.conf}'';

    # (from flake-utils-plus)
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
    linkInputs = true;
  };

}

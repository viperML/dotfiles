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
    # jetbrains-mono
    # vscode-fhs
    brave
    element-for-poor-people
    file
    flameshot
    gnome.seahorse
    latte-dock
    libsForQt5.bismuth
    libsForQt5.plasma-pa
    libsForQt5.qtstyleplugin-kvantum
    lightly
    masterpdfeditor4
    mpv
    papirus-icon-theme
    sierrabreezeenhanced
    spotify-for-poor-people
    thunderbird
    word-for-poor-people
    xsel
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

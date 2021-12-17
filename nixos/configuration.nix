{ config, pkgs, ... }:

{
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  services = {
    xserver = {
      enable = true;
      desktopManager.plasma5.enable = true;
      displayManager = {
        sddm.enable = true;
        autoLogin.user = "ayats";
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

  # Configure keymap in X11
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.users.ayats = {
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
  ];

  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.variables = {
    FLAKE = "/home/ayats/.dotfiles";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # system.stateVersion = "21.11"; # Did you read the comment?

}

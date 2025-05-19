{
  config,
  pkgs,
  lib,
  # inputs',
  ...
}:
{
  imports = [ ./swap.nix ];

  # broken
  services.envfs.enable = lib.mkForce false;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 1w --keep 3";
    # package = inputs'.nh.packages.default;
  };

  nix = {
    # package = self'.packages.nix;
    daemonCPUSchedPolicy = "idle";
    settings = lib.mkMerge [
      (import ../../misc/nix-conf.nix)
      (import ../../misc/nix-conf-privileged.nix)
      { "flake-registry" = "/etc/nix/registry.json"; }
    ];
    channel.enable = false;
    nixPath = [ "nixpkgs=/etc/nixpkgs" ];
    # FIXME: Should use a `path` entry using the narHash from npins
    registry.nixpkgs.to = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = (import ../../npins).nixpkgs.revision;
    };
  };

  environment.etc.nixpkgs.source = pkgs.path;

  users.mutableUsers = false;

  services.udev.packages = with pkgs; [ android-udev-rules ];

  environment.defaultPackages = [ ];

  environment.sessionVariables = {
    EDITOR = "nvim";
    # NIXPKGS_CONFIG = lib.mkForce "";
  };

  environment.systemPackages = with pkgs; [
    # CLI base tools
    usbutils
    pciutils
    file
    pax-utils
    efibootmgr
    e2fsprogs.bin
    android-tools

    # Global dev, not part of env
    # self'.packages.env
    env-viper
    nixpkgs-fmt
    nix-output-monitor
    shellcheck
    # inputs'.tree-sitter.packages.tree-sitter-cat
    sops
    age
    aichat

    # GUI
    warp
    # google-chrome
    # self'.packages.google-chrome
    # self'.packages.microsoft-edge
    brave
    # ptyxis
    zellij
    # self'.packages.alacritty
    # self'.packages.wezterm
    vscode
    # self'.packages.ghostty
    alacritty
    # self'.packages.tmux
    libcgroup
    wl-color-picker
    # self'.packages.code-cursor

    maid
  ];

  # i18n = let
  #   # defaultLocale = "en_US.UTF-8";
  #   inherit (config.i18n) defaultLocale; # set in nix-common
  #   es = "es_ES.UTF-8";
  # in {
  #   inherit defaultLocale;
  #   extraLocaleSettings = {
  #     LANG = defaultLocale;
  #     LC_COLLATE = defaultLocale;
  #     LC_CTYPE = defaultLocale;
  #     LC_MESSAGES = defaultLocale;
  #
  #     LC_ADDRESS = es;
  #     LC_IDENTIFICATION = es;
  #     LC_MEASUREMENT = es;
  #     LC_MONETARY = es;
  #     LC_NAME = es;
  #     LC_NUMERIC = es;
  #     LC_PAPER = es;
  #     LC_TELEPHONE = es;
  #     LC_TIME = es;
  #   };
  # };

  systemd =
    let
      extraConfig = ''
        DefaultTimeoutStartSec=15s
        DefaultTimeoutStopSec=15s
        DefaultTimeoutAbortSec=15s
        DefaultDeviceTimeoutSec=15s
      '';
    in
    {
      inherit extraConfig;
      user = { inherit extraConfig; };
      services."getty@tty1".enable = false;
      services."autovt@tty1".enable = false;
      services."getty@tty7".enable = false;
      services."autovt@tty7".enable = false;
      services."kmsconvt@tty1".enable = false;
      services."kmsconvt@tty7".enable = false;
    };

  programs.ssh = {
    startAgent = true;
    agentTimeout = "8h";
  };

  fonts.packages = [
    pkgs.roboto
    # self'.packages.iosevka
    pkgs.iosevka-normal
    # (pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    pkgs.nerd-fonts.symbols-only
    pkgs.corefonts
    config.services.desktopManager.plasma6.notoPackage
  ];

  time.timeZone = "Europe/Madrid";

  services.xserver = {
    enable = true;
    xkb = {
      layout = "es";
      options = "compose:rctrl";
    };
    excludePackages = [ pkgs.xterm ];
  };

  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
    mouse.accelSpeed = "0.0";
    mouse.middleEmulation = false;
  };

  console.useXkbConfig = true;

  services.kmscon = {
    # enable = true;
    extraConfig = ''
      font-size=14
      xkb-layout=${config.services.xserver.layout}
    '';
    hwRender = true;
    fonts = [
      {
        name = "iosevka-normal Semibold";
        package = pkgs.iosevka-normal;
      }
      {
        name = "Symbols Nerd Font";
        package = pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; };
      }
    ];
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  hardware.steam-hardware.enable = true;
}

{
  config,
  pkgs,
  lib,
  # inputs',
  ...
}:
{
  imports = [
    ./swap.nix
    ./wsl.nix
  ];

  # broken
  services.envfs.enable = lib.mkForce false;

  # Sane default to at least have a static hostId
  networking.hostId = "deadbeef";

  users.mutableUsers = false;

  services.udev.packages = with pkgs; [ android-udev-rules ];

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
  environment.systemPackages = with pkgs; [
    # CLI base tools
    usbutils
    pciutils
    efibootmgr
    android-tools

    # GUI
    warp
    zellij
    vscode
    ghostty
    libcgroup
    wl-color-picker
  ];

  systemd =
    # let
    #   extraConfig = ''
    #     DefaultTimeoutStartSec=15s
    #     DefaultTimeoutStopSec=15s
    #     DefaultTimeoutAbortSec=15s
    #     DefaultDeviceTimeoutSec=15s
    #   '';
    # in
    {
      services."getty@tty1".enable = false;
      services."autovt@tty1".enable = false;
      services."getty@tty7".enable = false;
      services."autovt@tty7".enable = false;
      services."kmsconvt@tty1".enable = false;
      services."kmsconvt@tty7".enable = false;
    };

  # programs.ssh = {
  #   startAgent = true;
  #   agentTimeout = "8h";
  # };

  fonts.packages = [
    # pkgs.roboto
    pkgs.inter
    # self'.packages.iosevka
    pkgs.iosevka-normal
    # (pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    pkgs.nerd-fonts.symbols-only
    pkgs.corefonts
    # config.services.desktopManager.plasma6.notoPackage
  ];

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

  hardware.steam-hardware.enable = true;

  services.hardware.bolt.enable = true;
}

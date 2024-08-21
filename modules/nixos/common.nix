{
  config,
  pkgs,
  lib,
  self',
  inputs',
  ...
}: {
  imports = [./swap.nix];

  # broken
  services.envfs.enable = lib.mkForce false;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 1w --keep 3";
    package = inputs'.nh.packages.default;
  };

  nix = {
    daemonCPUSchedPolicy = "idle";
    settings =
      import ../../misc/nix-conf.nix
      // import ../../misc/nix-conf-privileged.nix;
  };

  users.mutableUsers = false;

  services.udev.packages = with pkgs; [android-udev-rules];

  environment.defaultPackages = [];
  environment.systemPackages = with pkgs; [
    usbutils
    pciutils
    vim
    file
    pax-utils
    efibootmgr
    e2fsprogs.bin

    warp

    android-tools
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

  systemd = let
    extraConfig = ''
      DefaultTimeoutStartSec=15s
      DefaultTimeoutStopSec=15s
      DefaultTimeoutAbortSec=15s
      DefaultDeviceTimeoutSec=15s
    '';
  in {
    inherit extraConfig;
    user = {inherit extraConfig;};
    services."getty@tty1".enable = false;
    services."autovt@tty1".enable = false;
    services."getty@tty7".enable = false;
    services."autovt@tty7".enable = false;
    services."kmsconvt@tty1".enable = false;
    services."kmsconvt@tty7".enable = false;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "old";
    verbose = true;
    sharedModules = [
      {
        home.stateVersion = lib.mkForce config.system.stateVersion;
        nix.package = lib.mkForce config.nix.package;
      }
    ];
  };

  programs.ssh = {
    startAgent = true;
    agentTimeout = "8h";
  };

  fonts.packages = [
    pkgs.roboto
    self'.packages.iosevka
    (pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
  ];

  time.timeZone = "Europe/Madrid";

  services.xserver = {
    enable = true;
    xkb = {
      layout = "es";
      options = "compose:rctrl";
    };
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
        package = self'.packages.iosevka;
      }
      {
        name = "Symbols Nerd Font";
        package = (pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];});
      }
    ];
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  hardware.steam-hardware.enable = true;
}

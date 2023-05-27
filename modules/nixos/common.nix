{
  config,
  pkgs,
  self,
  lib,
  packages,
  ...
}: {
  nh = {
    enable = true;
    clean.enable = true;
  };

  nix = {
    daemonCPUSchedPolicy = "idle";
    settings = import ../../misc/nix-conf.nix // import ../../misc/nix-conf-privileged.nix;
  };

  users.mutableUsers = false;

  services.udev.packages = with pkgs; [
    android-udev-rules
  ];

  environment.defaultPackages = [];
  environment.systemPackages = with pkgs; [
    usbutils
    pciutils
    vim
    file
    pax-utils

    packages.self.git
    packages.nh.default

    android-tools
  ];

  i18n = let
    defaultLocale = "en_US.UTF-8";
    es = "es_ES.UTF-8";
  in {
    inherit defaultLocale;
    extraLocaleSettings = {
      LANG = defaultLocale;
      LC_COLLATE = defaultLocale;
      LC_CTYPE = defaultLocale;
      LC_MESSAGES = defaultLocale;

      LC_ADDRESS = es;
      LC_IDENTIFICATION = es;
      LC_MEASUREMENT = es;
      LC_MONETARY = es;
      LC_NAME = es;
      LC_NUMERIC = es;
      LC_PAPER = es;
      LC_TELEPHONE = es;
      LC_TIME = es;
    };
  };

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

  fonts.fonts = [
    pkgs.roboto
    packages.self.iosevka
  ];

  time.timeZone = "Europe/Madrid";
}

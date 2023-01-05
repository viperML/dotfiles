{
  config,
  pkgs,
  self,
  packages,
  ...
}: {
  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    journald.extraConfig = ''
      Storage=volatile
    '';

    thermald.enable = true;
    udev.packages = [pkgs.android-udev-rules];
  };

  # replaced by pipewire
  hardware.pulseaudio.enable = false;

  environment.systemPackages = with pkgs; ([
      pkgs.gnome.seahorse
      android-tools
    ]
    ++ (
      if config.viper.isWayland
      then [
        wl-clipboard
      ]
      else [
        xclip
      ]
    ));

  xdg.portal = {
    enable = true;
  };

  nix.gc = {
    automatic = true;
    dates = "04:00";
    options = "--delete-older-than 5d";
    # options = "-d";
  };

  systemd = let
    extraConfig = ''
      DefaultTimeoutStopSec=15s
    '';
  in {
    inherit extraConfig;
    user = {inherit extraConfig;};
    services."getty@tty1".enable = false;
    services."autovt@tty1".enable = false;
    services."getty@tty7".enable = false;
    services."autovt@tty7".enable = false;

    # FIXME
    # services."nix-gc-generations" = {
    #   serviceConfig.ExecStart = (pkgs.writers.writePython3 "gc_generations" {} (builtins.readFile "${self}/bin/gc_generations.py")).outPath;
    #   environment = {
    #     ESP = config.boot.loader.efi.efiSysMountPoint;
    #   };
    #   wantedBy = ["nix-gc.service"];
    #   after = ["nix-gc.service"];
    # };

    services."ModemManager".enable = false;
  };

  services.gnome.gnome-keyring.enable = true;

  programs.ssh = {
    startAgent = true;
    agentTimeout = "8h";
    enableAskPassword = false;
  };

  fonts = {
    fonts = with pkgs; [
      packages.self.corefonts
      noto-fonts
      noto-fonts-extra
      noto-fonts-emoji
      noto-fonts-cjk
      liberation_ttf
      roboto

      packages.self.iosevka
    ];
  };
}

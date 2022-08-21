{
  config,
  pkgs,
  lib,
  self,
  inputs,
  packages,
  ...
}: let
  env = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };
in {
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

  environment.systemPackages = with pkgs; [
    pkgs.gnome.seahorse
    android-tools
    packages.self.nh
  ];

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

    services."gc-generations" = {
      serviceConfig.ExecStart = (pkgs.writers.writePython3 "gc_generations" {} (builtins.readFile "${self}/bin/gc_generations.py")).outPath;
      environment = {
        ESP = config.boot.loader.efi.efiSysMountPoint;
      };
      wantedBy = ["nix-gc.service"];
      after = ["nix-gc.service"];
    };

    services."ModemManager".enable = false;
  };

  services.gnome.gnome-keyring.enable = true;
  programs.ssh.startAgent = true;
  programs.ssh.agentTimeout = "8h";

  environment.variables = env;
  environment.sessionVariables = env;
}

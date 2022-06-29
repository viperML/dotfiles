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

    ananicy.enable = true;
    thermald.enable = true;
    udev.packages = [pkgs.android-udev-rules];
  };

  # replaced by pipewire
  hardware.pulseaudio.enable = false;

  environment.systemPackages = with pkgs; [
    # CLI to be found by default in other distros
    file
    xsel
    pciutils
    lsof
    usbutils
    # Icons
    # (packages.self.papirus-icon-theme.override {color = "adwaita";})
    (packages.self.colloid.override {
      theme = "yellow";
    })
    pkgs.gnome.seahorse
  ];

  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
  };

  nix.gc = {
    automatic = true;
    dates = "04:00";
    # options = "--delete-older-than 7d";
    options = "-d";
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
  };

  services.gnome.gnome-keyring.enable = true;
  programs.ssh.startAgent = true;
  programs.ssh.agentTimeout = "3h";

  environment.variables = env;
  environment.sessionVariables = env;
}

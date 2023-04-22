{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./wayland-compositors.nix
  ];

  system.nixos.label = lib.mkAfter "sway";

  programs.sway = {
    enable = true;
    package = pkgs.sway.override {
      extraSessionCommands = ''
        source /etc/profile
      '';
      withGtkWrapper = false;
      isNixOS = true;
    };
    extraPackages = [];
  };

  xdg.portal.enable = true;
}

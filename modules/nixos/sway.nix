{lib, ...}: {
  imports = [
    ./wayland-compositors.nix
  ];

  system.nixos.label = lib.mkAfter "sway";

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = [];
    extraSessionCommands = ''
      source /etc/profile
    '';
  };

  xdg.portal.enable = true;
}

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
      . /etc/profile
    '';
  };
  
  xdg.portal.enable = true;
}

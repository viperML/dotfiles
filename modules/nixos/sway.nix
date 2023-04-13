{
  imports = [
    ./wayland-compositors.nix
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = [];
    extraSessionCommands = ''
      source /etc/profile
    '';
  };
}

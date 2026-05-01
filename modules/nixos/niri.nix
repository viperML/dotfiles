{
  imports = [
    ./wayland-compositors.nix
  ];

  maid.sharedModules = [
    ../maid/niri
  ];

  programs.niri = {
    enable = true;
  };
}

{...}: {
  programs.command-not-found.enable = false;
  home-manager.sharedModules = [./hm.nix];
}

{nixpkgs}: {pkgs, ...}: {
  _file = ./default.nix;
  wrappers.nvfetcher = {
    basePackage = pkgs.nvfetcher-bin;
    env.NIX_PATH.value = "nixpkgs=${nixpkgs}";
  };
}

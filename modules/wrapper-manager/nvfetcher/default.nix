{pkgs, ...}: {
  _file = ./default.nix;
  wrappers.nvfetcher = {
    # basePackage = pkgs.nvfetcher-bin;
    basePackage = pkgs.nvfetcher;
    env.NIX_PATH.value = "nixpkgs=${pkgs.path}";
  };
}

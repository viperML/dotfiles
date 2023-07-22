{
  pkgs,
  lib,
  ...
}: {
  wrappers.git = {
    basePackage = pkgs.git;
    env.GIT_CONFIG_GLOBAL = ./gitconfig;
    extraPackages = [
      pkgs.git-extras
      pkgs.delta
    ];
  };
}

{
  pkgs,
  lib,
  ...
}: {
  wrappers.git = {
    basePackage = pkgs.git;
    env.GIT_CONFIG_GLOBAL.value = ./gitconfig;
    extraPackages = [
      pkgs.git-extras
    ];
    pathAdd = [
      pkgs.delta
    ];
  };
}

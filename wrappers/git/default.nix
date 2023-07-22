{
  pkgs,
  lib,
  ...
}: {
  wrappers.git = {
    basePackage = pkgs.git;
    env.GIT_CONFIG_GLOBAL = pkgs.writeText "gitconfig" (lib.fileContents ./gitconfig);
    extraPackages = [
      pkgs.git-extras
      pkgs.delta
    ];
  };
}

{
  pkgs,
  lib,
  ...
}:
let
  myGit = pkgs.gitFull;
  gitconfig =
    (builtins.readFile ../../../misc/gitconfig)
    +
      # gitconfig
      ''
        [commit]
          template = ${../../../misc/git_template}
      '';
in
{
  wrappers.git = {
    basePackage = myGit;
    extraPackages = [
      pkgs.git-extras
      myGit
    ];
    env.GIT_CONFIG_GLOBAL.value = builtins.toFile "gitconfig" gitconfig;
  };
}

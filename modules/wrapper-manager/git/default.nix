{
  pkgs,
  ...
}:
let
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
  wrappers.git-viper = {
    basePackage = pkgs.git;
    extraPackages = [
      pkgs.git-extras
      # myGit
    ];
    env.GIT_CONFIG_GLOBAL.value = builtins.toFile "gitconfig" gitconfig;
  };
}

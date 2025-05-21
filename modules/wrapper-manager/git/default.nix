{
  pkgs,
  ...
}:
let
  gitconfig = builtins.toFile "gitconfig" (
    (builtins.readFile ../../../misc/gitconfig)
    +
      # gitconfig
      ''
        [commit]
          template = ${../../../misc/git_template}
      ''
  );
in
{
  wrappers.git-viper = {
    basePackage = pkgs.git.overrideAttrs (old: {
      passthru = (old.passhtru or { }) // {
        inherit gitconfig;
      };
    });
    extraPackages = [
      pkgs.git-extras
      # myGit
    ];
    env.GIT_CONFIG_GLOBAL.value = gitconfig;
  };
}

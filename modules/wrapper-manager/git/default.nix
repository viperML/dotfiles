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

        [core]
          excludesfile = ${builtins.toFile "excludes" ''
            .cajon.js
            .cajon.mjs
          ''}
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
      pkgs.git-graph
      # myGit
    ];
    env.GIT_CONFIG_GLOBAL.value = gitconfig;
  };
}

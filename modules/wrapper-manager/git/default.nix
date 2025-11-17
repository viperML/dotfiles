{
  pkgs,
  lib,
  ...
}:
let
  gitconfig = pkgs.writeText "gitconfig" (
    (builtins.readFile ../../../misc/gitconfig)
    +
      # gitconfig
      ''
        [commit]
          template = ${../../../misc/git_template}

        [pager]
          blame = ${lib.getExe pkgs.delta} --syntax-theme ansi

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
      pkgs.delta
      # myGit
    ];
    env.GIT_CONFIG_GLOBAL.value = gitconfig;
  };
}

{
  config,
  pkgs,
  lib,
  inputs,
  self,
  ...
}:
{
  home.file.".nix-inputs/nixpkgs".source = self.outPath;
  home.sessionVariables.NIX_PATH = "nixpkgs=${config.home.homeDirectory}/.nix-inputs/nixpkgs$\{NIX_PATH:+:$NIX_PATH}";
  home.activation.useFlakeChannels = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/.nix-defexpr
    $DRY_RUN_CMD ln -s $VERBOSE_ARG /dev/null $HOME/.nix-defexpr
    $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/.nix-channels
    $DRY_RUN_CMD ln -s $VERBOSE_ARG /dev/null $HOME/.nix-channels
  '';
}

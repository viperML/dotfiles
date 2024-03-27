{
  lib,
  buildEnv,
  fzf,
  starship,
  direnv,
  nix-index,
  eza,
  bat,
}@args:
buildEnv {
  name = "env";
  paths = builtins.filter lib.isDerivation (builtins.attrValues args);
}

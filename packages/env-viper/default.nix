{
  lib,
  buildEnv,
  #
  fzf,
  starship,
  carapace,
  direnv,
  nix-index,
  eza,
  bat,
  fish-viper,
  neovim,
  elf-info,
  gh,
  unar,
  hexyl,
  du-dust,
  magic-wormhole-rs,
  fd,
  ripgrep,
  libarchive,
  dogdns,
  git-viper,
  difftastic,
  elfutils-cli,
  lurk,
  fq,
  jq,
  alejandra,
  nixfmt-rfc-style,
  npins,
  psmisc,
  nil,
  yazi,
  httpie,
  osc,
}@args:
buildEnv {
  name = "env";
  paths = args |> builtins.attrValues |> builtins.filter lib.isDerivation;
  extraOutputsToInstall = ["out" "man"];
}

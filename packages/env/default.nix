{
  inputs',
  #
  lib,
  symlinkJoin,
  #
  fzf,
  starship,
  direnv,
  nix-index,
  eza,
  bat,
  fish,
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
  git,
  difftastic,
  elfutils-cli,
  lurk,
  fq,
  alejandra,
  nil,
  psmisc,
} @ args:
symlinkJoin {
  name = "env";
  paths =
    (builtins.filter lib.isDerivation (builtins.attrValues args))
    ++ [inputs'.nh.packages.default inputs'.hover-rs.packages.default];
}

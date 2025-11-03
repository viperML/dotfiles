{
  lib,
  buildEnv,
  #
  fzf,
  starship,
  direnv,
  nix-index,
  eza,
  bat,
  fish-viper,
  neovim,
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
  fq,
  jq,
  nixfmt-rfc-style,
  npins,
  psmisc,
  nil,
  yazi,
  curl,
  wget,
  osc,
  file,
  pax-utils,
  # e2fsprogs.bin,
  nixpkgs-fmt,
  nix-output-monitor,
  shellcheck,
  sops,
  age,
  hover-rs,
}@args:
buildEnv {
  name = "env";
  paths = args |> builtins.attrValues |> builtins.filter lib.isDerivation;
  extraOutputsToInstall = [
    "out"
    "man"
  ];
}

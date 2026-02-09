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
  dust,
  magic-wormhole-rs,
  fd,
  ripgrep,
  libarchive,
  doggo,
  git-viper,
  difftastic,
  elfutils-cli,
  fq,
  jq,
  nixfmt,
  npins,
  psmisc,
  nil,
  yazi,
  curlFull,
  wget,
  osc,
  file,
  pax-utils,
  # e2fsprogs.bin,
  shfmt,
  nix-output-monitor,
  shellcheck,
  sops,
  age,
  hover-rs,
  cajon,
  jujutsu,
}@args:
buildEnv {
  name = "env";
  paths = args |> builtins.attrValues |> builtins.filter lib.isDerivation;
  extraOutputsToInstall = [
    "out"
    "man"
  ];
}

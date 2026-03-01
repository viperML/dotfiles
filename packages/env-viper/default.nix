{
  stdenv,
  lib,
  # shell environment
  fish-viper,
  starship,
  fzf,
  direnv,
  zellij,
  osc,
  neovim,
  # file navigation
  eza,
  yazi,
  fd,
  ripgrep,
  dust,
  # file analysis
  file,
  pax-utils,
  unar,
  libarchive,
  fq,
  jq,
  hexyl,
  imagemagick,
  litecli,
  elfutils-cli,
  # git & vcs
  git-viper,
  difftastic,
  jujutsu,
  gh,
  # network
  rsync,
  serve,
  curlFull,
  wget,
  doggo,
  magic-wormhole-rs,
  net-tools,
  tcpdump,
  # nix tooling
  nix-index,
  nixfmt,
  npins,
  nil,
  nix-output-monitor,
  # shell
  shfmt,
  shellcheck,
  # secrets
  sops,
  age,
  # nodejs
  nodejs,
  pnpm,
  prettier,
  # other
  hover-rs,
  cajon,
  psmisc,
}@args:
stdenv.mkDerivation {
  name = "env-viper";
  propagatedUserEnvPkgs =
    args
    |> lib.filterAttrs (
      name: value:
      !(builtins.elem name [
        "lib"
        "stdenv"
      ])
    )
    |> builtins.attrValues;

  dontUnpack = true;
  buildPhase = "mkdir $out";

  meta.mainProgram = "fish";
}

# Simple shell to allow nix flakes
{ pkgs ? import <nixpkgs> { } }:

with pkgs;
mkShell {
  name = "dotfiles";
  buildInputs = [
    git
    gnumake
    jq
    nixos-install-tools
    nixUnstable
    ripgrep
    update-nix-fetchgit
  ];
  shellHook = ''
    export NIX_USER_CONF_FILES="$(pwd)/modules/nix.conf"
    export FLAKE="/home/ayats/.dotfiles"
    echo -e "\n\e[34m❄ Welcome to viperML/dotfiles ❄"
    echo "Last flake update:"
    git log -1 --pretty="format:%ch" flake.lock
    echo -e "\n\e[34m❄ Changes to the running NixOS config: ❄"
    echo -e "\e[0m"
    git --no-pager diff $(nixos-version --json | jq -r '.configurationRevision') -p
  '';
}

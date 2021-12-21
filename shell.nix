# Simple shell to allow nix flakes
{ pkgs ? import <nixpkgs> { } }:

with pkgs;
let nixBin =
  writeShellScriptBin "nix" ''
    ${nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
  '';
in
mkShell {
  buildInputs = [
    git
    nixos-install-tools
    nixUnstable
    gnumake
    jq
    update-nix-fetchgit
    ripgrep
  ];
  shellHook = ''
    export FLAKE="$(pwd)"
    echo -e "\n\e[34m❄ Welcome to viperML/dotfiles ❄"
    echo "Last flake update:"
    git log -1 --pretty="format:%ch" flake.lock
    echo -e "\n\e[34m❄ Changes to the running NixOS config: ❄"
    echo -e "\e[0m"
    git --no-pager diff $(nixos-version --json | jq -r '.configurationRevision') -p
  '';
}

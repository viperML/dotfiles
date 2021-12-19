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
  ];
  shellHook = ''
    export FLAKE="$(pwd)"
  '';
}

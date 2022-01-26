{ pkgs ? import <nixpkgs> { overlays = [
  (import ./overlay-patches.nix)
];}}: pkgs

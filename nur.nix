{ pkgs ? import <nixpkgs> { }}:

{
  overlays.viperML-dotfiles = import ./overlay/overlay-pkgs.nix;
}

{ config, pkgs, lib, ... }:

{
  home.sessionVariables.FLAKE = lib.mkForce "$HOME/Documents/dotfiles";
}

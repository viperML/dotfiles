{ pkgs, lib, ... }:

{
  kwriteconfig = import ./kwriteconfig.nix { inherit pkgs lib; };
}

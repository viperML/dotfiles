{ lib, ... }:

{
  kwriteconfig = import ./kwriteconfig.nix { inherit lib; };
}

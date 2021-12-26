{ lib, ... }:

{
  kwriteconfig = import ./kwriteconfig { inherit lib; };
}

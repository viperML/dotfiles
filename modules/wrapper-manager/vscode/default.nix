{ pkgs, ... }:
let
  env = {
    NIXOS_OZONE_WL = {
      value = "1";
    };
  };
in
{
  wrappers.vscode = {
    basePackage = pkgs.vscode;
    inherit env;
  };

  wrappers.code-cursor = {
    basePackage = pkgs.code-cursor;
    inherit env;
  };
}

{ pkgs, lib, ... }:
let
  config = pkgs.writeText "ghostty-config" (
    [
      ./config
      ./catpuccin-mocha.conf
      # ./vesper.conf
    ]
    |> (map builtins.readFile)
    |> (lib.concatStringsSep "\n")
  );
in
{
  file.xdg_config."ghostty/config".source = config;

  packages = [
    pkgs.ghostty
  ];
}

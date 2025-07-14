{ pkgs, lib, ... }:
let

  config = pkgs.writeText "ghostty-config" (
    [
      ./config
      ./catpuccin-mocha.conf
    ]
    |> (map builtins.readFile)
    |> (lib.concatStringsSep "\n")
  );
in
{
  wrappers.ghostty = {
    basePackage = pkgs.ghostty;
    prependFlags = [
      "--config-file=${config}"
    ];
    programs.ghostty-unwrapped = {
      target = "ghostty";
    };
  };
}

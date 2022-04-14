{
  pkgs,
  lib,
  ...
}: let
  env = {
    NIX_LD_LIBRARY_PATH = lib.makeLibraryPath (with pkgs; [
      stdenv.cc.cc
      openssl
    ]);
    NIX_LD = "$(${pkgs.coreutils}/bin/cat ${pkgs.stdenv.cc}/nix-support/dynamic-linker)";
  };
in {
  environment.variables = env;
  environment.sessionVariables = env;
  home-manager.sharedModules = [
    {
      home.sessionVariables = env;
    }
  ];

  programs.nix-ld.enable = true;
}

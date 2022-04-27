{
  pkgs,
  lib,
  config,
  ...
}: let
  libpkgs = with pkgs; {
    base = [
      stdenv.cc.cc
      openssl
      curl
      glib
    ];
    graphical = [
      freetype
      libglvnd
      libnotify
      SDL2
      vulkan-loader
      gdk-pixbuf
    ];
  };

  env = {
    NIX_LD_LIBRARY_PATH = lib.makeLibraryPath (
      if config.services.xserver.enable
      then libpkgs.base
      else libpkgs.base ++ libpkgs.graphical
    );
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

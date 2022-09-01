{
  pkgs,
  lib,
  config,
  packages,
  ...
}: let
  libpkgs = with pkgs; {
    base = [
      stdenv.cc.cc
      openssl
      curl
      glib
      util-linux
      glibc
      icu
      libunwind
      libuuid
      zlib
      libsecret
    ];
    graphical = [
      freetype
      libglvnd
      libnotify
      SDL2
      vulkan-loader
      gdk-pixbuf
      xorg.libX11
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
  environment.sessionVariables = env;

  programs.nix-ld.enable = true;

  systemd.tmpfiles.packages = [pkgs.nix-ld];

  environment.systemPackages = [pkgs.appimage-run];
  boot.binfmt.registrations = lib.genAttrs ["appimage" "AppImage"] (ext: {
    recognitionType = "extension";
    magicOrExtension = ext;
    interpreter = "/run/current-system/sw/bin/appimage-run";
  });
}

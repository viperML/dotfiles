{
  stdenv,
  fetchFromGitHub,
  plugins ? [],
  lib,
}: let
  drvToName = drv:
    builtins.concatStringsSep "-" (builtins.tail (lib.strings.splitString "-" (lib.lists.last (lib.strings.splitString "/" drv))));
  plugins-withNames =
    builtins.map (plug: {
      name = drvToName "${plug}";
      drv = plug;
    })
    plugins;
in
  stdenv.mkDerivation {
    pname = "bdCompat";
    version = "unstable-2021-11-10";

    src = fetchFromGitHub {
      owner = "Juby210";
      repo = "bdCompat";
      rev = "d758d7fbed95c37b6921244c1215727f2ac4ddef";
      sha256 = "0anm27syhn99c013l4y4rm4igq241xd65vhaigqn8dnw23avbcc8";
    };

    installPhase = ''
      mkdir -p $out
      cp -r $src/* $out
      mkdir -p $out/plugins
      ${lib.concatMapStringsSep "\n" (p: "cp ${p} $out/plugins/") plugins}
    '';

    meta = with lib; {
      description = "Compatibility layer for running BetterDiscord plugins in Powercord ";
      homepage = "https://github.com/Juby210/bdCompat";
      license = licenses.mit;
      platforms = platforms.all;
    };
  }

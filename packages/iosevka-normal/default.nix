{
  callPackages,
  lib,
  stdenvNoCC,
  unzip,
}: let
  nv = (callPackages ./generated.nix {}).iosevka;
in
  stdenvNoCC.mkDerivation {
    inherit (nv) pname src;
    version = lib.removePrefix "v" nv.version;

    nativeBuildInputs = [unzip];

    unpackPhase = ''
      runHook preUnpack

      unzip $src -d $PWD

      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      dest=$out/share/fonts/truetype
      mkdir -p $dest
      cp -avL TTF/*.ttf $dest

      runHook postInstall
    '';
  }

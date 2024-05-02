{
  callPackages,
  stdenvNoCC,
  makeWrapper,
  jq,
  glow,
  lib,
}: let
  nv = (callPackages ./generated.nix {}).xdg-ninja;
in
  stdenvNoCC.mkDerivation rec {
    inherit (nv) pname src;
    version = nv.date;

    nativeBuildInputs = [makeWrapper];

    propagatedBuildInputs = [jq glow];

    installPhase = ''
      runHook preInstall
      mkdir -pv $out/{bin,share/xdg-ninja}
      cp -av xdg-ninja.sh $out/bin/xdg-ninja
      cp -av programs $out/share/xdg-ninja
      substituteInPlace $out/bin/xdg-ninja \
        --replace '$0' "$out/share/xdg-ninja/programs"
      wrapProgram $out/bin/xdg-ninja \
        --prefix PATH ':' ${lib.makeBinPath propagatedBuildInputs}
      runHook postInstall
    '';
  }

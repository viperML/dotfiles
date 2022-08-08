{
  pname,
  version,
  src,
  #
  stdenvNoCC,
  makeWrapper,
  jq,
  glow,
  lib,
}:
stdenvNoCC.mkDerivation rec {
  inherit pname version src;
  nativeBuildInputs = [
    makeWrapper
  ];
  propagatedBuildInputs = [
    jq
    glow
  ];
  installPhase = ''
    mkdir -pv $out/{bin,share/xdg-ninja}
    cp -av xdg-ninja.sh $out/bin/xdg-ninja
    cp -av programs $out/share/xdg-ninja
    substituteInPlace $out/bin/xdg-ninja \
      --replace '$0' "$out/share/xdg-ninja/programs"
    wrapProgram $out/bin/xdg-ninja \
      --prefix PATH ':' ${lib.makeBinPath propagatedBuildInputs}
  '';
}

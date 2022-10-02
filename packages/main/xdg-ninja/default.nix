{
  pname,
  date,
  src,
  #
  stdenvNoCC,
  makeWrapper,
  jq,
  glow,
  lib,
}:
stdenvNoCC.mkDerivation rec {
  inherit pname src;
  version = date;

  nativeBuildInputs = [
    makeWrapper
  ];

  propagatedBuildInputs = [
    jq
    glow
  ];

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

  meta = with lib; {
    description = "Script which checks your $HOME for unwanted files and directories";
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.all;
  };
}

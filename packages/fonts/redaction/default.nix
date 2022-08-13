{
  stdenvNoCC,
  fetchzip,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "redaction";
  version = "0.0.0";

  src = fetchzip {
    url = "https://www.cdnfonts.com/download/redaction-cdnfonts.zip";
    sha256 = "1p2fcv62ywjhh9859r98jsz957h3fh4h5r0z12hmq12j7mzcyx3q";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/truetype
    install -Dm644 *.otf $out/share/fonts/truetype
    runHook postInstall
  '';

  meta = with lib; {
    description = "A typeface inspired by The Redaction by Titus Kaphar and Reginald Dwayne Betts";
    homepage = "https://www.redaction.us/";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}

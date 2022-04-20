{
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "comic-code";
  version = "1.0";

  src = ./otf;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    install -Dm644 *.otf $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "Monospaced adaptation of the most infamous yet most popular casual font";
    homepage = "https://tosche.net/fonts/comic-code";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}

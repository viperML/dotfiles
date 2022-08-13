{
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "comic-code";
  version = "0.0.0";

  src = ./otf;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/truetype
    install -Dm444 *.otf $out/share/fonts/truetype
    runHook postInstall
  '';

  meta = with lib; {
    description = "Monospaced adaptation of the most infamous yet most popular casual font";
    homepage = "https://tosche.net/fonts/comic-code";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}

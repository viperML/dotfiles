{
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "hoefler-text";
  version = "1.0";

  src = ./src;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    install -Dm644 *.ttf $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "Comprehensive family of typefaces from the dawn of the digital age";
    homepage = "https://www.typography.com/fonts/latest-releases";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}

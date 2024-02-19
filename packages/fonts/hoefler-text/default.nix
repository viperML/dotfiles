{ stdenvNoCC
, lib
,
}:
stdenvNoCC.mkDerivation {
  pname = "hoefler-text";
  version = "0.0.0";

  src = ./src;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/truetype
    install -Dm444 *.ttf $out/share/fonts/truetype
    runHook postInstall
  '';

  meta = with lib; {
    description = "Comprehensive family of typefaces from the dawn of the digital age";
    homepage = "https://www.typography.com/fonts/latest-releases";
    # Doesn't matter
    # license = licenses.unfree;
    platforms = platforms.all;
  };
}

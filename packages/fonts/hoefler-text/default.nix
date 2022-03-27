{stdenvNoCC}:
stdenvNoCC.mkDerivation {
  pname = "hoefler-text";
  version = "1.0";

  src = ./src;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    install -Dm644 *.ttf $out/share/fonts/truetype
  '';
}

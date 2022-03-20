{stdenv}:
stdenv.mkDerivation {
  pname = "comic-code";
  version = "1.0";

  src = ./otf;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    install -Dm644 *.otf $out/share/fonts/truetype
  '';
}

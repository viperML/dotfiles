{
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation {
  pname = "redaction";
  version = "1.0.0";
  src = fetchzip {
    url = "https://www.cdnfonts.com/download/redaction-cdnfonts.zip";
    sha256 = "1p2fcv62ywjhh9859r98jsz957h3fh4h5r0z12hmq12j7mzcyx3q";
    stripRoot = false;
  };
  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    install -Dm644 *.otf $out/share/fonts/truetype
  '';
}

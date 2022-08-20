{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "san-francisco";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "AppleDesignResources";
    repo = "SanFranciscoFont";
    rev = "59cf0dc3660e99e66813665354f787895fb41fe1";
    sha256 = "0fpfy884g81zsih0ldr8hj2jcxcm3xbw179zs0vbsqhsnq2p9wig";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/truetype
    cp -r *.otf $out/share/fonts/truetype
    runHook postInstall
  '';

  meta = with lib; {
    description = "San Francisco is a neo-grotesque sans-serif typeface made by Apple Inc";
    homepage = "https://developer.apple.com/fonts/";
    # Doesn't matter
    # license = licenses.unfree;
    platforms = platforms.all;
  };
}

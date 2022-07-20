{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "san-francisco";
  version = "2015-06-10";

  src = fetchFromGitHub {
    owner = "AppleDesignResources";
    repo = "SanFranciscoFont";
    rev = "59cf0dc3660e99e66813665354f787895fb41fe1";
    sha256 = "0fpfy884g81zsih0ldr8hj2jcxcm3xbw179zs0vbsqhsnq2p9wig";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -r *.otf $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "San Francisco is a neo-grotesque sans-serif typeface made by Apple Inc";
    homepage = "https://developer.apple.com/fonts/";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}

{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "san-francisco";
  version = "unstable-2015-06-10";

  src = fetchFromGitHub {
    owner = "AppleDesignResources";
    repo = "SanFranciscoFont";
    rev = "59cf0dc3660e99e66813665354f787895fb41fe1";
    sha256 = "1fih83r9ijyyfskwaf22id2yvgrddz4x63w1g0b6r1b3grf1x0gy";
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

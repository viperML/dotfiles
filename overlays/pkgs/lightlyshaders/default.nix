{
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  wrapQtAppsHook,
  kwin,
  kdelibs4support,
  libepoxy,
  libXdmcp,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "lightlyshaders";
  version = "unstable-2022-02-24";

  src = fetchFromGitHub {
    repo = "LightlyShaders";
    owner = "a-parhom";
    rev = "7e06ae57ad66a22cfac8cdbf34038050c2257194";
    sha256 = "1m5jwxjg4l6r4rrfrlkjvsvjxjdaj2n8s86rbp6h4qcgy5bad8l2";
  };

  postConfigure = ''
    substituteInPlace cmake_install.cmake \
      --replace "${kdelibs4support}" "$out"
  '';

  nativeBuildInputs = [cmake extra-cmake-modules wrapQtAppsHook];
  buildInputs = [kwin kdelibs4support libepoxy libXdmcp];

  meta = with lib; {
    description = "Round corners and outline effect for KWin";
    homepage = "https://github.com/a-parhom/LightlyShaders";
    platforms = platforms.linux;
  };
}

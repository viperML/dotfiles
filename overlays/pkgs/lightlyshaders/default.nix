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
  version = "unstable-2022-02-26";

  src = fetchFromGitHub {
    repo = "LightlyShaders";
    owner = "viperML";
    rev = "e5fa193821e8eafbba4cbdceebe276cb9a95e715";
    sha256 = "0mkallhppw6iw02hfn916r4llxsdd54p8wlk6i4llxjcdwiimqlc";
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

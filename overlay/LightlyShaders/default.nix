{ stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, wrapQtAppsHook
, kwin
, kdelibs4support
, libepoxy
, libXdmcp
, lib
}:

stdenv.mkDerivation rec {
  pname = "lightlyshaders";
  version = "unstable-2022-02-03";

  src = fetchFromGitHub {
    repo = "LightlyShaders";
    owner = "a-parhom";
    rev = "ea8187d52d2f20771ebde35fef4d9726808e583e";
    sha256 = "1npw4s0kys4ahcsrl9cznxaqkqhlnkq3q03qmcnn3zl2z72n9v5n";
  };

  postConfigure = ''
    substituteInPlace cmake_install.cmake \
      --replace "${kdelibs4support}" "$out"
  '';

  nativeBuildInputs = [ cmake extra-cmake-modules wrapQtAppsHook ];
  buildInputs = [ kwin kdelibs4support libepoxy libXdmcp ];

  meta = with lib; {
    description = "Round corners and outline effect for KWin";
    homepage = "https://github.com/a-parhom/LightlyShaders";
  };
}

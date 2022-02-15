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
  version = "unstable-2022-02-15";

  src = fetchFromGitHub {
    repo = "LightlyShaders";
    owner = "a-parhom";
    rev = "1931e4262eebb1a9c8a9e3ef75b593906991cfbb";
    sha256 = "0ximyigail148k4nd6waagsyvjijw1dxldgpqx64c02x87p48lls";
  };

  postConfigure = ''
    substituteInPlace cmake_install.cmake \
      --replace "${kdelibs4support}" "$out"
  '';

  nativeBuildInputs = [ cmake extra-cmake-modules wrapQtAppsHook ];
  buildInputs = [ kwin kdelibs4support libepoxy libXdmcp ];

  meta =
    with lib; {
      description = "Round corners and outline effect for KWin";
      homepage = "https://github.com/a-parhom/LightlyShaders";
      platforms = platforms.linux;
    };
}

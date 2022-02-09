{ stdenv
, lib
, fetchFromGitHub
, cmake
, extra-cmake-modules
, qt5
, libsForQt5
, qtbase
, wrapQtAppsHook
, libepoxy
, xorg
}:

stdenv.mkDerivation {
  pname = "lightlyshaders";
  version = "unstable-2022-02-03";

  src = fetchFromGitHub {
    repo = "LightlyShaders";
    owner = "a-parhom";
    rev = "ea8187d52d2f20771ebde35fef4d9726808e583e";
    sha256 = "1npw4s0kys4ahcsrl9cznxaqkqhlnkq3q03qmcnn3zl2z72n9v5n";
  };

  buildInputs = [
    qt5.qttools
    qt5.qtx11extras
    libsForQt5.kconfigwidgets
    libsForQt5.kcrash
    libsForQt5.kguiaddons
    libsForQt5.kglobalaccel
    libsForQt5.kio
    libsForQt5.ki18n
    libsForQt5.knotifications
    libsForQt5.kinit
    libsForQt5.kwin
    qtbase
    libepoxy
    xorg.libxcb
    xorg.libXdmcp
    xorg.libXcursor
    xorg.libXdamage
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  cmakeFlags = [
    # "-DCMAKE_INSTALL_PREFIX=/"
    "-DQT5BUILD=ON"
  ];

  installPhase = ''
    make DESTDIR="$out" install
    rm -rf $out/nix
  '';
}

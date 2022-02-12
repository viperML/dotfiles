{ lib
, stdenv
, fetchFromGitHub
, qtbase
, wrapQtAppsHook
, cmake
, extra-cmake-modules
, qt5
, libsForQt5
, plasma-desktop
}:
stdenv.mkDerivation rec {
  pname = "lightly";
  version = "unstable-2021-11-17";

  src = fetchFromGitHub {
    owner = "Luwx";
    repo = "lightly";
    rev = "4a918fee87ed37b165c209c4857e8ed473f00acb";
    sha256 = "02lznx75cl6m2m57697wv84x8cqypb6afy691jn5fkxh2gh70iib";
  };

  patches = [
    ./no-blur.patch
  ];

  buildInputs =
    [
      libsForQt5.kconfigwidgets
      libsForQt5.kcoreaddons
      libsForQt5.kdecoration
      libsForQt5.kguiaddons
      libsForQt5.kiconthemes
      libsForQt5.kwindowsystem
      plasma-desktop
      qt5.qtdeclarative
      qt5.qtx11extras
      qtbase
    ];

  nativeBuildInputs = [
    wrapQtAppsHook
    cmake
    extra-cmake-modules
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DKDE_INSTALL_LIBDIR=lib"
    "-DBUILD_TESTING=OFF"
    "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
  ];

  meta =
    with lib; {
      description = "Fork of breeze theme style that aims to be visually modern and minimalistic";
      homepage = "https://github.com/Luwx/Lightly";
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
}

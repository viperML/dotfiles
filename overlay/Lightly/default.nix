{ lib
, stdenv
, fetchFromGitHub
, pkgs
, qtbase
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "lightly";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "Luwx";
    repo = pname;
    rev = "v" + version;
    sha256 = "0qkjzgjplgwczhk6959iah4ilvazpprv7yb809jy75kkp1jw8mwk";
  };

  patches = [
    ./no-blur.patch
  ];

  buildInputs = with pkgs; [
    qtbase
    cmake
    extra-cmake-modules
    qt5.qtdeclarative
    libsForQt5.kdecoration
    qt5.qtx11extras
    plasma-desktop
    libsForQt5.kcoreaddons
    libsForQt5.kguiaddons
    libsForQt5.kconfigwidgets
    libsForQt5.kwindowsystem
    libsForQt5.kiconthemes
  ];

  nativeBuildInputs = [ wrapQtAppsHook ];

  cmakeFlags = "-DCMAKE_BUILD_TYPE=Release -DKDE_INSTALL_LIBDIR=lib -DBUILD_TESTING=OFF -DKDE_INSTALL_USE_QT_SYS_PATHS=ON";

  meta = with lib; {
    description = "Lightly is a fork of breeze theme style that aims to be visually modern and minimalistic.";
    homepage = "https://github.com/Luwx/Lightly";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

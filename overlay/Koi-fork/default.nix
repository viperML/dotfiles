{ stdenv
, lib
, fetchFromGitHub
, wrapQtAppsHook
, ninja
, extra-cmake-modules
, kconfig
, kcoreaddons
, kpackage
, kservice
, kwidgetsaddons
, qtbase
, qtdeclarative
, xsettingsd
}:

stdenv.mkDerivation rec {
  pname = "koi";
  version = "20201128";

  src = fetchFromGitHub {
    owner = "Da-Viper";
    repo = pname;
    rev = "452fc479024a18c099e15d66f1d61f464b63bb8c";
    sha256 = "1j3gik4qb0dcg0fx22waiav6jg1zsrir13d562hpvljwr6af7m0h";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    extra-cmake-modules
    ninja
  ];

  buildInputs = [
    kconfig
    kcoreaddons
    kpackage
    kservice
    kwidgetsaddons
    qtbase
    qtdeclarative
    xsettingsd
  ];

  meta = with lib; {
    homepage = "https://github.com/Da-Viper/Koi";
    description = "Theme scheduling for the KDE Plasma Desktop";
    license = licenses.lgpl3;
    platforms = platforms.linux;
  };
}

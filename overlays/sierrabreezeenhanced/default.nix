{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, pkgs
, qtbase
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "sierrabreezeenhanced";
  version = "V1.0.3";

  src = fetchFromGitHub {
    owner = "kupiqu";
    repo = pname;
    rev = version;
    sha256 = "0kqbfn1jqsbii3hqcqlb93x8cg8dyh5mf66i9r237w41knks5mnw";
  };

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

  installPhase = ''
		cmake .. -DCMAKE_INSTALL_PREFIX=$out -DCMAKE_BUILD_TYPE=Release -DKDE_INSTALL_LIBDIR=lib -DBUILD_TESTING=OFF -DKDE_INSTALL_USE_QT_SYS_PATHS=ON
		make
		make install
	'';

  meta = with lib; {
    description = "A port of the arc theme for Plasma";
    homepage = "https://git.io/arc-kde";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}

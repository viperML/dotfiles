{ lib
, stdenv
, fetchFromGitHub
, pkgs
, qtbase
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "sierrabreezeenhanced";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "kupiqu";
    repo = pname;
    rev = "V" + version;
    sha256 = "0kqbfn1jqsbii3hqcqlb93x8cg8dyh5mf66i9r237w41knks5mnw";
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

  # buildPhase = ''
  #   make
  # '';

  # installPhase = ''
	# 	make install
	# '';

  meta = with lib; {
    description = "Fork of BreezeEnhanced to make it (arguably) more minimalistic and informative";
    homepage = "https://github.com/kupiqu/SierraBreezeEnhanced";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}

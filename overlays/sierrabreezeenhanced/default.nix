{ lib
, mkDerivation
, fetchFromGithub
, cmake
, cmake-extra-modules
, kdecoration
, qtdeclarative
, qtx11extras
, plasma-desktop
, kcoreaddons
, kguiaddons
, kconfigwidgets
, kwindowsystem
, kiconthemes
}:
mkDerivation rec {
  pname = "sierrabreezeenhanced";
  version = "V1.0.3";

  src = fetchFromGitHub {
    owner = "kupiqu";
    repo = pname;
    rev = version;
    sha256 = "0kqbfn1jqsbii3hqcqlb93x8cg8dyh5mf66i9r237w41knks5mnw";
  };

  buildInputs = [
    cmake
    extra-cmake-modules
    kdecoration
    qtdeclarative
    qtx11extras
    plasma-desktop
    kcoreaddons
    kguiaddons
    kconfigwidgets
    kwindowsystem
    kiconthemes
  ];

  installPhase = ''
    		cmake .. -DCMAKE_INSTALL_PREFIX=$out -DCMAKE_BUILD_TYPE=Release -DKDE_INSTALL_LIBDIR=lib -DBUILD_TESTING=OFF -DKDE_INSTALL_USE_QT_SYS_PATHS=ON
    		make
    		make install
    	'';

  meta = with lib; {
    description = "A fork of Breeze theme that resembles Max OS X.";
    homepage = "https://github.com/kupiqu/sierrabreezeenhanced";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };

}

{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapQtAppsHook,
  cmake,
  extra-cmake-modules,
  qtbase,
  qtdeclarative,
  qtx11extras,
  plasma-desktop,
  kwindowsystem,
  kdecoration,
  kcoreaddons,
  kguiaddons,
  kconfigwidgets,
  kiconthemes,
}:
stdenv.mkDerivation {
  pname = "sierrabreezeenhanced";
  version = "unstable-2021-10-25";

  src = fetchFromGitHub {
    owner = "kupiqu";
    repo = "SierraBreezeEnhanced";
    rev = "8800ff577ca5c16b2d8269eb34d555ec519c0682";
    sha256 = "0kqbfn1jqsbii3hqcqlb93x8cg8dyh5mf66i9r237w41knks5mnw";
  };

  patches = [
    ./no-blur.patch
  ];

  buildInputs = [
    qtbase
    qtdeclarative
    qtx11extras
    plasma-desktop
    kdecoration
    kcoreaddons
    kguiaddons
    kconfigwidgets
    kwindowsystem
    kiconthemes
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
    cmake
    extra-cmake-modules
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DKDE_INSTALL_LIBDIR=lib"
    "-DBUILD_TESTING=OFF -DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
  ];

  meta = with lib; {
    description = "Fork of BreezeEnhanced to make it (arguably) more minimalistic and informative";
    homepage = "https://github.com/kupiqu/SierraBreezeEnhanced";
    license = licenses.gpl3;
    inherit (kwindowsystem.meta) platforms;
  };
}

{
  pname,
  version,
  src,
  #
  lib,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  kdecoration,
  kcoreaddons,
  kguiaddons,
  kconfigwidgets,
  kwindowsystem,
  kiconthemes,
  qtx11extras,
}:
mkDerivation {
  inherit pname version src;

  extraCmakeFlags = ["-DBUILD_TESTING=OFF"];

  nativeBuildInputs = [cmake extra-cmake-modules];

  buildInputs = [
    kcoreaddons
    kguiaddons
    kconfigwidgets
    kwindowsystem
    kiconthemes
    qtx11extras
    kdecoration
  ];

  meta = with lib; {
    description = "Fork of breeze theme style that aims to be visually modern and minimalistic";
    homepage = "https://github.com/Luwx/Lightly";
    license = licenses.gpl2;
    inherit (kwindowsystem.meta) platforms;
  };
}

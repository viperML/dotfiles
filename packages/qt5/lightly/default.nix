{
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
  pname = "lightly";
  version = "unstable-0.4.1";

  src = fetchFromGitHub {
    owner = "Luwx";
    repo = "lightly";
    rev = "121a61e5b67e5122449c80301e41b4de3649b0d5";
    sha256 = "154hfdzfc3dld6j90xyw28sskc5h1034sswh2slrpfb4l766sssj";
  };

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

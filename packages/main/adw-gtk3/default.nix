{
  pname,
  version,
  src,
  #
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  sassc,
  meson,
  ninja,
}:
stdenvNoCC.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];

  meta = with lib; {
    description = "Reversal kde is a materia Design theme for KDE Plasma desktop.";
    inherit (src.meta) homepage;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}

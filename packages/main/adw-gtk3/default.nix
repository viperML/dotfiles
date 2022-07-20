{
  pname,
  version,
  src,
  #
  stdenv,
  lib,
  fetchFromGitHub,
  sassc,
  meson,
  ninja,
}:
stdenv.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];

  meta = with lib; {
    description = "Reversal kde is a materia Design theme for KDE Plasma desktop.";
    homepage = "https://github.com/yeyushengfan258/Reversal-kde";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}

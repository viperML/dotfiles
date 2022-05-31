{
  stdenv,
  lib,
  fetchFromGitHub,
  sassc,
  meson,
  ninja,
}:
stdenv.mkDerivation rec {
  pname = "adw-gtk3";
  version = "1.9";

  src = fetchFromGitHub {
    repo = pname;
    owner = "lassekongo83";
    rev = "v${version}";
    sha256 = "sha256-J4hNNI6IKdMMMb+Qgv39d6WsVv/xi4swr5/ipUsyPPY=";
  };

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

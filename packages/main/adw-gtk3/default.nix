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
  version = "3.1";

  src = fetchFromGitHub {
    repo = pname;
    owner = "lassekongo83";
    rev = "v${version}";
    sha256 = "sha256-3degTSyM13QxlWYda6dQjfNsli9klSwz7f3mE/0cXb4=";
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

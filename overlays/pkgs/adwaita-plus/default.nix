{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  gnome-icon-theme,
  hicolor-icon-theme,
}:
stdenv.mkDerivation rec {
  pname = "adwaita-plus";
  version = "unstable-2021-07-28";

  src = fetchFromGitHub {
    repo = "adwaita-plus";
    owner = "Bonandry";
    rev = "8dd6ce97826c7b947e8e6dc023ae8a5c1b9429dd";
    sha256 = "1zi639l45k2bj7wybdlzq4hp8y10f7yirradp7axdylhxwmxckys";
  };

  nativeBuildInputs = [gtk3];

  propagatedBuildInputs = [gnome-icon-theme hicolor-icon-theme];

  makeFlags = ["PREFIX=$(out)"];

  dontDropIconThemeCache = true;

  meta = with lib; {
    description = "Third-party icons theme, based on new GNOME 3.32's Adwaita";
    homepage = "https://github.com/Bonandry/adwaita-plus";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}

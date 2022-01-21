{ stdenv
, lib
, fetchFromGitHub
, wrapQtAppsHook
, extra-cmake-modules
, kconfig
}:

stdenv.mkDerivation rec {
  pname = "plasma-theme-switcher";
  version = "20200220";

  src = fetchFromGitHub {
    owner = "maldoinc";
    repo = pname;
    rev = "ccc595f126a58475b42a6013727c6d0a9943b6e1";
    sha256 = "19731hx726ynqp8w3a624fwc67pk3n5rf11j214hk6jhmvl0kmxi";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
  ];

  installPhase = ''
    install -Dm755 plasma-theme $out/bin/plasma-theme
  '';

  meta = with lib; {
    homepage = "https://github.com/maldoinc/plasma-theme-switcher";
    description = "Quickly apply KDE Plasma color schemes and widget styles from the command-line";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

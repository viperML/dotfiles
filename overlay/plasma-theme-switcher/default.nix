{ stdenv
, lib
, fetchFromGitHub
, wrapQtAppsHook
, extra-cmake-modules
, kconfig
}:

stdenv.mkDerivation rec {
  pname = "plasma-theme-switcher";
  version = "develop-20201129";

  src = fetchFromGitHub {
    owner = "maldoinc";
    repo = pname;
    rev = "4c497d4b9bf2ebb4378d19285d2ac2a213bf54ab";
    sha256 = "19w3chvi8rqx35f750m18scwsc6nbqh7gpgdgiv6pf417f9mj9iz";
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

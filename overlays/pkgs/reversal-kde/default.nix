{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapQtAppsHook,
}:
stdenv.mkDerivation rec {
  pname = "reversal-kde";
  version = "unstable-2022-01-02";

  src = fetchFromGitHub {
    owner = "yeyushengfan258";
    repo = "reversal-kde";
    rev = "2f264d0bb78499f04383151d9f248617c83f3819";
    sha256 = "0i74hnvy3wv8gf1hyd4xx4ganq7q1h0ld3gcvig577ydd34mdya0";
  };

  nativeBuildInputs = [wrapQtAppsHook];

  installPhase = ''
    mkdir -p $out/share/{color-schemes,wallpapers,plasma/{desktoptheme,layout-templates,look-and-feel}}
    cp -r color-schemes/*.colors $out/share/color-schemes
    cp -r plasma/desktoptheme/* $out/share/plasma/desktoptheme
    cp -r plasma/look-and-feel/* $out/share/plasma/look-and-feel
  '';

  meta =
    with lib; {
      description = "Reversal kde is a materia Design theme for KDE Plasma desktop.";
      homepage = "https://github.com/yeyushengfan258/Reversal-kde";
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
}

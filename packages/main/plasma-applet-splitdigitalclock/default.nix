{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "plasma-applet-splitdigitalclock";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "viperML";
    repo = "splitdigitalclock";
    rev = "b0d3c52fbfa6b2f18991dc3bf34db21e0767c564";
    sha256 = "0500a3hgapp2ims9d3prb201was28zbhbm97lr7cpzsqf6413g9p";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids/org.kde.plasma.splitdigitalclock
    cp -r * $out/share/plasma/plasmoids/org.kde.plasma.splitdigitalclock
    runHook postInstall
  '';

  meta = with lib; {
    description = "Split Digital Clock";
    homepage = "https://store.kde.org/p/1324315";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}

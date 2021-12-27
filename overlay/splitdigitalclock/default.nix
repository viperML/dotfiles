{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation rec {

  pname = "plasma-applet-splitdigitalclock";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "viperML";
    repo = "splitdigitalclock";
    rev = "v" + version;
    sha256 = "0500a3hgapp2ims9d3prb201was28zbhbm97lr7cpzsqf6413g9p";
  };

  installPhase = ''
    mkdir -p $out/share/plasma/plasmoids/org.kde.plasma.splitdigitalclock
    cp -r * $out/share/plasma/plasmoids/org.kde.plasma.splitdigitalclock
  '';

  meta = with lib; {
    description = "Split Digital Clock";
    homepage = "https://store.kde.org/p/1324315";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}

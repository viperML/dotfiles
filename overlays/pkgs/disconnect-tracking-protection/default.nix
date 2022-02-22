{
  stdenv,
  fetchFromGitHub,
  python3,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "disconnect-tracking-protection";
  version = "unstable-2022-02-10";

  src = fetchFromGitHub {
    repo = "disconnect-tracking-protection";
    owner = "disconnectme";
    rev = "5b28d0adbafda7b6954251a4ff04b9707a260bf1";
    sha256 = "012z6asx234sapy3irrf8ryzbq02zhpggalgh8vsfbl90i9dkf62";
  };

  nativeBuildInputs = [
    python3
  ];

  buildPhase = ''
    mkdir -p $out
    python ${./parse_hosts.py} -f $src/services.json -o $out/hosts
  '';

  installPhase = ''
    cp $src/services.json $out
    cp $src/entities.json $out
  '';

  meta = with lib; {
    description = "Tracking protection lists and services";
    homepage = "https://github.com/disconnectme/disconnect-tracking-protection";
    license = licenses.cc-by-nc-sa-40;
    platforms = platforms.all;
  };
}

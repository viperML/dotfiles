{
  stdenv,
  fetchFromGitHub,
  python3,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "disconnect-tracking-protection";
  version = "unstable-2022-02-24";

  src = fetchFromGitHub {
    repo = "disconnect-tracking-protection";
    owner = "disconnectme";
    rev = "3cc4fca2946654d6a0987f3a1316d80069cce521";
    sha256 = "1c5a3qmsvgc587b2lqfnyfh0pxnr9fk72npkav28nlk5wawq926b";
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

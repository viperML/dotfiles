{
  stdenv,
  fetchFromGitHub,
  python3,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "disconnect-tracking-protection";
  version = "unstable-2022-02-21";

  src = fetchFromGitHub {
    repo = "disconnect-tracking-protection";
    owner = "disconnectme";
    rev = "00a0f9cf520c6b80503b152120af6e33731b4707";
    sha256 = "18nn0rgyg9s6ra0a94vk4qbm2i11g436m4s46pby12xi0wcr8nrr";
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

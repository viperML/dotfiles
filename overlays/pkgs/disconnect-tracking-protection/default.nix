{ stdenv
, fetchFromGitHub
, python3
, lib
}:
stdenv.mkDerivation rec {
  pname = "disconnect-tracking-protection";
  version = "unstable-2022-02-01";

  src = fetchFromGitHub {
    repo = "disconnect-tracking-protection";
    owner = "disconnectme";
    rev = "dab5b07e1a8b961cb2475cc7d66fc505bccbbc3b";
    sha256 = "09gwpfzg6qkkwri1sr9ismzs36lnv9as3p76asr7gv8y6zi2p8dl";
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

  meta =
    with lib; {
      description = "Tracking protection lists and services";
      homepage = "https://github.com/disconnectme/disconnect-tracking-protection";
      license = licenses.cc-by-nc-sa-40;
      platforms = platforms.all;
    };
}

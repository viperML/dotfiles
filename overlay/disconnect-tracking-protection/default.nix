{ stdenv, fetchFromGitHub, python310, writeTextFile }:

stdenv.mkDerivation rec {
  pname = "disconnect-tracking-protection";
  version = "20220112";

  src = fetchFromGitHub {
    repo = pname;
    owner = "disconnectme";
    rev = "e8e755f151af42e7a8884c52f4db4879579f5b30";
    sha256 = "0f06cc9c6g0pw63lnaydrqkpqgms0sdi6zl0iq6dsih7l750hv0h";
  };

  buildInputs = [
    python310
  ];

  buildPhase = let
    parse_hosts = writeTextFile {
      name = "parse_hosts";
      text = "${builtins.readFile ./parse_hosts.py}";
    };
  in ''
    mkdir -p $out
    ${python310}/bin/python ${parse_hosts} -f $src/services.json -o $out/hosts
  '';

  installPhase = ''
    cp $src/services.json $out
    cp $src/entities.json $out
  '';
}

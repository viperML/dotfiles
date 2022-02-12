{ stdenv
, fetchFromGitHub
, lib
}:
stdenv.mkDerivation {
  pname = "vlmcsd";
  version = "unstable-2020-05-19";

  src = fetchFromGitHub {
    owner = "Wind4";
    repo = "vlmcsd";
    rev = "65228e5c7916acd947ffb53be18abadafbc1be56";
    sha256 = "19qfw4l4b5vi03vmv9g5i7j32nifvz8sfada04mxqkrqdqxarb1q";
  };

  installPhase = ''
    install -Dm755 ./bin/vlmcsd $out/bin/vlmcsd
    install -Dm755 ./bin/vlmcs $out/bin/vlmcs
  '';

  meta =
    with lib; {
      description = "KMS Emulator written in C";
      homepage = "https://github.com/Wind4/vlmcsd";
      platforms = platforms.all;
    };
}

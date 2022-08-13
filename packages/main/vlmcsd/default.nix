{
  stdenv,
  fetchFromGitHub,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "vlmcsd";
  version = "2020-05-19";

  src = fetchFromGitHub {
    owner = "Wind4";
    repo = "vlmcsd";
    rev = "65228e5c7916acd947ffb53be18abadafbc1be56";
    sha256 = "19qfw4l4b5vi03vmv9g5i7j32nifvz8sfada04mxqkrqdqxarb1q";
  };

  installPhase = ''
    runHook preInstall
    install -Dm555 ./bin/vlmcsd $out/bin/vlmcsd
    install -Dm555 ./bin/vlmcs $out/bin/vlmcs
    runHook postInstall
  '';

  meta = with lib; {
    description = "KMS Emulator written in C";
    inherit (src.meta) homepage;
    platforms = platforms.all;
  };
}

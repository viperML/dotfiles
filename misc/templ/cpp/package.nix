{
  stdenv,
  cmake,
  lib,
}:
stdenv.mkDerivation {
  name = "PNAME";

  src = lib.cleanSource ./.;

  nativeBuildInputs = [
    cmake
  ];
}

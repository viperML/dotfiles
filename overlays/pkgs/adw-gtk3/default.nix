{
  stdenv,
  lib,
  fetchFromGitHub,
  sassc,
  meson,
  ninja,
}:
stdenv.mkDerivation {
  pname = "adw-gtk3";
  version = "unstable-2022-03-11";
  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "adw-gtk3";
    rev = "1d062d51adade942443904e903ef4c21074681c8";
    sha256 = "sha256-SU9BcEBZ+fT1l6D1Bz5bqycjXNc+AlZR2naq09pMBTM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  #
  ninja,
  meson,
  pkg-config,
  cmake,
  #
  wlroots_0_14,
  tomlc99,
}:
stdenv.mkDerivation {
  pname = "vivarium";
  version = "unstable-2022-03-02";

  src = fetchFromGitHub {
    owner = "inclement";
    repo = "vivarium";
    rev = "9ccdc18db6485d15275c4ae901c7fbf90e922964";
    sha256 = "069pyfzpnnfy12d7w65ypjqnq3jvzd6f9rs1h3adp3zpvj6s6krk";
  };

  nativeBuildInputs = [
    ninja
    meson
    pkg-config
    cmake
  ];

  buildInputs = [
    wlroots_0_14
    tomlc99
  ];
}

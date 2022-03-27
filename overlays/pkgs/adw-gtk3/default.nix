{
  stdenv,
  lib,
  fetchFromGitHub,
  sassc,
  meson,
  ninja,
}:
stdenv.mkDerivation rec {
  pname = "adw-gtk3";
  version = "unstable-2022-03-23";
  src = fetchFromGitHub {
    repo = pname;
    owner = "lassekongo83";
    rev = "ecdcebb362d9ad38f4fc60eb338f58a3281bc6b0";
    sha256 = "sha256-cGICzvhzkRiYXC47mmwmh/kpbplV1CKjgVXanL5ih3E=";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];
}

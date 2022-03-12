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
    sha256 = "049lvc2qqqwdpmd4g7ysn98xixqk4mniq91g3wicla0p6hqm13pz";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];
}

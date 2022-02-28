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
  version = "unstable-2022-02-28";
  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "adw-gtk3";
    rev = "a1e1867e82c0a2d851ef7948bc3c7ac877a2ae99";
    sha256 = "1c0a519ilpzmz44n5ng2k60kp0wdzbv22z07sf23ic757h9ird46";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];
}

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
  version = "unstable-2022-03-16";
  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "adw-gtk3";
    rev = "209411eef1a1523e5b812abe3fd257e3aa73ec88";
    sha256 = "sha256-HiNaf8Z0MdkRMNglrhTrKuF5RzkNP6tp2DWhCTZ/sQg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];
}

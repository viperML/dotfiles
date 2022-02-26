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
  version = "unstable-2022-02-25";
  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "adw-gtk3";
    rev = "d7f764394bc755d20ab93af86155844ef98d58ac";
    sha256 = "0n0z2jm91qz10znfa794zlvsbqdh8sb1adypskbz1l0w76syjld5";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];
}

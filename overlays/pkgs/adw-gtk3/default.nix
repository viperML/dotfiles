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
  version = "unstable-2022-02-23";
  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "adw-gtk3";
    rev = "e65f7b1b8d24745aa586067f68ad14e56eca524b";
    sha256 = "12l3j5vzj088z85sa1kxwqp71gsyghv81q2k4nzw8i4bxkbr9si9";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];
}

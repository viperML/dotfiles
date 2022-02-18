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
  version = "unstable-2022-02-18";
  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "adw-gtk3";
    rev = "4132049e3f456486e288befa18449255d8080371";
    sha256 = "sha256-0GSIWMaDX1e99hhTC+nSOJ8HHHcxDaGN8p5rLqcBr6o=";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];
}

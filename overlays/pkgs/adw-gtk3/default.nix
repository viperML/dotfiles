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
  version = "unstable-2022-03-05";
  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "adw-gtk3";
    rev = "4e7b6933faa35e541d3b8aa29bf06dff3389827c";
    sha256 = "1j46vnd91q6586fhpxj9hwa5ba6rrckf2a2zk9h7zjjlsrxgjj9p";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];
}

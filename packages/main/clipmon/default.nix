{ pname
, date
, src
, cargoLock
, #
  rustPlatform
, makeWrapper
, lib
, wayland
,
}:
let
  propagatedBuildInputs = [
    wayland
  ];
in
rustPlatform.buildRustPackage {
  inherit pname src propagatedBuildInputs;
  version = date;
  cargoLock = cargoLock."Cargo.lock";

  nativeBuildInputs = [
    makeWrapper
  ];

  preFixup = ''
    wrapProgram $out/bin/clipmon \
      --set-default LD_LIBRARY_PATH ${lib.makeLibraryPath propagatedBuildInputs}
  '';
}

inputs @ {
  pname,
  version,
  src,
  #
  rustPlatform,
  makeWrapper,
  lib,
  wayland,
}:
rustPlatform.buildRustPackage rec {
  inherit pname version src;
  cargoLock = inputs.cargoLock."Cargo.lock";

  nativeBuildInputs = [
    makeWrapper
  ];

  propagatedBuildInputs = [
    wayland
  ];

  preFixup = ''
    wrapProgram $out/bin/clipmon \
      --set-default LD_LIBRARY_PATH ${lib.makeLibraryPath propagatedBuildInputs}
  '';
}

{
  pname,
  date,
  src,
  cargoLock,
  #
  rustPlatform,
  makeWrapper,
  lib,
  wayland,
  pkg-config,
}: let
  # propagatedBuildInputs = [
  #   wayland
  # ];
in
  rustPlatform.buildRustPackage {
    inherit pname  src;
    version = date;
    cargoLock = cargoLock."Cargo.lock";

    nativeBuildInputs = [
      makeWrapper
      pkg-config
    ];

    buildInputs = [
      wayland
    ];


    # preFixup = ''
    #   wrapProgram $out/bin/clipmon \
    #     --set-default LD_LIBRARY_PATH ${lib.makeLibraryPath propagatedBuildInputs}
    # '';
  }

{
  callPackages,
  rustPlatform,
  makeWrapper,
  wayland,
  pkg-config,
}: let
  nv = (callPackages ./generated.nix {}).wl-clip-persist;
in
  rustPlatform.buildRustPackage {
    inherit (nv) pname src;
    version = nv.date;
    cargoLock = nv.cargoLock."Cargo.lock";

    nativeBuildInputs = [makeWrapper pkg-config];

    buildInputs = [wayland];
  }

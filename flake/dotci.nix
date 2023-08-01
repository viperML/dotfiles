{
  rustPlatform,
  src,
}:
rustPlatform.buildRustPackage {
  name = "dotci";
  cargoLock.lockFile = ./Cargo.lock;
  inherit src;
}

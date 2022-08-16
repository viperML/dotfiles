{
  pname,
  version,
  src,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  inherit pname version src;
  __nocachix = true;
  cargoSha256 = "sha256-GIbCYa/RtcOhiyNMYd4g/jFKm42NLh1ZrXKGPSZ2vD8=";
}

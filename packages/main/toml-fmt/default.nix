{
  pname,
  src,
  date,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  inherit pname src;
  version = date;
  __nocachix = true;
  cargoSha256 = "sha256-GIbCYa/RtcOhiyNMYd4g/jFKm42NLh1ZrXKGPSZ2vD8=";
}

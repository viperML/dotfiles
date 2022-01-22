{ stdenv, rustPlatform, lib, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "treefetch";
  version = "20221218";

  src = fetchFromGitHub {
    owner = "angelofallars";
    repo = pname;
    rev = "0cacix1xl8jv8sshx1zg96r0pbh9b8ai25gqw9lkq40q446yxl0j";
    sha256 = "186fg98rdn34pv0c7yi2paskqjcgda2p35j5nx30882rl1f1hnjl";
  };

  cargoSha256 = "sha256-b1NerWHUwCR4xaIhaZumzvDPV75puViciD+Oy4zKZcw=";
}

# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  xdg-ninja = {
    pname = "xdg-ninja";
    version = "72a7791ef160d4627c9951d84559af09061f7a0d";
    src = fetchFromGitHub ({
      owner = "b3nj5m1n";
      repo = "xdg-ninja";
      rev = "72a7791ef160d4627c9951d84559af09061f7a0d";
      fetchSubmodules = false;
      sha256 = "sha256-jY36gNChPhcTVYyXE0Ss4cuBrKwMYqrJ3RsKg9UlREo=";
    });
    date = "2023-02-27";
  };
}

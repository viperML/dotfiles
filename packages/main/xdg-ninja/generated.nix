# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  xdg-ninja = {
    pname = "xdg-ninja";
    version = "14c0be0c10aa75d41eb7a5630ecc16d4669440de";
    src = fetchFromGitHub ({
      owner = "b3nj5m1n";
      repo = "xdg-ninja";
      rev = "14c0be0c10aa75d41eb7a5630ecc16d4669440de";
      fetchSubmodules = false;
      sha256 = "sha256-G2kvVjGz9ZSICMiWvqSK+anlolmlBsY6+ySBLoBaAjE=";
    });
    date = "2022-10-14";
  };
}

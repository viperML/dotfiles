# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  bismuth = {
    pname = "bismuth";
    version = "042123bdd2d3654512d371e3dc690efae5bcefd9";
    src = fetchFromGitHub ({
      owner = "Bismuth-Forge";
      repo = "bismuth";
      rev = "042123bdd2d3654512d371e3dc690efae5bcefd9";
      fetchSubmodules = false;
      sha256 = "sha256-IWwFsYqoqW3924+pf8L+acIt31aU/mhqakXbT9Q4Bqw=";
    });
  };
}

# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  swayfx = {
    pname = "swayfx";
    version = "4d1af6500491bdc301b590916fd04f5d8ec6a2c2";
    src = fetchFromGitHub ({
      owner = "WillPower3309";
      repo = "swayfx";
      rev = "4d1af6500491bdc301b590916fd04f5d8ec6a2c2";
      fetchSubmodules = false;
      sha256 = "sha256-N9DbdFj4iehocp/Ysb29+UTbUGEdwjZNWGbeaFL9hQ4=";
    });
    date = "2023-03-26";
  };
}

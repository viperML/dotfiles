# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  sierrabreezeenhanced = {
    pname = "sierrabreezeenhanced";
    version = "c81306b5b02622451037ecd18c135ae9c857797d";
    src = fetchFromGitHub {
      owner = "kupiqu";
      repo = "SierraBreezeEnhanced";
      rev = "c81306b5b02622451037ecd18c135ae9c857797d";
      fetchSubmodules = false;
      sha256 = "sha256-xTHqqTowUom+ovD4sFMb+NY2FuaYXHewJuIQAb/uuY8=";
    };
    date = "2024-03-05";
  };
}

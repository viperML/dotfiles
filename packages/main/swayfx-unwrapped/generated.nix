# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  swayfx = {
    pname = "swayfx";
    version = "3efd3b558fe49bc7a7f3c30c19783e3fe5efeb24";
    src = fetchFromGitHub ({
      owner = "WillPower3309";
      repo = "swayfx";
      rev = "3efd3b558fe49bc7a7f3c30c19783e3fe5efeb24";
      fetchSubmodules = false;
      sha256 = "sha256-I67aG46d76Hdnu8YX9N5awaK37WcmLGxRA5x1tNw4KM=";
    });
    date = "2023-02-01";
  };
}

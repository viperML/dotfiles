# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  xdg-ninja = {
    pname = "xdg-ninja";
    version = "66025879cd8d797841af326ec7a1c5aa496efff0";
    src = fetchFromGitHub {
      owner = "b3nj5m1n";
      repo = "xdg-ninja";
      rev = "66025879cd8d797841af326ec7a1c5aa496efff0";
      fetchSubmodules = false;
      sha256 = "sha256-8WfIZQnL6gBmsPD3xZg7VXlkBhrVcBEWoTkJpgENh68=";
    };
    date = "2024-06-28";
  };
}

# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  kwin-forceblur = {
    pname = "kwin-forceblur";
    version = "1f92ed59d4e445587ad4245f374f90f61850f29f";
    src = fetchFromGitHub ({
      owner = "esjeon";
      repo = "kwin-forceblur";
      rev = "1f92ed59d4e445587ad4245f374f90f61850f29f";
      fetchSubmodules = false;
      sha256 = "sha256-oYQt6w/jfvTTeZ1F5/aVT21QMS53JHgH0y1GskGnYOo=";
    });
    date = "2022-02-13";
  };
}

# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  awesome = {
    pname = "awesome";
    version = "f3cf88593c15a233092972c997528297e546f325";
    src = fetchFromGitHub ({
      owner = "awesomeWM";
      repo = "awesome";
      rev = "f3cf88593c15a233092972c997528297e546f325";
      fetchSubmodules = false;
      sha256 = "sha256-U/+aLp4fHUTULk+EqP2vtzeVD5FDcUPH53owQ835G7k=";
    });
  };
}

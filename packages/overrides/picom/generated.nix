# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  picom = {
    pname = "picom";
    version = "8a373c38a631e0344c38d3b19ab673aacfbaf1f5";
    src = fetchFromGitHub ({
      owner = "yshui";
      repo = "picom";
      rev = "8a373c38a631e0344c38d3b19ab673aacfbaf1f5";
      fetchSubmodules = false;
      sha256 = "sha256-mKtop5/80YIAZqogshk5Tm9PR+93rLWSh8hqtNFjlPE=";
    });
    date = "2022-10-10";
  };
}

# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  fzf = {
    pname = "fzf";
    version = "v9.5";
    src = fetchFromGitHub ({
      owner = "PatrickF1";
      repo = "fzf.fish";
      rev = "v9.5";
      fetchSubmodules = false;
      sha256 = "sha256-ZdHfIZNCtY36IppnufEIyHr+eqlvsIUOs0kY5I9Df6A=";
    });
  };
}

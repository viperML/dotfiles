# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  nix-index = {
    pname = "nix-index";
    version = "2022-07-17";
    src = fetchurl {
      url = "https://github.com/Mic92/nix-index-database/releases/download/2022-07-17/index-x86_64-linux";
      sha256 = "sha256-wCOH0w6Ximm8YFw4Xd/8w6QA3WmWbwz8xSOndBS7SMU=";
    };
  };
}

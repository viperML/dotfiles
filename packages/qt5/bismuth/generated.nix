# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  bismuth = {
    pname = "bismuth";
    version = "8899c311f90a93ef1baad425ccd5910dc6f771f4";
    src = fetchFromGitHub ({
      owner = "Bismuth-Forge";
      repo = "bismuth";
      rev = "8899c311f90a93ef1baad425ccd5910dc6f771f4";
      fetchSubmodules = false;
      sha256 = "sha256-Txf7OOQwtMr/oJU/J6prZgcQQEtHtUbiJ7sH5VfTuxE=";
    });
    date = "2022-10-20";
  };
}

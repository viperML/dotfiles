# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  sierrabreezeenhanced = {
    pname = "sierrabreezeenhanced";
    version = "e32e43ed79a3ca60e0943a9db4d57757baf47b03";
    src = fetchFromGitHub ({
      owner = "kupiqu";
      repo = "SierraBreezeEnhanced";
      rev = "e32e43ed79a3ca60e0943a9db4d57757baf47b03";
      fetchSubmodules = false;
      sha256 = "sha256-G1Ra7ld34AMPLZM0+3iEJHRFRMHVewZKTTXfmiu7PAk=";
    });
  };
}

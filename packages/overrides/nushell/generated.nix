# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  nushell = {
    pname = "nushell";
    version = "27d798270b2051e850f1b2ee3fa118d9992b8ea4";
    src = fetchFromGitHub ({
      owner = "nushell";
      repo = "nushell";
      rev = "27d798270b2051e850f1b2ee3fa118d9992b8ea4";
      fetchSubmodules = false;
      sha256 = "sha256-nZcqsG8dIsUbO31cCg+xA4KUtr/8d/pUxIJjcetdzmI=";
    });
    cargoLock."Cargo.lock" = {
      lockFile = ./nushell-27d798270b2051e850f1b2ee3fa118d9992b8ea4/Cargo.lock;
      outputHashes = {
        
      };
    };
    date = "2023-02-28";
  };
}

{
  lib,
  inputs,
}: let
  modules = import ./modules.nix lib;
in {
  inherit (modules) exportModulesDir folderToList;
  kde = import ./kde.nix lib;
  patch-nixpkgs = import ./patch-nixpkgs.nix;

  versionGate = pkg: newAttrs: let
    newVersion = newAttrs.version;
    oldVersion = pkg.version;
    newPkg = pkg.overrideAttrs (_: newAttrs);
    result =
      if lib.versionOlder oldVersion newVersion
      then newPkg
      else throw "Package ${pkg.name} has reached the desired version";
  in
    result;





  mkDate = longDate: (lib.concatStringsSep "-" [
    (__substring 0 4 longDate)
    (__substring 4 2 longDate)
    (__substring 6 2 longDate)
  ]);
}

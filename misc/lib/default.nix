{lib, ...}: {
  flake.lib = {
    mkDate = longDate: (lib.concatStringsSep "-" [
      (builtins.substring 0 4 longDate)
      (builtins.substring 4 2 longDate)
      (builtins.substring 6 2 longDate)
    ]);

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

    importFilesToAttrs = basePath: files:
      builtins.listToAttrs (map (name:
        lib.nameValuePair name (let
          file = basePath + "/${name}.nix";
          folder = basePath + "/${name}";
        in
          if builtins.pathExists file
          then file
          else folder))
      files);
  };
}

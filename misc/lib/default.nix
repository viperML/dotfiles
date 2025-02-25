{ lib, ... }:
{
  flake.lib = {
    mkDate =
      longDate:
      (lib.concatStringsSep "-" [
        (builtins.substring 0 4 longDate)
        (builtins.substring 4 2 longDate)
        (builtins.substring 6 2 longDate)
      ]);

    # versionGate = pkg: newAttrs: let
    #   newVersion = newAttrs.version;
    #   oldVersion = pkg.version;
    #   newPkg = pkg.overrideAttrs (_: newAttrs);
    #   result =
    #     if lib.versionOlder oldVersion newVersion
    #     then newPkg
    #     else throw "Package ${pkg.name} has reached the desired version";
    # in
    #   result;

    versionGate =
      newPkg: stablePkg:
      let
        newVersion = lib.getVersion newPkg;
        stableVersion = lib.getVersion stablePkg;
      in
      if builtins.compareVersions newVersion stableVersion >= 0 then
        newPkg
      else
        lib.warn "Package ${lib.getName newPkg} reached version ${newVersion} at stable" stablePkg;

    importFilesToAttrs =
      basePath: files:
      builtins.listToAttrs (
        map (
          name:
          lib.nameValuePair name (
            let
              file = basePath + "/${name}.nix";
              folder = basePath + "/${name}";
            in
            if builtins.pathExists file then file else folder
          )
        ) files
      );

    dirToAttrs =
      dir:
      lib.mapAttrs' (name: value: lib.nameValuePair (lib.removeSuffix ".nix" name) (dir + "/${name}")) (
        builtins.readDir dir
      );
  };
}

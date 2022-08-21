{
  inputs,
  self,
  config,
  withSystem,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
in {
  flake.lib = {
    mkSystem = import ./mkSystem {inherit lib inputs;};

    mkDate = longDate: (lib.concatStringsSep "-" [
      (__substring 0 4 longDate)
      (__substring 4 2 longDate)
      (__substring 6 2 longDate)
    ]);

    inherit (import ./modules.nix lib) exportModulesDir;

    /*
    Takes a flake-defined `inputs` and a system, and returns an attribute set
    containing the extracted packages or legacyPackages

    Example:
      mkPackages inputs "x86_64-linux"
      => { input1 = { pkg1 = {...}; pkg2 = {...}; }; input2 = {...}; }
    */

    mkPackages = inputs: system:
      __mapAttrs (name: value: let
        legacyPackages = value.legacyPackages.${system} or {};
        packages = value.packages.${system} or {};
      in
        legacyPackages // packages)
      inputs;

    joinSpecialisations = specs: {
      nixosModules = lib.flatten (map (s: s.nixosModules or []) specs);
      homeModules = lib.flatten (map (s: s.homeModules or []) specs);
      name = lib.concatMapStringsSep "-" (s: s.name) specs;

      default = builtins.foldl' (x: y: x || y) false (lib.flatten (map (s: s.default or false) specs));
    };

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
  };

  flake.libFor = lib.genAttrs config.systems (system: withSystem system (ctx: import ./perSystem.nix ctx.pkgs));
}

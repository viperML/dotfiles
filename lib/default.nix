{ lib }:
let
  genAttrs' = func: values: builtins.listToAttrs (map func values);

  removeSuffix = suffix: str: let
    sufLen = builtins.stringLength suffix;
    sLen = builtins.stringLength str;
  in
    if sufLen <= sLen && suffix == builtins.substring (sLen - sufLen) sufLen str
    then builtins.substring 0 (sLen - sufLen) str
    else str;

  exportModules = genAttrs' (
    arg: {
      name = removeSuffix ".nix" (baseNameOf arg);
      value = import arg;
    }
  );

  exportModulesDir = dir: (exportModules (lib.mapAttrsToList (name: value: dir + "/${name}") (builtins.readDir dir)));

  eachSystem = systems: f: let
    # Taken from <nixpkgs/lib/attrsets.nix>
    isDerivation = x: builtins.isAttrs x && x ? type && x.type == "derivation";

    # Used to match Hydra's convention of how to define jobs. Basically transforms
    #
    #     hydraJobs = {
    #       hello = <derivation>;
    #       haskellPackages.aeson = <derivation>;
    #     }
    #
    # to
    #
    #     hydraJobs = {
    #       hello.x86_64-linux = <derivation>;
    #       haskellPackages.aeson.x86_64-linux = <derivation>;
    #     }
    #
    # if the given flake does `eachSystem [ "x86_64-linux" ] { ... }`.
    pushDownSystem = system: merged:
      builtins.mapAttrs
      (
        name: value:
          if !(builtins.isAttrs value)
          then value
          else if isDerivation value
          then (merged.${name} or {}) // { ${system} = value; }
          else pushDownSystem system (merged.${name} or {}) value
      );

    # Merge together the outputs for all systems.
    op = attrs: system: let
      ret = f system;
      op = attrs: key: let
        appendSystem = key: system: ret:
          if key == "hydraJobs"
          then (pushDownSystem system (attrs.hydraJobs or {}) ret.hydraJobs)
          else { ${system} = ret.${key}; };
      in
        attrs
        // {
          ${key} =
            (attrs.${key} or {})
            // (appendSystem key system ret);
        };
    in
      builtins.foldl' op attrs (builtins.attrNames ret);
  in
    builtins.foldl' op {} systems;
in {
  inherit removeSuffix exportModules exportModulesDir eachSystem;
}

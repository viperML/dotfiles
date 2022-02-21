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
in {
  inherit exportModules exportModulesDir;
}

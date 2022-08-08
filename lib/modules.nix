/*
exportModulesDir: creates and attrSet from a folder
The folder may contain .nix files or folders with default.nix,
which in turn contain lambdas (such as nixos modules or overlays).

As such, the result of running it on this repo:

nix-repl> exportModulesDir ./modules/nixos
{
  channels-to-flakes = «lambda @ ... »;
  common = «lambda @ ... »;
  # ...
}
*/
lib:
with lib; let
  genAttrs' = func: values: listToAttrs (map func values);

  removeSuffix = suffix: str: let
    sufLen = builtins.stringLength suffix;
    sLen = builtins.stringLength str;
  in
    if sufLen <= sLen && suffix == builtins.substring (sLen - sufLen) sufLen str
    then builtins.substring 0 (sLen - sufLen) str
    else str;

  exportModules = genAttrs' (arg: {
    name = removeSuffix ".nix" (baseNameOf arg);
    value = import arg;
  });

  exportModulesDir = dir: (exportModules (mapAttrsToList (name: value: dir + "/${name}") (builtins.readDir dir)));

  folderToList = folder: (mapAttrsToList (key: value: folder + "/${key}") (builtins.readDir folder));
in {
  inherit exportModulesDir folderToList;
}

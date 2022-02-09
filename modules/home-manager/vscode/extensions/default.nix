{ file ? ./extension-list.nix
, pkgs ? import <nixpkgs> { }
, lib ? pkgs.lib
}:
# Return a list with vscode extensions
# Split into extensions available in nixpkgs (that can be pulled from binary cache)
# and extensions to build ourselves
let
  extension-list = (import file).extensions;

  in_nixpkgs = ext: (
    if builtins.hasAttr (lib.toLower ext.publisher) pkgs.vscode-extensions
    then
      if
        builtins.hasAttr (lib.toLower ext.name)
        pkgs.vscode-extensions."${lib.toLower ext.publisher}"
      then true
      else false
    else false
  );

  exts-built = pkgs.vscode-utils.extensionsFromVscodeMarketplace (builtins.filter (n: !(in_nixpkgs n)) extension-list);

  exts-in-nixpkgs = map (
    v: pkgs
    .vscode-extensions
    ."${lib.toLower v.publisher}"
    ."${lib.toLower v.name}"
  ) (builtins.filter (n: in_nixpkgs n) extension-list);
in
(exts-built ++ exts-in-nixpkgs)

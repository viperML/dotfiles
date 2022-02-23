{
  pkgs,
  lib ? pkgs.lib,
}:
# updateScript
let
  inherit (import ./deps.nix) extensions;

  /*
   Takes a extension (attribute set from ./deps.nix)
   return true or false if it is packaged in nixpkgs(pkgs.vscode-extensions)
   */
  in_nixpkgs = ext: (
    if builtins.hasAttr (lib.toLower ext.publisher) pkgs.vscode-extensions
    then
      builtins.hasAttr (lib.toLower ext.name)
      pkgs.vscode-extensions."${lib.toLower ext.publisher}"
    else false
  );

  /*
   Filter deps.nix
   Returns a list with derivations for extensions not in nixpkgs
   */
  extensions-built = pkgs.vscode-utils.extensionsFromVscodeMarketplace (builtins.filter (n: !(in_nixpkgs n)) extensions);

  /*
   Filter deps.nix
   Returns a list with the derivation for the extensions that are in nixpkgs
   */
  extensions-in-nixpkgs = map (
    v:
      pkgs
      .vscode-extensions
      ."${lib.toLower v.publisher}"
      ."${lib.toLower v.name}"
  ) (builtins.filter in_nixpkgs extensions);
in
  extensions-built ++ extensions-in-nixpkgs

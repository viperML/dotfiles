/*
 Automatically create packages for every folder
 */
final: prev: let
  inherit
    (builtins)
    listToAttrs
    concatMap
    attrNames
    readDir
    mapAttrs
    ;

  inherit
    (prev.lib)
    nameValuePair
    filterAttrs
    ;

  /*
   Collect package names from folder to a set.
   The value of each key is garbage, { package = "directory"}
   But don't transform to a list as it will be transformed to a set afterwards
   */
  pkgs-names = filterAttrs (name: value: value == "directory") (readDir ./.);

  /*
   Given the set with package names { foo = whatever; bar = whatever2; }, create a set such as:
   {
     foo = prev.callPackage ./foo {};
     bar = prev.callPackage ./bar {};
   }
   */
  overlay = mapAttrs (name: _: (prev.callPackage (./. + "/${name}") {})) pkgs-names;
in
  overlay

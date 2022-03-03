final: prev: let
  inherit
    (builtins)
    listToAttrs
    concatMap
    attrNames
    readDir
    mapAttrs
    ;

  # <nixpkgs>/lib/attrsets.nix
  nameValuePair = name: value: {inherit name value;};
  filterAttrs = pred: set:
    listToAttrs (concatMap (
      name: let
        v = set.${name};
      in
        if pred name v
        then [(nameValuePair name v)]
        else []
    ) (attrNames set));

  /*
   Collect package names from folder to a set.
   The value of each key is garbage, { package = "directory"}
   But don't transform to a list as it will be transformed to a set afterwards
   */
  pkgs-names = filterAttrs (name: value: value == "directory") (readDir ./.);

  /*
   Given the set with package names, create a set such as:
   {
     foo = prev.callPackage ./foo {};
     bar = prev.callPackage ./bar {};
   }
   */
  overlay = mapAttrs (name: _: (prev.callPackage (./. + "/${name}") {})) pkgs-names;
in
  overlay

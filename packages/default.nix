pkgs:
with builtins;
with pkgs.lib; let
  recursiveMerge = attrList: let
    f = attrPath:
      zipAttrsWith (
        n: values:
          if tail values == []
          then head values
          else if all isList values
          then unique (concatLists values)
          else if all isAttrs values
          then f (attrPath ++ [n]) values
          else last values
      );
  in
    f [] attrList;

  # pnames.main = filterAttrs (n: v: v == "directory") (readDir ./main);
  # pnames.libsForQt5 = filterAttrs (n: v: v == "directory") (readDir ./libsForQt5);

  pnames = listToAttrs (map (
      name:
        nameValuePair
        name
        (filterAttrs (_: v: v == "directory") (readDir (./. + "/${name}")))
    ) [
      "fonts"
      "main"
      "libsForQt5"
    ]);

  packages = {
    main = mapAttrs (name: _: pkgs.callPackage (./main + "/${name}") {}) pnames.main;
    libsForQt5 = mapAttrs (name: _: pkgs.libsForQt5.callPackage (./libsForQt5 + "/${name}") {}) pnames.libsForQt5;
    fonts = mapAttrs (name: _: pkgs.callPackage (./fonts + "/${name}") {}) pnames.fonts;
  };
in
  recursiveMerge (attrValues packages)

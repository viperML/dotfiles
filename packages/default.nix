pkgs: inputs:
with pkgs.lib;
with builtins; let
  inherit (pkgs) system;

  callPackageOverrides = {
    "libsForQt5" = pkgs.libsForQt5.callPackage;
  };

  overrides = {
    nix-dram = {
      nix-dram = inputs.nix-dram.packages.${system}.nix-dram;
    };
  };

  folders = attrNames (filterAttrs (n: v: v == "directory") (readDir ./.));

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

  pkgs_unmerged = map (f: let
    subfolders = readDir (./. + "/${f}");
    result =
      mapAttrs (
        sf: _: (callPackageOverrides.${f} or pkgs.callPackage) (./. + "/${f}/${sf}") (overrides.${sf} or {})
      )
      subfolders;
  in
    result)
  folders;
in
  recursiveMerge pkgs_unmerged

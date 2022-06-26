pkgs: inputs:
with pkgs.lib;
with builtins; let
  inherit (pkgs) system;

  callPackageFor = {
    "qt5" = pkgs.libsForQt5.callPackage;
    "python" = pkgs.python3.pkgs.callPackage;
  };

  overridesFor = {
    vshell = {
      inherit
        (inputs.self.packages.${system})
        any-nix-shell
        nix-index
        ;
      inherit (inputs.nix-autobahn.packages.${system}) nix-autobahn;
    };
    nix-prefetch = {
      nix = inputs.self.packages.${system}.nix;
      nixpkgs = inputs.nixpkgs;
    };
    nix-update = {
      nix = inputs.self.packages.${system}.nix;
      nix-prefetch = inputs.self.packages.${system}.nix;
    };
    iosevka = {
      nix-std = inputs.nix-std;
    };
  };

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

  folders = filterAttrs (n: v: v == "directory") (readDir ./.);

  packagesUnmerged = mapAttrs (f: _:
    mapAttrs
    (
      pname: __:
        callPackageFor.${f} or pkgs.callPackage (./. + "/${f}/${pname}") (overridesFor.${pname} or {})
    ) (readDir (./. + "/${f}")))
  folders;
in
  recursiveMerge (attrValues packagesUnmerged)

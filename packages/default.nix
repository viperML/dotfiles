pkgs: inputs:
with pkgs.lib;
with builtins; let
  inherit (pkgs) system;
  inherit (inputs.self.lib) mkDate;

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
    nix-index = {
      database = inputs.nix-index-database.legacyPackages.${system}.database;
      databaseDate = mkDate inputs.nix-index-database.lastModifiedDate;
    };
    supernix = {
      nix = inputs.nix.packages.${system}.nix;
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

  myCallPackage = {
    pname,
    folder,
  }: let
    basePath = ./${folder}/${pname};
    callPackage = callPackageFor.${folder} or pkgs.callPackage;

    nvfOverrides =
      if hasAttr "generated.nix" (readDir basePath) && hasAttr "nvfetcher.toml" (readDir basePath)
      then (pkgs.callPackage "${basePath}/generated.nix" {}).${pname}
      else if hasAttr "generated.nix" (readDir basePath) && hasAttr "sources.toml" (readDir basePath)
      then {sources = pkgs.callPackage "${basePath}/generated.nix" {};}
      else {};

    overrides = (overridesFor.${pname} or {}) // nvfOverrides;
  in
    callPackage basePath overrides;

  folders = filterAttrs (n: v: v == "directory") (readDir ./.);

  packagesUnmerged = mapAttrs (folder: _: mapAttrs (pname: __: myCallPackage {inherit pname folder;}) (readDir ./${folder})) folders;
in
  builtins.removeAttrs (recursiveMerge (attrValues packagesUnmerged)) (
    if system == "aarch64-linux"
    then [
      "nix-index"
      "vshell"
    ]
    else []
  )

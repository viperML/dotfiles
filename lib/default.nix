{lib}: let
  inherit
    (builtins)
    listToAttrs
    concatMap
    attrNames
    mapAttrs
    map
    hasAttr
    ;
  inherit
    (lib)
    mapAttrsToList
    mapAttrs'
    nameValuePair
    filterAttrs
    ;

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

  mkSpecialisedSystem = {
    system,
    pkgs,
    lib,
    specialArgs,
    specialisations,
  }: let
    # Create a system out of the base specialisation + any spec
    base-spec = specialisations.base;
    specs = filterAttrs (n: v: n != "base") specialisations;

    modules =
      base-spec.nixosModules
      ++ [
        {
          home-manager.sharedModules = base-spec.homeModules;
          specialisation =
            mapAttrs (name: value: {
              inheritParentConfig = true;
              configuration = {
                imports = value.nixosModules;
                boot.loader.grub.configurationName = "${name}";
                home-manager.sharedModules = value.homeModules;
              };
            })
            specs;
        }
      ];

    # Insert `packages.<inputs>` in the argset, that contains legacyPackages or packages
    # So a module can use `packages.nixpkgs-master.vscode` instead of `inputs.nixpkgs-master.legacyPackages.${system}.vscode`
    packages =
      (mapAttrs
        (n: v: v.legacyPackages.${system}) (filterAttrs (n: v: hasAttr "legacyPackages" v) specialArgs.inputs))
      // (mapAttrs
        (n: v: v.packages.${system}) (filterAttrs (n: v: hasAttr "packages" v) specialArgs.inputs));

    specialArgs' =
      specialArgs
      // {
        inherit packages;
      };
  in
    lib.nixosSystem {
      inherit system pkgs modules;
      specialArgs = specialArgs';
    };
in {
  inherit exportModules exportModulesDir folderToList mkSpecialisedSystem;
  kde = import ./kde.nix {inherit lib;};
}

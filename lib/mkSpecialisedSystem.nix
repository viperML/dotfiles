/*
 Wrapper around nixpkgs.lib.nixosSystem
 Arguments:
 - system: passed through
 - lib: passed through
 - pkgs: passed through
 - specialArgs: passed through
   Requires flake's inputs to generate `packages` in the argset
 - specialisations: attrSet such as:
   {
     "base" = {
       nixosModules = [ module1 module2 ];
       homeModules = [ moduleA moduleB ];
     };
     "sway" = {
       nixosModules = [ swayModule1 swayModule2 ];
       homeModules = [ swayModule1 swayModule2 ];
     };
   }
   This would be used to create a NixOS system that has all the modules in base,
   and a spesialisation "sway" that adds some modules on top.
 */
lib:
with lib; let
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
in
  mkSpecialisedSystem
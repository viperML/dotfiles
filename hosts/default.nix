{
  inputs,
  config,
  withSystem,
  ...
}: {
  imports = [
    ./hermes
    ./fatalis
  ];

  _module.args.mkNixos = system: extraModules: let
    specialArgs = {
      inherit inputs;
      packages = inputs.nix-common.lib.mkPackages system inputs;
    };
  in
    inputs.nixpkgs.lib.nixosSystem {
      inherit specialArgs;

      modules = [
        #-- Core
        inputs.nixpkgs.nixosModules.readOnlyPkgs
        {nixpkgs.pkgs = (withSystem system ({pkgs, ...}: pkgs));}

        config.flake.nixosModules.common
        inputs.nix-common.nixosModules.default

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.sharedModules = [
            config.flake.homeModules.common
            inputs.nix-common.homeModules.default
          ];
          home-manager.extraSpecialArgs = specialArgs;
        }

        inputs.nh.nixosModules.default
      ] ++ extraModules;
    };
}

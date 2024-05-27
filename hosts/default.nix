{
  inputs,
  config,
  withSystem,
  ...
}: {
  imports = [./hermes ./fatalis ./zorah];

  _module.args.mkNixos = system: extraModules: let
    specialArgs =
      withSystem system
      ({
        inputs',
        self',
        ...
      }: {inherit self' inputs' inputs;});
  in
    inputs.nixpkgs.lib.nixosSystem {
      inherit specialArgs;

      modules =
        [
          #-- Core
          inputs.nixpkgs.nixosModules.readOnlyPkgs
          {nixpkgs.pkgs = withSystem system ({pkgs, ...}: pkgs);}

          config.flake.nixosModules.common
          inputs.nix-common.nixosModules.default

          inputs.noshell.nixosModules.default
          {programs.noshell.enable = true;}

          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.sharedModules = [
              config.flake.homeModules.common
              inputs.nix-common.homeModules.default
            ];
            home-manager.extraSpecialArgs = specialArgs;
          }
        ]
        ++ extraModules;
    };
}

{ inputs
, withSystem
, config
, lib
, ...
}:
let
  mkHome = system: extraModules:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = withSystem system ({ pkgs, ... }: pkgs);
      modules =
        [
          inputs.nix-common.homeModules.default
          ./home.nix
          config.flake.homeModules.common
        ]
        ++ extraModules;
      extraSpecialArgs = {
        inherit inputs;
        packages = inputs.nix-common.lib.mkPackages system inputs;
      };
    };
in
{
  flake.homeConfigurations = {
    "ayats" = mkHome "x86_64-linux" [ ];
    "ayats@shiva" = mkHome "aarch64-linux" [
      (./. + "/@shiva.nix")
    ];
  };
}

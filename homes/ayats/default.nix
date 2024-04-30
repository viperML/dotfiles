{
  inputs,
  withSystem,
  config,
  ...
}:
let
  mkHome =
    system: extraModules:
    withSystem system (
      {
        pkgs,
        self',
        inputs',
        ...
      }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          inputs.nix-common.homeModules.default
          ./home.nix
          config.flake.homeModules.common
        ] ++ extraModules;
        extraSpecialArgs = {
          inherit self' inputs' inputs;
        };
      }
    );
in
{
  flake.homeConfigurations = {
    "ayats" = mkHome "x86_64-linux" [ ];
    "ayats@shiva" = mkHome "aarch64-linux" [ (./. + "/@shiva.nix") ];
  };
}

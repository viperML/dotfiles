{
  inputs,
  withSystem,
  config,
  ...
}: let
  mkHome = system: extraModules:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = withSystem system ({pkgs, ...}: pkgs);
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
in {
  flake.homeConfigurations = {
    "ayats" = mkHome "x86_64-linux" [];
    "ayats@shiva" = mkHome "aarch64-linux" [
      (./. + "/@shiva.nix")
    ];
    "ayats@viperSL4" = mkHome "x86_64-linux" [
      (./. + "/@viperSL4.nix")
      (./. + "/@wsl.nix")
    ];
  };

  flake.checks."x86_64-linux" = {
    "home-ayats@viperSL4" = config.flake.homeConfigurations."ayats@viperSL4".config.home.path;
  };
}

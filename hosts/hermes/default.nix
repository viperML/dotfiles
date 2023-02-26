{
  withSystem,
  inputs,
  config,
  ...
}: {
  flake.nixosConfigurations.hermes = withSystem "x86_64-linux" ({system, pkgs, ...}: let
    specialArgs = {
      inherit inputs;
      packages = inputs.nix-common.lib.mkPackages system inputs;
    };
  in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system specialArgs pkgs;

      modules = with config.flake; [
        inputs.nh.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        inputs.nix-common.nixosModules.default
        {
          home-manager.sharedModules = [inputs.nix-common.homeModules.default];
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users.ayats.imports = [
            ./home.nix
            homeModules.common

            homeModules.hyprland
          ];
        }

        ./configuration.nix
        nixosModules.common
        # nixosModules.kde
        nixosModules.hyprland
        nixosModules.podman
        nixosModules.tailscale
      ];
    });
}
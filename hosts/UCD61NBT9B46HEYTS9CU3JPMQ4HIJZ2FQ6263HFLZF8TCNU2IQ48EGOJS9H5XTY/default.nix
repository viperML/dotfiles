{
  withSystem,
  inputs,
  config,
  ...
}: {
  flake.nixosConfigurations.UCD61NBT9B46HEYTS9CU3JPMQ4HIJZ2FQ6263HFLZF8TCNU2IQ48EGOJS9H5XTY = withSystem "x86_64-linux" ({
    pkgs,
    system,
    ...
  }: let
    specialArgs = {
      inherit inputs;
      packages = inputs.nix-common.lib.mkPackages system inputs;
    };
  in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system specialArgs;

      modules = with config.flake.nixosModules; [
        inputs.nh.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        inputs.nix-common.nixosModules.default
        {
          home-manager.sharedModules = [inputs.nix-common.homeModules.default];
          home-manager.extraSpecialArgs = specialArgs;
        }

        ./configuration.nix
        common
        kde
      ];
    });
}

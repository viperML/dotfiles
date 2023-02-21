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
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = with config.flake.newxosModules; [
        inputs.nh.nixosModules.default
        inputs.home-manager.nixosModules.home-manager

        inputs.nix-common.nixosModules.default
        inputs.nix-common.nixosModules.hm-module
        {
          inherit inputs;
        }

        ./configuration.nix
        common
        kde
      ];
    });
}

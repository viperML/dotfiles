{
  withSystem,
  inputs,
  config,
  ...
}: {
  flake = withSystem "x86_64-linux" ({
    system,
    pkgs,
    ...
  }: {
    nixosConfigurations.hermes = let
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

              homeModules.sway
              # homeModules.emacs
            ];
          }

          ./configuration.nix
          nixosModules.common
          nixosModules.sway
          nixosModules.podman
          nixosModules.tailscale

          nixosModules.user-ayats

          # inputs.nixified-ai.nixosModules.invokeai-amd
          # (args: {
          #   services.invokeai.enable = true;
          #   systemd.services.invokeai.wantedBy = args.lib.mkForce [];
          # })
        ];
      };
  });
}

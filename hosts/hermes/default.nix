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
            home-manager.sharedModules = [
              inputs.nix-common.homeModules.default
              ./home.nix
              homeModules.common
            ];
            home-manager.extraSpecialArgs = specialArgs;
          }

          ./configuration.nix
          nixosModules.common
          nixosModules.user-ayats
          nixosModules.user-soch

          # nixosModules.podman
          nixosModules.tailscale
          # nixosModules.docker
          nixosModules.containerd
          (args: {programs.nix-ld.package = args.packages.nix-ld.default;})

          {services.xserver.displayManager.autoLogin.user = "ayats";}
          # nixosModules.sway
          nixosModules.hyprland
          # nixosModules.plasma5

          inputs.disko.nixosModules.default
          ./disks.nix

          # inputs.nixified-ai.nixosModules.invokeai-amd
          # (args: {
          #   services.invokeai.enable = true;
          #   systemd.services.invokeai.wantedBy = args.lib.mkForce [];
          # })
        ];
      };
  });
}

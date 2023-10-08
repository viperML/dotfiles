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
        inherit specialArgs pkgs;

        modules = with config.flake; [
          #-- Core
          inputs.nixpkgs.nixosModules.readOnlyPkgs
          {nixpkgs.pkgs = pkgs;}
          inputs.nh.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          inputs.nix-common.nixosModules.default
          {
            home-manager.sharedModules = [
              inputs.nix-common.homeModules.default
              ./home.nix
              homeModules.common
              homeModules.browser
            ];
            home-manager.extraSpecialArgs = specialArgs;
          }

          #-- Host-specific
          ./configuration.nix
          nixosModules.common
          nixosModules.user-ayats
          nixosModules.user-soch

          #-- Disks
          inputs.disko.nixosModules.default
          ./disks.nix

          #-- Environment
          {services.xserver.displayManager.autoLogin.user = "ayats";}
          # nixosModules.sway
          # nixosModules.hyprland
          # nixosModules.plasma5
          nixosModules.gnome

          #-- Other
          # nixosModules.podman
          nixosModules.tailscale
          # nixosModules.docker
          nixosModules.containerd
          (args: {programs.nix-ld.package = args.packages.nix-ld.default;})
        ];
      };
  });
}

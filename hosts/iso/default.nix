inputs @ {self, nixpkgs, ...}: let
  inherit (inputs) nixpkgs;
  system = "x86_64-linux";
  modulesPath = "${nixpkgs}/nixos/modules";
  pkgs = self.legacyPackages.${system};
in
  nixpkgs.lib.nixosSystem {
    inherit system pkgs;
    specialArgs = {
      inherit self inputs;
      packages = self.lib.mkPackages inputs system;
    };
    modules = [
      "${modulesPath}/installer/cd-dvd/installation-cd-base.nix"
      ./configuration.nix
      inputs.nix-common.nixosModules.channels-to-flakes

      inputs.nixos-hardware.nixosModules.microsoft-surface
    ];
  }

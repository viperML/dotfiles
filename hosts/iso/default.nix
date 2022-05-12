inputs @ {self, ...}: let
  inherit (inputs) nixpkgs;
  system = "x86_64-linux";
  modulesPath = "${nixpkgs}/nixos/modules";
  pkgs = self.legacyPackages.${system};
in
  nixpkgs.lib.nixosSystem {
    inherit system pkgs;
    specialArgs = {inherit self inputs;};
    modules = [
      "${modulesPath}/installer/cd-dvd/installation-cd-base.nix"
      ./configuration.nix
      # self.nixosModules.common
      inputs.nixos-flakes.nixosModules.channels-to-flakes
    ];
  }

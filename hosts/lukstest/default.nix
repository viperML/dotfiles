{
  self,
  inputs,
}: let
  system = "x86_64-linux";

  nixpkgs-src = self.lib.patch-nixpkgs {
    nixpkgs = inputs.nixpkgs-master;
    PRS = [
      {
        PR = "168554";
        sha256 = "sha256-t+2LgUdbKbpxtT1wax2PCmzwGFQLrHJOs1QbskNVqV4=";
        exclude = ["*/all-tests.nix"];
      }
    ];
    pkgs = self.legacyPackages.${system};
  };
  nixosSystem = args: import "${nixpkgs-src}/nixos/lib/eval-config.nix" args;
  modulesPath = "${nixpkgs-src}/nixos/modules";
in
  nixosSystem rec {
    inherit system;
    pkgs = self.legacyPackages.${system};
    specialArgs = {inherit self inputs;};
    modules = with self.nixosModules; [
      ./configuration.nix
      (modulesPath + "/profiles/qemu-guest.nix")
      (modulesPath + "/profiles/minimal.nix")
      inputs.nixos-flakes.nixosModules.channels-to-flakes
    ];
  }
